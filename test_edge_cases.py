import sys
sys.path.append('.')
from app import get_prediction

# Test edge cases
test_cases = [
    ("Government announces new education reform initiative for public schools", "Legitimate news"),
    ("Hello", "Very short text"),
    ("", "Empty text"),
    ("123 456 789", "Only numbers"),
    ("hi there", "Too short"),
    ("http://fake.com malware click here now!!!!", "Suspicious with URLs"),
    ("This is a fake news article about aliens landing in the city today", "Medium length real test"),
]

print("=" * 80)
print("EDGE CASE TESTING - PREPROCESSING & VALIDATION")
print("=" * 80)

for text, description in test_cases:
    print(f"\n📋 Test: {description}")
    print(f"   Input: '{text[:50]}{'...' if len(text) > 50 else ''}'")
    result = get_prediction(text)
    
    if result['status'] == 'success':
        print(f"   ✓ Status: Success")
        print(f"   Prediction: {result['prediction'].upper()}")
        print(f"   Confidence: {result['confidence']}% ({result['confidence_level']})")
        if result.get('processing_note'):
            print(f"   ⚠️  {result['processing_note']}")
        print(f"   Word count: {result['word_count']}")
    else:
        print(f"   ✗ Error: {result['message']}")

print("\n" + "=" * 80)
print("✅ EDGE CASE TESTING COMPLETE")
print("=" * 80)