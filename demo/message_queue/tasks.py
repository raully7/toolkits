# -*- coding: utf-8

from __future__ import absolute_import

from message_queue.celery import app
from random import randint


@app.task
def random(x, y):
    return randint(x, y)
