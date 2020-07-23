from approvaltests import verify

import moby
import os_api


def setup_os_api():
    showlines = []

    def fake_show(showmsg):
        showlines.append(showmsg)

    os_api.wait = lambda *args: True
    os_api.show = fake_show
    os_api.git = lambda *args: "On branch moby-branch"

    return showlines


def test_happy_path():
    showlines = setup_os_api()
    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")


def test_happy_path_run_twice():
    showlines = setup_os_api()
    moby.run_once()
    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")


def test_not_on_moby_branch():
    showlines = setup_os_api()
    git_status_output = """\
On branch master
nothing to commit, working tree clean
"""
    os_api.git = lambda *args: git_status_output

    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")
