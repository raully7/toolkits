# -*- coding: utf-8

from __future__ import absolute_import

from message_queue.celery import app
from random import randint

from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)


@app.task
def random(x, y):

    logger.info('Random in range {0} + {1}'.format(x, y))

    return randint(x, y)
