import pandas as pd
import pickle
import re
import numpy as np
from scipy.sparse import hstack
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score, precision_score,
    recall_score, f1_score, classification_report, confusion_matrix
)
from sklearn.preprocessing import StandardScaler
from sklearn.utils import resample
from scipy.sparse import csr_matrix

# ==========================
# TEXT PREPROCESSING
# ==========================
def preprocess_text(text):
    text = str(text).lower()
    text = re.sub(r'http\S+|www\S+|https\S+', ' ', text)
    text = re.sub(r'\S+@\S+', ' ', text)
    text = re.sub(r'[^a-zA-Z0-9\s]', ' ', text)
    text = re.sub(r'\b\d+\b', ' ', text)
    text = ' '.join(text.split())
    return text

# ==========================
# LINGUISTIC FEATURE EXTRACTOR
# These catch fake news patterns TF-IDF misses
# ==========================
def extract_linguistic_features(texts):
    features = []
    
    clickbait_words = [
        'shocking', 'bombshell', 'exclusive', 'breaking',
        'exposed', 'secret', 'conspiracy', 'miracle', 'eliminate',
        'completely', 'never', 'always', 'proof', 'confirmed',
        'anonymous', 'sources say', 'insiders', 'urgent',
        'deep state', 'mainstream media', 'they dont want',
        'wake up', 'sheeple', 'globalist', 'new world order',
        'cover up', 'coverup', 'whistleblower', 'suppressed',
        'banned', 'censored', 'truth they hide'
    ]
    
    credible_words = [
        'according to', 'reported', 'announced', 'stated',
        'research', 'study', 'published', 'university',
        'percent', 'data', 'analysis', 'official', 'government',
        'conference', 'journal', 'scientists', 'researchers'
    ]

    # NEW: conspiracy theory patterns
    conspiracy_words = [
        'mind control', 'chemtrails', 'microchip', 'depopulation',
        'illuminati', 'lizard', 'flat earth', 'crisis actor',
        'false flag', 'staged', 'hoax', 'plandemic', 'agenda',
        'chemicals in', 'water supply', 'vaccine causes',
        'they are putting', 'government putting', 'secretly putting',
        'poison', 'control the population', 'mass surveillance'
    ]
    
    for text in texts:
        text_lower   = str(text).lower()
        words        = text_lower.split()
        word_count   = max(len(words), 1)
        
        caps_ratio      = sum(1 for c in str(text) if c.isupper()) / max(len(str(text)), 1)
        exclaim_count   = str(text).count('!')
        question_count  = str(text).count('?')
        clickbait_count = sum(1 for w in clickbait_words if w in text_lower)
        all_caps_words  = sum(1 for w in str(text).split() if w.isupper() and len(w) > 2)
        credible_count  = sum(1 for w in credible_words if w in text_lower)
        avg_word_len    = np.mean([len(w) for w in words]) if words else 0
        unique_ratio    = len(set(words)) / word_count
        text_length     = len(str(text))
        sentence_count  = str(text).count('.') + str(text).count('!') + str(text).count('?')
        avg_sent_len    = word_count / max(sentence_count, 1)
        has_quotes      = int('"' in str(text) or "'" in str(text))
        number_count    = len(re.findall(r'\b\d+\.?\d*\b', str(text)))
        
        # NEW feature
        conspiracy_count = sum(1 for w in conspiracy_words if w in text_lower)
        
        features.append([
            caps_ratio,
            exclaim_count,
            question_count,
            clickbait_count,
            all_caps_words,
            credible_count,
            avg_word_len,
            unique_ratio,
            text_length,
            avg_sent_len,
            has_quotes,
            number_count,
            word_count,
            conspiracy_count    # NEW
        ])
    
    return np.array(features)

# ==========================
# LOAD & BALANCE DATASET
# ==========================
fake_df = pd.read_csv("Fake.csv")
real_df = pd.read_csv("Real.csv")

fake_df["label"] = 0
real_df["label"] = 1

print(f"Fake samples: {len(fake_df)}")
print(f"Real samples: {len(real_df)}")

min_size = min(len(fake_df), len(real_df))
fake_df  = resample(fake_df, n_samples=min_size, random_state=42)
real_df  = resample(real_df, n_samples=min_size, random_state=42)

df = pd.concat([fake_df, real_df], ignore_index=True)
df = df.sample(frac=1, random_state=42).reset_index(drop=True)

print(f"Balanced: {len(df)} samples")

# ==========================
# BUILD CONTENT FIELD
# ==========================
def build_content(row):
    title = str(row['title']).strip() if pd.notna(row['title']) else ""
    text  = str(row['text']).strip()  if pd.notna(row['text'])  else ""
    title_weighted = (title + " ") * 3 if title else ""
    return title_weighted + text

df["content"] = df.apply(build_content, axis=1)
df["content"]  = df["content"].apply(preprocess_text)
df = df[df["content"].str.len() > 20].reset_index(drop=True)

# Keep raw text for linguistic features
df["raw_content"] = df.apply(
    lambda r: str(r.get('title','')) + " " + str(r.get('text','')), axis=1
)

X_text = df["content"]
X_raw  = df["raw_content"]
y      = df["label"]

# ==========================
# SPLIT FIRST
# ==========================
(X_train_text, X_test_text,
 X_train_raw,  X_test_raw,
 y_train,      y_test) = train_test_split(
    X_text, X_raw, y,
    test_size=0.2,
    random_state=42,
    stratify=y
)

# ==========================
# TF-IDF (no leakage)
# ==========================
vectorizer = TfidfVectorizer(
    max_features=30000,
    stop_words="english",
    ngram_range=(1, 2),
    min_df=3,
    max_df=0.95,
    sublinear_tf=True
)

X_train_tfidf = vectorizer.fit_transform(X_train_text)
X_test_tfidf  = vectorizer.transform(X_test_text)

# ==========================
# LINGUISTIC FEATURES
# ==========================
print("Extracting linguistic features...")
X_train_ling = extract_linguistic_features(X_train_raw.tolist())
X_test_ling  = extract_linguistic_features(X_test_raw.tolist())

# Scale linguistic features
scaler       = StandardScaler()
X_train_ling = scaler.fit_transform(X_train_ling)
X_test_ling  = scaler.transform(X_test_ling)

# ==========================
# COMBINE TF-IDF + LINGUISTIC
# ==========================
X_train_combined = hstack([X_train_tfidf, csr_matrix(X_train_ling)])
X_test_combined  = hstack([X_test_tfidf,  csr_matrix(X_test_ling)])

# ==========================
# TRAIN
# ==========================
print("Training model...")
model = LogisticRegression(
    max_iter=3000,
    class_weight="balanced",
    C=0.5,
    solver="saga",
    random_state=42
    # removed n_jobs=-1
)
model.fit(X_train_combined, y_train)

# ==========================
# EVALUATE
# ==========================
y_pred = model.predict(X_test_combined)

accuracy  = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred, average="weighted")
recall    = recall_score(y_test, y_pred, average="weighted")
f1        = f1_score(y_test, y_pred, average="weighted")

print(f"\nAccuracy : {accuracy*100:.2f}%")
print(f"Precision: {precision*100:.2f}%")
print(f"Recall   : {recall*100:.2f}%")
print(f"F1 Score : {f1*100:.2f}%")
print("\nClassification Report:")
print(classification_report(y_test, y_pred, target_names=["FAKE", "REAL"]))
print("Confusion Matrix:")
print(confusion_matrix(y_test, y_pred))

# ==========================
# SANITY CHECK
# ==========================
def predict_single(text):
    processed = preprocess_text(text)
    tfidf     = vectorizer.transform([processed])
    ling      = scaler.transform(extract_linguistic_features([text]))
    combined  = hstack([tfidf, csr_matrix(ling)])
    pred      = model.predict(combined)[0]
    probs     = model.predict_proba(combined)[0]
    label     = "FAKE" if pred == 0 else "REAL"
    return label, max(probs) * 100

print("\n--- SANITY CHECK ---")
test_cases = [
    ("Scientists discover new vaccine that eliminates cancer completely", "REAL"),
    ("Federal Reserve raises interest rates by 0.25 percent", "REAL"),
    ("Researchers publish study on climate change in Nature journal", "REAL"),
    ("SHOCKING BOMBSHELL: Obama secretly a lizard person EXPOSED!!!", "FAKE"),
    ("EXCLUSIVE: Hillary Clinton arrested for treason anonymous sources say", "FAKE"),
    ("Government putting mind control chemicals in water supply confirmed", "FAKE"),
]

all_passed = True
for text, expected in test_cases:
    label, conf = predict_single(text)
    status = "✓" if label == expected else "✗ WRONG"
    print(f"{status} Expected:{expected} | Got:{label} | {conf:.1f}%")
    print(f"   {text}")
    if label != expected:
        all_passed = False

print(f"\n{'✓ All passed!' if all_passed else '⚠️ Some failed — review linguistic features'}")

# ==========================
# SAVE EVERYTHING
# ==========================
model_data = {
    "model":      model,
    "vectorizer": vectorizer,
    "scaler":     scaler,
    "accuracy":   accuracy,
    "precision":  precision,
    "recall":     recall,
    "f1_score":   f1,
    "classes":    model.classes_.tolist()
}

with open("model.pkl", "wb") as f:
    pickle.dump(model_data, f)

print("\nModel saved to model.pkl")