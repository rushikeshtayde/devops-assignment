FROM python:3.8-alpine

WORKDIR /app

RUN pip install flask

ENV FLASK_APP=hello

COPY . /app

RUN python setup.py install

EXPOSE 8081

CMD ["flask","run"]