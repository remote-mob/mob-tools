Problem
=======

Generally: handovers take around 1 minute, that a considerable overhead with 6 minute per driver.

* git pull, git push takes time for each driver / switch

* git commit messages vary in quality, and take time and effort to write

* the method to measure time has varied a lot; sometimes mobile phones, sometimes online timers (including our own lamdera based) or even been forgotten altogether. In any case, this steals energy and time every session. So let's add another method :D


Solution proposition/hypothesis
-------------------------------

It is enough to have a Python script that continuously synchronizes the local repo (automates the git pull, add, commit and push commands) and writes timer messages on terminal when it is time to switch driver.

Each mob member needs to start the script at the beginning of a session, but that it all.

In case a driver session takes more than 6 minutes, it is a matter of stopping the script locally for the mob members, and re-start the script.

Simplicity, grokkability.

Sample output from `moby.py`:

```
Running moby on repo "moby", good.
Branch is "moby-branch", good.
Branch is pristine, good.
6 minutes left until switch.
......
5 minutes left until switch.
......
4 minutes left until switch.
......
3 minutes left until switch.
......
2 minutes left until switch.
......
1 minute left until switch.
.....
10 seconds left until switch.
5 seconds left until switch.
4 seconds left until switch.
3 seconds left until switch.
2 seconds left until switch.
1 second left until switch!

 ****************************
 *** SWITCH DRIVER PLEASE ***
 ****************************
6 minutes left until switch.
......
5 minutes left until switch.
...
O.S.V
```


Dependencies and platforms
--------------------------

Built to be run on "the big three": MacOSX, Windows, Linux.

Depends on Python3.6+ available on system.


Install and use
---------------
Install: Clone this repo.

Use:

    cd /path/to/gitrepo_to_mob_on
    git co -b moby-branch
    python3 /path/to/moby/moby.py

