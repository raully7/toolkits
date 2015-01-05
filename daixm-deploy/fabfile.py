# coding=utf8


from fabric.api import run, hosts, execute, cd


@hosts('work@XXXX', 'work@XXXX', 'work@XXXX')
def deploy():
    with cd('website'):
        execute(git_branch)
        execute(git_reset)
        execute(git_checkout)
        execute(git_fetch)
        execute(git_pull)
        execute(restartpre)
        execute(wait_for_signal)


@hosts('work@XXXX', 'work@XXXX', 'work@XXXX')
def deploy_code_only():
    with cd('website'):
        execute(git_branch)
        execute(git_reset)
        execute(git_checkout)
        execute(git_fetch)
        execute(git_pull)


@hosts('work@XXXX')
def deploy_pre():
    with cd('website'):
        execute(git_branch)
        execute(git_reset)
        execute(git_checkout)
        execute(git_fetch)
        execute(git_pull)
        execute(restartpre)


@hosts('work@XXXX', 'work@XXXX', 'work@XXXX')
def test():
    execute(wait_for_signal)


@hosts('work@XXXX', 'work@XXXX', 'work@XXXX')
def restart_celery():
    with cd('website'):
        execute(celery_check_status)
        execute(celery_stop)
        execute(celery_check_status)
        execute(celery_start)
        execute(celery_check_status)


def git_branch():
    run('git branch')


def git_reset():
    run('git reset --hard')


def git_checkout():
    run('git checkout developing')


def git_fetch():
    run('git fetch origin')


def git_pull():
    run('git pull origin developing')


def restartpre():
    run('touch /tmp/reload_uwsgi')


def big_while(msg='', cmd='hostname'):
    ''' 阻塞直到接收到输入Y或y，期间重复运行命令cmd '''

    run('while true; do %s; echo "%s 确认请键入Y/y"; read cmd; if [ $cmd = "Y" -o $cmd = "y" ]; then break; fi; done' % (cmd, msg))


def wait_for_signal():
    ''' 接收本地输入，判断是否进行下一台机器 '''

    big_while(msg='请检查服务是否起来？')


def celery_check_status():
    big_while(msg='请检查celery的运行状态', cmd='ps aux|fgrep celery')


def celery_stop():
    run('celery multi stop worker --pidfile=log/celery-worker.pid')


def celery_start():
    run('celery multi start worker -A dist -Q ha-test,`hostname` -l info --logfile="log/celery-worker.log" --pidfile="log/celery-worker.pid"')
