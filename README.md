# ClericController
A Rose Online Autohotkey Script for controlling your Cleric from the client window.

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
* Pause Script
* Skips any buffs that are not defined (without delay)
* All delays are configurable in the ini file.
* Includes a compile script so you can make an .exe

## Requirements
* Download Authotkey 32-bit

## Configure the INI file
**Important note: It seems impossible to reliably use the F10 (2nd) skillbar in windows 10. My advice is not to use the 2nd Skill Bar. **
* more ...

## Running the script
- This script requires administrative privileges, because the Rose Client requires administrative privileges.
- When script has started, switch to your cleric Window and press CTRL-W. This makes sure the keystrokes are send to the client.

## Shortcut Keys
Key    | Function
-------|----------------
CTRL-W | Bind Window
CTRL-A | Spam Auto-Heal
CTRL-H | Spam Party Heal
CTRL-S | Stop Spammming
CTRL-B | Buff Please
CTRL-P | Party Buffs Please
CTRL-R | Ressurect Please
CTRL-I | Display all shortcut keys
PageUp | Faster Healing/Curing
PageDown | Slow down on Healing / Curing
   =     | reset to default delay
 [ -or- Mousewheel Right     | Make cleric eat some HP / Potions
 ]       | Make Cleric consume some Mana / Mana Potions
 HOME -or- Mousewheel Left     | Call cleric to your position
CTRL-END | Pause the script

