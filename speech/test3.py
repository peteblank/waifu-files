from transformers import pipeline
import scipy
import torch

# Load the Bark model (assuming you have a model loaded from the correct path)
synthesizer = pipeline("text-to-speech", model=".", device_map="cuda:0")
# Provide a Japanese text prompt
japanese_text = """
こんにちは、私の名前はSunoです。そして、えー、私はピザが好きです。[笑い]
でも、他にも興味があります。たとえば、三目並べをすることです。
"""

# Generate audio
speech = synthesizer(japanese_text, dim=1)

# Save audio to a .wav file
scipy.io.wavfile.write("bark_japanese_output.wav", rate=speech["sampling_rate"], data=speech["audio"],dim=1)

