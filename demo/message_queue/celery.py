# -*- coding: utf-8

from __future__ import absolute_import
from celery import Celery

app = Celery('test',
             broker=['amqp://rab:rdIFutTpj1j3@online-1:5672/daixm', 'amqp://rab:rdIFutTpj1j3@online-2:5672/daixm', 'amqp://rab:rdIFutTpj1j3@online-3:5672/daixm', 'amqp://rab:rdIFutTpj1j3@online-4:5672/daixm'],
             backend='amqp',
             include=['message_queue.tasks'])

# Optional configuration, see the application user guide.
app.conf.update(
    # 开4个进程
    CELERYD_CONCURRENCY=4,
    # 任务默认两小时内失效
    CELERY_TASK_RESULT_EXPIRES=7200,
    # 时区设置
    CELERY_ENABLE_UTC=False,
    CELERY_TIMEZONE='Asia/Shanghai',
    # 队列设置
    CELERY_DEFAULT_QUEUE='ha-test',
    # 并发设置
    CELERY_QUEUE_HA_POLICY='all',
)

if __name__ == '__main__':
    app.start()
