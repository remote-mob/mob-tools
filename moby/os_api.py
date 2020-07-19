import time


def wait(seconds):
    time.sleep(seconds)


def show(msg):
    print(msg, flush=True, end="")
