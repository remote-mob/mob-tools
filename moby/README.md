Problem
=======

Allmänt: handovers tar mer än 1 minut.

* git commit meddelanden skrivs slarvigt ibland, bra ibland (och tar mycket tid)

* för att mäta tid har vi switchat mellan mobiler, online timers (inkl vår egen) eller glömt bort. Oavsett tar det energi och tid att välja verktyg varje session, och att komma ihåg att switcha.

* ibland glömmer man att göra git pull (och det är alltid något som tar tid för ny driver)


Lösningsförslag
---------------

Bygg ett Pythonscript `moby.py` som kontinuerligt uppdaterar lokalt repo och pushar ändringar, samt skriver ut när det är dags att switcha. Exempel på output:

```
Running moby.
6 minutes left until switch.
Updating repo...
Repo updated.
Waiting 5 seconds.
Updating repo...
Repo updated.
...
5 minutes left until switch.
Updating repo...
Repo updated.
Waiting 5 seconds.
...
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
Updating repo...
Repo updated.
Waiting 5 seconds.
...
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

