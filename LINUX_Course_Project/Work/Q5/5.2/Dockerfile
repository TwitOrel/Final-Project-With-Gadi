FROM ubuntu:latest

RUN apt update && apt install -y python3 python3-pip nano imagemagick

WORKDIR /app

COPY plant-improved.py /app/plant-improved.py
COPY requirements.txt /app/requirements.txt

RUN pip3 install --break-system-packages -r requirements.txt

ENTRYPOINT ["python3", "plant-improved.py"]

