import pandas as pd
import pickle
import re

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# ==========================
# TEXT PREPROCESSING
# ==========================

def preprocess_text(text):
    text = str(text).lower()

    text = re.sub(r'http\S+', ' ', text)
    text = re.sub(r'www\S+', ' ', text)
    text = re.sub(r'https\S+', ' ', text)

    text = re.sub(r'\S+@\S+', ' ', text)

    text = re.sub(r'[^a-zA-Z0-9\s]', ' ', text)

    text = ' '.join(text.split())

    return text


# ==========================
# LOAD DATASET
# ==========================

import pandas as pd

# Load datasets
fake_df = pd.read_csv("Fake.csv")
real_df = pd.read_csv("Real.csv")

# Add labels
fake_df["label"] = 0   # Fake news
real_df["label"] = 1   # Real news

# Combine datasets
df = pd.concat([fake_df, real_df], ignore_index=True)

# Shuffle data
df = df.sample(frac=1, random_state=42).reset_index(drop=True)

print(df.head())
print(df["label"].value_counts())

# ==========================
# PREPARE FEATURES
# ==========================

df["content"] = (
    df["title"].fillna("") + " " +
    df["text"].fillna("")
)
# Clean the text
df["content"] = df["content"].apply(preprocess_text)

# Features and labels
X = df["content"]
y = df["label"]

# ==========================
# TF-IDF
# ==========================

vectorizer = TfidfVectorizer(
    max_features=10000,
    stop_words="english",
    ngram_range=(1, 2),
    min_df=2
)

X_vectorized = vectorizer.fit_transform(X)

# ==========================
# SPLIT
# ==========================

X_train, X_test, y_train, y_test = train_test_split(
    X_vectorized,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)

# ==========================
# MODEL
# ==========================

model = LogisticRegression(
    max_iter=2000,
    class_weight="balanced"
)

model.fit(X_train, y_train)

# ==========================
# EVALUATE
# ==========================

y_pred = model.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred, average="weighted")
recall = recall_score(y_test, y_pred, average="weighted")
f1 = f1_score(y_test, y_pred, average="weighted")

print(f"Accuracy : {accuracy*100:.2f}%")
print(f"Precision: {precision*100:.2f}%")
print(f"Recall   : {recall*100:.2f}%")
print(f"F1 Score : {f1*100:.2f}%")

# ==========================
# SAVE MODEL
# ==========================

model_data = {
    "model": model,
    "vectorizer": vectorizer,
    "accuracy": accuracy,
    "precision": precision,
    "recall": recall,
    "f1_score": f1,
    "classes": model.classes_.tolist()
}

with open("model.pkl", "wb") as f:
    pickle.dump(model_data, f)

print("Model saved successfully.")