# ANSI-Colony-Simulator

![alpha2](https://i.imgur.com/4rUF0nV.png)

Simple life simulation presented in ANSI characters

Written in QBASIC4.5 in DOSBOX


## Alpha3

![alpha2](https://i.imgur.com/82p5OOV.png)
![alpha3](https://i.imgur.com/B7jrCUY.png)

First stage of simulation

- ANSI chars represents "ants"
- ants can create "pipes"
- and connect them to create a bigger grid
- also if they collide/stuck they can destroy pipes

Levels

- each creation can increse ant to the higher level
- each destruction can decrese ant level
- levels now do nothing beside changing sprite (char)
- at the highest level ant become a "wall", can't move and can't be destroyed
- other ant when interacting can regenerate both the other one and self to the initial state

