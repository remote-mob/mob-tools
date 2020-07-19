import time
import subprocess


def wait(seconds):
    time.sleep(seconds)


def show(msg):
    print(msg, flush=True, end="")


def git(*args):
    try:
        subprocess.run(["git"] + list(args), capture_output=True)
    except subprocess.CalledProcessError:
        pass
