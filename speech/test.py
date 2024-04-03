import torch
import soundfile as sf
from nemo.collections.tts.models import FastSpeech2Model

# Load the pre-trained FastSpeech2 model
audio_generator = FastSpeech2Model.from_pretrained("hatsune.pht")

# Provide a text input
text_input = "You can type your sentence here to get Nemo to produce speech."

# Generate audio
with torch.no_grad():
    parsed = audio_generator.parse(text_input)

# Save the audio to a WAV file
sf.write("output.wav", parsed["audio"], parsed["sampling_rate"])

# Play the audio (optional, requires IPython)
from IPython.display import Audio
Audio(parsed["audio"], rate=parsed["sampling_rate"])
