FROM python:3.10

WORKDIR /app

COPY requirements.txt ./

# BUILD_TYPE = dev | docker | prod
ARG BUILD_TYPE
COPY .env.${BUILD_TYPE} .env

COPY . .

RUN python3 -m venv .venv

# Cài đặt bash và sử dụng bash shell
RUN apt-get update && apt-get install -y bash
RUN /bin/bash -c "source .venv/bin/activate && pip install --no-cache-dir -r requirements.txt && prisma generate"

COPY entry-point.sh ./entry-point.sh

RUN chmod +x ./entry-point.sh

EXPOSE 4000

CMD ["/bin/bash", "-c", "./entry-point.sh"]