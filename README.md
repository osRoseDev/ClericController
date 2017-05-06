# ClericController
> A Rose Online Autohotkey Script for controlling your Cleric from the client window.
> Created by FransK a.k.a. Neanne
> Version 1.3; May 2017

## Features:
* Cure (Once)
* Cure (Continuous)
* Party Heal (Continous)
* Give Buffs
* Give Party Buffs
* Resurect
* Call your cleric to your position
* Cleric take MP
* Cleric take HP
* Cleric use a BoneFire
* Pause Script
* Skips any buffs that are not defined (without delay)
* All delays are configurable in the ini file.
* Includes a compile script so you can make an .exe

## Requirements
* Download and install Authotkey 2.x  (32-bit) [via this link](https://www.autohotkey.com/download)

## Configure the INI file
**Important note: It seems impossible to reliably use the F10 (2nd) skillbar in windows 10. My advice is not to use the 2nd Skill Bar. **
* In the ini file you will find a section named "SkillBars". Assign your F9,F11,F12 bars here.


````
[SkillBars]
 BuffingSkillBar=F11
 HealingSkillBar=F9
 PartySkillBar=F12
 SummonSkillBar=F9
 FoodBar=F9
 BasicBar=F9
````


> *In this section you will choose and assign the skillbars for each set of functions. It is allowed to have multiple skills or functions on the same bar. In this example, Healing, Bonefire and HP/MP are on the same skillbar.

When you have set your bars, it's time to assign the skills to their function keys.
````
[Basic]
;-- Alt 4; Kiss is abused to call the cleric to your position
;-- This skill is on your alt bar; so the Key assignment is a bit different.
Kiss={ALT}{4}			

[Food]
HPPots=F4
MPPots=F5

[Summons]
BoneFire=F7

;Location of Cure Skill
[Healing]
Cure=F8
Ressurect=F5

;Location of Buff Skills
[BuffSkills]
HittingSupport=F4
BattleSupport=
DamageSupport=
SharpenSupport=
PowerSupport=F5
Support=F6

;Location of Party Buff Skills
[PartySkills]
BlessingBody=F2
BlessingMind=F3
PartyHealing=F8
````
**Important: if you don't have a skill, leave the key assignment empty !**
## Running the script
- This script requires administrative privileges, because the Rose Client requires administrative privileges.
- When script has started, switch to your cleric Window and press CTRL-W. This makes sure the keystrokes are send to the client.

## Shortcut Keys
Key    | Function       | Help
-------|----------------|-------
CTRL-W | Bind Window| Select your cleric window and press this Key. the script now knows your cleric instance.
CTRL-A | Spam Auto-Heal | Cleric targets you with 'Cure' every set interval.
CTRL-H | Spam Party Heal | Cleric targets all party  members with 'Heal'
CTRL-S | Stop Spammming | Stop Auto-Cure / Auto-Heal
CTRL-B | Buff Please | Sends command to Buff as soon as possible
CTRL-P | Party Buffs Please | Ask Cleric for Party Buffs as soon as possible
CTRL-R | Ressurect Please | Performs ressurect, but stops any spam healing
CTRL-F | Create a BoneFire | Ask cleric to setup a bonefire asap.
CTRL-I | Display all shortcut keys | the Help
PageUp | Faster Healing/Curing | Decrease the spam delay by 0.25 secs
PageDown | Slow down on Healing / Curing | Increases the spam delay by 0.25 secs
   =     | reset to default delay | Sets spam delay to 2.0 seconds
 [ -or- Mousewheel Right     | Make cleric eat some HP / Potions | Handy to rescue your cleric if under attack
 ]       | Make Cleric consume some Mana / Mana Potions | Drink asap
 HOME -or- Mousewheel Left     | Call cleric to your position | Uses the kiss skill to get the cleric at your position
CTRL-END | Pause the script | you will need to restart the script.

## Troubleshooting
Cleric not moving: Make sure the chat mode on the cleric is off. You will see alot of numbers on the chatbar. Remove the text and make sure the client is set to 'Enter' Chatmode.