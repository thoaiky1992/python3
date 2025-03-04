from celery import Celery
from celery.schedules import crontab
import os

redis_uri = os.getenv("REDIS_URI")
app = Celery("celery_app", broker=redis_uri)
app.conf.update(
    result_backend=redis_uri,
    beat_schedule={
        "add-every-2-seconds": {
            "task": "tasks.task.add",
            "schedule": 2.0,  # run every 2 seconds
            "args": (10, 10),
        },
        # 'multiply-at-noon': {
        #     'task': 'tasks.task.multiply',
        #     'schedule': crontab(hour='12', minute='6'),
        #     'args': (4, 5)
        # }
    },
    include=["tasks.task"],
)
