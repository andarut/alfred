#!./.venv/bin/python3

from TTS.api import TTS
from os import environ

print("Downloading model...")
environ["COQUI_TOS_AGREED"] = "1"
tts = TTS("xtts_v2.0.2")
