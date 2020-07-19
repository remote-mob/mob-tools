from pathlib import Path
import time
import os_api


def run_once():
    if not all_good():
        return False
    five_first_minutes()
    last_minute()


def all_good():
    folder_name = Path.cwd().name
    os_api.show(f'Running moby on repo "{folder_name}", good.\n')
    if not branch_ok():
        return False
    os_api.show('Branch is "moby-branch", good.\n')
    os_api.show("Branch is pristine, good.\n")


def five_first_minutes():
    for minute in [6, 5, 4, 3, 2]:
        os_api.show(f"{minute} minutes left until switch.\n")
        run_sync_periods(6)


def last_minute():
    os_api.show("1 minute left until switch.\n")
    run_sync_periods(5)
    accum = 0
    for delay in [5, 1, 1, 1, 1]:
        os_api.show(f"{10-accum} seconds left until switch.\n")
        accum += delay
        os_api.wait(delay)
    os_api.show(f"1 second left until switch!\n")
    os_api.wait(delay)

    os_api.show("\n")
    os_api.show(" ****************************\n")
    os_api.show(" *** SWITCH DRIVER PLEASE ***\n")
    os_api.show(" ****************************\n")


def run_sync_periods(num_10s_periods):
    for _ in range(num_10s_periods):
        sync()
    os_api.show("\n")


def sync():
    os_api.git("pull")
    os_api.git("add", ".")
    os_api.git("commit", "-m", "moby commit")
    os_api.git("push")
    os_api.show(".")
    os_api.wait(10)


if __name__ == "__main__":
    while True:
        run_once()
