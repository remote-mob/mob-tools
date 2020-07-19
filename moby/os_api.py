import time
import subprocess


def wait(seconds):
    time.sleep(seconds)


def show(msg):
    print(msg, flush=True, end="")


def git(*args):
    try:
        result = subprocess.run(["git"] + list(args), capture_output=True)
        return result.stdout.decode("utf8")
    except subprocess.CalledProcessError:
        return ""
