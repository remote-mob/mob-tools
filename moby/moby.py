from pathlib import Path
import time
import os_api


def run():
    all_good()
    # five_first_minutes()
    last_minute()


def all_good():
    folder_name = Path.cwd().name
    os_api.show(f'Running moby on repo "{folder_name}", good.\n')
    os_api.show('Branch is "moby-branch", good.\n')
    os_api.show("Branch is pristine, good.\n")


def five_first_minutes():
    for minute in [6, 5, 4, 3, 2]:
        os_api.show(f"{minute} minutes left until switch.\n")
        faked = ""
        num_decas = 6
        run_decas(num_decas)


def last_minute():
    os_api.show("1 minute left until switch.\n")
    run_decas(5)
    total = 10
    accum = 0
    for delay in [5, 1, 1, 1, 1]:
        os_api.show(f"{total-accum} seconds left until switch.\n")
        accum += delay
        os_api.wait(delay)
    os_api.show(f"1 second left until switch!\n")

    os_api.show("\n")
    os_api.show(" ****************************\n")
    os_api.show(" *** SWITCH DRIVER PLEASE ***\n")
    os_api.show(" ****************************\n")


def run_decas(decas):
    for _ in range(decas):
        os_api.show(".")
        os_api.wait(10)
    os_api.show("\n")


if __name__ == "__main__":

    run()
