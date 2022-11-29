FROM python:3.8-alpine

WORKDIR /app

RUN pip install flask

ENV FLASK_APP=hello

COPY . /app

RUN python setup.py install

CMD["flask","run"]