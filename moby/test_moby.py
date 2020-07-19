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

    moby.run()
    result = "".join(showlines)
    verify(result + "\n")
