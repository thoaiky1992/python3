Create a Virtual Environment

```shell
python3 -m venv venv
```

Activate the Virtual Environment:

```shell
source venv/bin/activate
```

Install Dependencies

```shell
pip install -r requirements.txt
```

Generate Prisma Client
```shell
prisma generate
```

Start the Application
```shell
python3 main.py
```

Run Celery worker
```shell
celery -A libraries.celery_app worker --loglevel=info
```

[Optional] Run Celery beat if you want to see the scheduled job running
```shell
celery -A libraries.celery_app beat --loglevel=info
```