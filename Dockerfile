FROM python:3.11-slim

COPY ./requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

COPY ./thumbnailer/ /thumbnailer

CMD ["gunicorn", "-w", "2", "-b", ":8080", "thumbnailer.main:app"]