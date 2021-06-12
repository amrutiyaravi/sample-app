FROM python:3.7

RUN mkdir /app
COPY ./src/ /app/
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "/app/main.py"]
