import time
import subprocess


def wait(seconds):
    time.sleep(seconds)


def show(msg):
    print(msg, flush=True, end="")


def git(*args):
    try:
        subprocess.check_output(["git"] + list(args))
    except subprocess.CalledProcessError:
        pass
