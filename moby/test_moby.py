from approvaltests import verify

import moby


def test_happy_path():
    import os_api

    showlines = []

    def fake_show(showmsg):
        showlines.append(showmsg)

    os_api.wait = lambda _: True
    os_api.show = fake_show
    os_api.git = lambda *args: True

    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")


def _test_happy_path_run_twice():
    import os_api

    showlines = []

    def fake_show(showmsg):
        showlines.append(showmsg)

    os_api.wait = lambda _: True
    os_api.show = fake_show
    os_api.git = lambda *args: True

    moby.run_once()
    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")


def test_moby_branch():
    import os_api

    showlines = []

    def fake_show(showmsg):
        showlines.append(showmsg)

    git_status_output = """\
On branch master
nothing to commit, working tree clean
"""
    os_api.wait = lambda _: True
    os_api.show = fake_show
    os_api.git = lambda *args: git_status_output

    moby.run_once()
    result = "".join(showlines)
    verify(result + "\n")
