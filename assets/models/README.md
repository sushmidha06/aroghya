# Gemma 3B Model Integration

## Model Setup Instructions

To use the Gemma 3B model for on-device inference, you need to:

### Option 1: Download Pre-converted TFLite Model
1. Download the Gemma 3B model converted to TensorFlow Lite format
2. Place the model file as `gemma_3b_medical.tflite` in this directory
3. The model should be fine-tuned for medical symptom analysis

### Option 2: Convert Gemma 3B Model Yourself
1. Download the original Gemma 3B model from Google
2. Fine-tune it on medical symptom datasets
3. Convert to TensorFlow Lite format using:
   ```python
   import tensorflow as tf
   
   # Load your fine-tuned Gemma model
   model = tf.keras.models.load_model('path/to/gemma_3b_medical')
   
   # Convert to TFLite
   converter = tf.lite.TFLiteConverter.from_keras_model(model)
   converter.optimizations = [tf.lite.Optimize.DEFAULT]
   tflite_model = converter.convert()
   
   # Save the model
   with open('gemma_3b_medical.tflite', 'wb') as f:
       f.write(tflite_model)
   ```

### Model Requirements
- File name: `gemma_3b_medical.tflite`
- Input: Tokenized symptom text (128 tokens max)
- Output: Probability distribution over medical conditions
- Size: Approximately 3-6 GB (depending on quantization)

### Fallback Behavior
If the model file is not found, the app will automatically fall back to:
- Rule-based symptom analysis
- Pattern matching algorithms
- Medical knowledge base lookup

This ensures the app remains functional even without the AI model.

### Performance Notes
- First inference may take 2-5 seconds (model loading)
- Subsequent inferences: 0.5-2 seconds
- Memory usage: 1-3 GB during inference
- Recommended: 6GB+ RAM devices for optimal performance

### Privacy Benefits
- All processing happens on-device
- No data sent to external servers
- Complete privacy for medical information
- Works offline
