FROM python:3.9
WORKDIR /app
COPY ./requirements.txt .
RUN apt-get update &&  apt-get upgrade -y iputils-ping
RUN pip install --no-cache-dir -r requirements.txt
COPY . . 
EXPOSE 5000
CMD ["python", "app.py"]
ENV DATABASE_HOST=contactdb-container
