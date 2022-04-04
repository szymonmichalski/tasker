FROM python:3.9.12
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
COPY requirements_dev.txt /code/
RUN pip install -U pip
RUN pip install -r requirements.txt
RUN pip install -r requirements_dev.txt
COPY . /code/
