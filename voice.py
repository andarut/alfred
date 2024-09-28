#!./.venv/bin/python3

import sys
import socket

# parameters
TEXT = sys.argv[1]

PORT = 3000

client_s = socket.socket()
host = socket.gethostbyname("")
client_s.bind((host, 0))
client_s.connect((host, PORT))
client_s.send(TEXT.encode())
