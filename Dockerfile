FROM python:3.10

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY .env.prod .env

COPY . .

COPY entry-point.sh ./entry-point.sh

RUN chmod +x ./entry-point.sh


EXPOSE 4000

CMD ["sh", "-c", "./entry-point.sh && python main.py"]