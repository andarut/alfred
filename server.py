#!./.venv/bin/python3

import socket
from TTS.api import TTS
from os import environ, system
import wave
import random
from playsound import playsound
from pyautogui import press

MAX_NODES = 2048

PORT = 3000

SOURCE_FILE = environ["ALFRED_SOURCE_FILE"]
LANGUAGE = environ["ALFRED_LANGUAGE"]
TMP_OUTPUT = "/tmp/alfred_tmp"

# start server
print("Starting server...")
host = socket.gethostbyname("")
server_s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_s.bind((host, PORT))
server_s.listen(MAX_NODES)

# load model
print("Loading model...")
environ["COQUI_TOS_AGREED"] = "1"
tts = TTS("xtts_v2.0.2")

# listed
print("Listening...")
while True:
	try:
		conn, addr = server_s.accept()
	except (ConnectionAbortedError, OSError) as e:
		break

	TEXT = conn.recv(1024).decode()

	print(LANGUAGE, SOURCE_FILE, TEXT)

	# wav data
	data = []

	# split for sentences and remove dot at the end
	sentences = TEXT.split(".")
	sentences.pop()

	for sentence in sentences:
		# remove space before dot
		if sentence[0] == ' ': sentence = sentence[1:]

		# generate speech for each sentence
		sentence_output = f"{TMP_OUTPUT}_{random.getrandbits(128)}"
		tts.tts_to_file(text=sentence, speaker_wav=SOURCE_FILE, language=LANGUAGE, file_path=f"{sentence_output}.wav", split_sentences=False)

		# read data from speech
		w = wave.open(f"{sentence_output}.wav", 'rb')
		data.append([w.getparams(), w.readframes(w.getnframes())])
		w.close()

	# write result data to output file
	output_file = wave.open(f"{TMP_OUTPUT}.wav", 'wb')
	output_file.setparams(data[0][0])
	for i in range(len(data)):
		output_file.writeframes(data[i][1])
	output_file.close()

	# stop all audio or video on computer
	press("pause")

	# play output file
	playsound(f"{TMP_OUTPUT}.wav")

	# clean up (remove all audio files)
	system(f"rm -f {TMP_OUTPUT}*.wav")
