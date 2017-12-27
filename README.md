# The PiTTY Project

## About the PiTTY Project
This World of Warcraft 1.12.1 "Vanilla" addon will attempt to identify people
healing using automated healing addons, such as QuickHeal.

While QuickHeal (QH) as such is not bad (or forbidden), it are sometimes used
to spam healing while hiding the brain! This addon intercept the internal QH 
communication, and keeps a list of characters found to be using the QH addon.

The addon will not prevent people from using QuickHeal - in many occasions QH
is indeed great for improving healing, but will just notify when someone is
found using QH.

## Slash commands

```/pitty stats```
Displays the list of identified QuickHealers and their total (raw) healing.
An optional parameter can be passed to the command: 
* SAY
* YELL
* PARTY
* RAID
* GUILD
This parameter will redirect the list of QH users to the selected channel.
E.g. ```/pitty stats raid``` will list QH statistics in the raid channel.


```/pitty reset```
Resets the list of QuickHealers.


```/pitty version```
Shows the version of PiTTY for you and others with PiTTY in same raid.


```/pitty help```
Displays a small help page :-)



## About PiTTY
PiTTY is named after Pitzwald: a holy priest and the priest class leader in
the &lt;Goldshire Golfclub&gt; guild on VanillaGaming.org.

Pitzwald himself was against the use of QuickHeal (for priests), and this 
addon was made to help him identify "QH slackers" in the guild.

Pitzwald stopped playing Autumn 2017, after a ban wave wiped the top of GGC
and caused &lt;Goldshire Golfclub&gt; to stop raiding activity, and although
Pitzwald himself was not banned, he quit the game for good.

RIP Pitzwald.
