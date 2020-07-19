import time
import subprocess


def wait(seconds):
    time.sleep(seconds)


def show(msg):
    print(msg, flush=True, end="")


def git(*args):
    try:
        output = subprocess.run(["git"] + list(args), capture_output=True)
        result = output.stdout.decode("utf8")
        if type(result) == type(True):
            print(args)
            raise ""
        return result
    except subprocess.CalledProcessError:
        return ""
