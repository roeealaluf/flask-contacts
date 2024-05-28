FROM ubuntu:22.04   
FROM python:3.9
WORKDIR /app
COPY ./requirements.txt .
RUN pip install -r requirements.txt
COPY . . 
CMD python main.py
RUN apt-get update-y &&  apt-get upgrade-y
RUN python app.py 
