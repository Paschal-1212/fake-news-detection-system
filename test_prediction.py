import sys
sys.path.append('.')
from app import get_prediction

# Test with the selected text from dataset
test_text = 'Government announces new education reform'
result = get_prediction(test_text)

print('Testing with dataset text:')
print(f'Text: {test_text}')
print(f'Status: {result["status"]}')
if result['status'] == 'success':
    print(f'Prediction: {result["prediction"]}')
    print(f'Confidence: {result["confidence"]}%')
    print(f'Is Fake: {result["is_fake"]}')
    print(f'Probabilities: {result["probabilities"]}')
else:
    print(f'Error: {result["message"]}')