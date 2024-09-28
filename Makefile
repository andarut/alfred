venv:
	rm -rf .venv && python3.11 -m venv .venv
	.venv/bin/python3 -m pip install --upgrade pip setuptools wheel
	.venv/bin/python3 -m pip install -r requirements.txt

model:
	.venv/bin/python3.11 model.py

load:
	.venv/bin/python3.11 server.py &> /dev/null &

kill:
	killall Python

run:
	.venv/bin/python3.11 voice.py 'Компиляция завершена. Файл "Пустые обещания" готов к отправке. '

clear:
	rm -f voice.c voice
	rm -f server.c server

#
# future plans
#
build:
	.venv/bin/cython voice.py --embed --3str
	.venv/bin/cython server.py --embed --3str
	gcc -Os $$(python3.11-config --includes) voice.c -o voice $$(python3.11-config --ldflags) -l python$$(python3.11 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')$$(python3.11-config --abiflags)
	gcc -Os $$(python3.11-config --includes) server.c -o server $$(python3.11-config --ldflags) -l python$$(python3.11 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')$$(python3.11-config --abiflags)

demo:
	./voice 'Компиляция завершена. Файл "Пустые обещания" готов к отправке.'

reset:
	make kill && make load

builder:
	docker build --platform=linux/amd64 -t builder -f Dockerfile.builder .

runner:
	docker build --platform=linux/amd64 -t runner -f Dockerfile.runner .
