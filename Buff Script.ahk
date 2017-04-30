;------------------------------------------------------------------
; ROSE Online AUTO-Cleric Script.
;
; This Script will enable you to take a cleric with you and control
; Healing, Curing, Buffing from guest client window.
;
; Date    : May 2017
; Version : 1.0
; Author  : Neanne
;
; Like it ? Send me a present ingame. I Love item mall points :)
;------------------------------------------------------------------

#SingleInstance, Force
#Persistent
#NoEnv

;-- Yes, we use an ini file to store key bindings. 
IniFile = settings.ini

;-- Read Function keys for HealBar, Cure and Resurect
IniRead HealBar, %IniFile%, Keys, HealBar								;-- Skill Bar that contains the Healing Skills
IniRead Cure, %IniFile%, HealBar, Cure									;-- Skill Bar that contains the Cure and Resurect Skills

;-- Where is the resurect skill?
IniRead Ressurect, %IniFile%, HealBar, Ressurect


;-- Read Function key Shortcuts for Buffer Bar
IniRead NormalBuffBar, %IniFile%, Keys, NormalBuffBar					;-- Normal Buff: where is it ?
IniRead HittingSupport, %IniFile%, BuffBar, HittingSupport				;-- Normal Buff: where is it ?
IniRead BattleSupport, %IniFile%, BuffBar, BattleSupport				;-- Normal Buff: where is it ?
IniRead DamageSupport, %IniFile%, BuffBar, DamageSupport				;-- Normal Buff: where is it ?
IniRead SharpenSupport, %IniFile%, BuffBar, SharpenSupport				;-- Normal Buff: where is it ?
IniRead PowerSupport, %IniFile%, BuffBar, PowerSupport					;-- Normal Buff: where is it ?
IniRead Support, %IniFile%, BuffBar, Support							;-- Normal Buff: where is it ?

;-- Read Party Skills
IniRead PartyBar, %IniFile%, Keys, PartyBar
IniRead BlessingBody, %IniFile%, PartyBuffBar, BlessingBody				;-- Where is Blessing Body (F..)
IniRead BlessingMind, %IniFile%, PartyBuffBar, BlessingMind				;-- Where is Blessing Mind (F..)
IniRead PartyHealing, %IniFile%, PartyBuffBar, PartyHealing				;-- Where is Party Healing (F..)

;-- Read Default Delays
IniRead BuffDelay, %IniFile%, Delays, BuffDelay							;-- Default delay inbetween buffs.
					

ToolTip, Buff Script by Neanne`n`nCTRL + W`t: Select Cleric Window`n`nCTRL + C`t: Cure`nCTRL + B`t: Full Buff`n`nCTRL + A`t: SPAM Cure (AutoHeal)`nCTRL + H`t: SPAM Party Heal`nCTRL + P`t: Party Buffs`nCTRL + R`t: Ressurect`nCTRL + S`t: Stop Spam Heal`n`n pgUp`t: Faster Spam`n pgDwn`t: Slower Spam`n=`t: Reset Delays`n`n`nCTRL + I : Get Info`n`nCTRL+END`t: Suspend Script,wX,wY
SetTimer, RemoveToolTip, 20000

ContHealing:=0				; Flag that Continuous Party Healing is Active, Also stops it when set to 0
ContCuring:=0				; Flag that Continuous Curing is Active, Also stops it when set to 0

;-- Default Skill and Spam Delays
SpamDelay:=1000				; 1000ms between spam skill
CureDelay:=2500				; Cure takes 2.5 seconds to cast.
PartyHealDelay=5500			; Party Heal Delay is 5.5 seconds.

;-- Location of Tooltips
wX:=30
wY:=150

^end::
{
	;Pauses or resumes the script.
	;Suspend
	ToolTip AutoCleric Script is Stopped,wx,wy
	SetTimer,RemoveToolTip,2000
	Pause,,1
	return
}
^i::
{	
	ToolTip, Buff Script by Neanne`n`nCTRL + W`t: Select Cleric Window`n`nCTRL + C`t: Cure`nCTRL + B`t: Full Buff`n`nCTRL + A`t: SPAM Cure (AutoHeal)`nCTRL + H`t: SPAM Party Heal`nCTRL + P`t: Party Buffs`nCTRL + R`t: Ressurect`nCTRL + S`t: Stop Spam Heal`n`n pgUp`t: Faster Spam`n pgDwn`t: Slower Spam`n=`t: Reset Delays`n`n`nCTRL + I : Get Info`n`nCTRL+END`t: Suspend Script,wX,wY
	SetTimer, RemoveToolTip, 5000
	return
}

=::
{
	;-- Reset Spam rates (to Normal, set by Ini-File
	SpamDelay:=1000
	SetFormat, float, 0.2
	Seconds:=SpamDelay/1000
	
	ToolTip,(SPAM) Delay is reset to %Seconds% Seconds,wX,wY
	SetTimer, RemoveToolTip, 1500
	
	return
}

PgDn::
{
	;-- Decreate spam CURE/Party Heal rates (Go Slower)
	SpamDelay+=250
	SetFormat, float, 0.2
	Seconds:=SpamDelay/1000
	ToolTip,(SPAM) Delay is now %Seconds% Seconds,wX,wY
	SetTimer, RemoveToolTip, 1500
	return
}

PgUp::
{
	;-- Increase spam CURE/Party Heal rates (Go Faster)
	SpamDelay-=250
	
	if (SpamDelay<0){
		SpamDelay:=0
	}
	SetFormat, float, 0.2
	Seconds:=SpamDelay/1000
	ToolTip,(SPAM) Delay is now %Seconds% Seconds,wX,wY
	SetTimer, RemoveToolTip, 1500
	return
}

^w::
{
  WinGet, active_id, PID, A
  Tooltip,Client windows has been set !,wX,wY
  SetTimer, RemoveToolTip, 1500
  return
}

^c::       ; Just Heal
{
  Tooltip,Cure Once,wX,wY
  SetTimer, RemoveToolTip, 1500
  
  ControlSend, , {%HealBar%}, ahk_pid %active_id%
  Sleep, 100
  ControlSend, , {%Cure%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
    
  return
}

^b::       ; Get Me a fresh set of buffs :)
{
  WasSpammingCure:=0
  WasSpammingHeal:=0
  
  ;-- Turn of Continuous Curing and make sure it is resumed.
  if (ContCuring=1) {
	ContCuring=0
	WasSpammingCure:=1
  } else {
	WasSpammingCure:=0
  }
  
  ;-- Turn off Continuous Healing and make sure it is resumed.
  if (ContHealing=1){
	ContHealing=0
	WasSpammingHeal=1
  } else {
    WasSpammingHeal=0
  }
  
  ControlSend, , {%NormalBuffBar%}, ahk_pid %active_id%
  Sleep, 500
  
  ToolTip, Buff: Hitting Support,wX,wY
  ControlSend, , {%HittingSupport%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ToolTip, Buff: Battle Support,wX,wY
  ControlSend, , {%BattleSupport%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ToolTip, Buff: Damage Support,wX,wY
  ControlSend, , {%DamageSupport%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ToolTip, Buff: Sharpen Support,wX,wY
  ControlSend, , {%SharpenSupport%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ToolTip, Buff: Power Support,wX,wY
  ControlSend, , {%PowerSupport%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ToolTip, Buff: Support Support,wX,wY
  SetTimer, RemoveToolTip, 1000
  ControlSend, , {%Support%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ;-- And Cure 
  gosub ^c
 
 ;-- Resume the spams, if any...
  if (WasSpammingCure=1){
	  goSub ^a
  }
  
  if (WasSpammingHeal=1){
	  goSub ^h
  }
  return
}

^p::		;Party Buffs
{
  WasSpammingCure:=0
  WasSpammingHeal:=0
  
  ;-- Turn of Continuous Curing and make sure it is resumed.
  if (ContCuring=1) {
	ContCuring=0
	WasSpammingCure:=1
  } else {
	WasSpammingCure:=0
  }
  
  ;-- Turn off Continuous Healing and make sure it is resumed.
  if (ContHealing=1){
	ContHealing=0
	WasSpammingHeal=1
  } else {
    WasSpammingHeal=0
  }
  
  Tooltip,Applying Party buffs,wX,wY
  SetTimer, RemoveToolTip, 7500
    
  ControlSend, , {%PartyBar%}, ahk_pid %active_id%
  Sleep, 1000
  
  Tooltip,Buffing Blessing Body,wX,wY
  SetTimer, RemoveToolTip, 1000
  ControlSend, , {%BlessingBody%}, ahk_pid %active_id%
  Sleep, %BuffDelay%

  Tooltip,Buffing Blessing Mind,wX,wY
  SetTimer, RemoveToolTip, 1000
  ControlSend, , {%BlessingMind%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  Tooltip,Buffing PartyHealing,wX,wY
  SetTimer, RemoveToolTip, 1000
  ControlSend, , {%PartyHealing%}, ahk_pid %active_id%
  Sleep, %BuffDelay%
  
  ;-- Resume the spams, if any...
  if (WasSpammingCure=1){
	  goSub ^a
  }
  
  if (WasSpammingHeal=1){
	  goSub ^h
  }

  return
}

^s::
{ 
  Tooltip,Continuous Cure/Party Healing OFF,wX,wY
  SetTimer, RemoveToolTip, 2500
  ContHealing=0
  ContCuring=0
  Return
}

^a::
{
  Tooltip,Continuous Cure ON,wX,wY
  
  ;-- Set a Condition for the loop. CTRL-S will stop this loop.
  ContCuring=1
  
  ;-- Select the Cure Bar.
  ControlSend, , {%HealBar%}, ahk_pid %active_id%
  Sleep, 100
  
  Loop{
    if(ContCuring=1){
	   ;-- Cure has a delay by itself; we need to add this delay to the default delay
	   ;-- to prevent skill spamming.
	   ToolTip, AUTO-CURE Active,wX,wY
	   SetTimer, RemoveToolTip, 1000
	
	
	   TotalDelay:=SpamDelay+CureDelay
	   ControlSend, , {%Cure%}, ahk_pid %active_id%
       Sleep, %TotalDelay%
    } else {
       break
    }
  }
return
}

^h::
{
  Tooltip,Continuous Party Healing ON,wX,wY
  ContHealing=1
  
  ;-- Select Party Healing Bar.
  ControlSend, , {%PartyBar%}, ahk_pid %active_id%
  Sleep, 100
  
  Loop{
    if(ContHealing=1){
	   ToolTip, AUTO Party HEAL,wX,wY
	   
	   TotalDelay:=SpamDelay+PartyHealDelay
       ControlSend, , {%PartyHealing%}, ahk_pid %active_id%
       Sleep, %TotalDelay% 
    } else {
       break
    }
  }
return
}

^r::       ;Resurect Char.
{ 
  ContHealing:=0
  ContCuring:=0
  
  Tooltip,Ressurect Character,wX,wY
  SetTimer, RemoveToolTip, 2500
  
  ControlSend, , {%HealBar%}, ahk_pid %active_id%
  Sleep, 10
  ControlSend, , {%Ressurect%}, ahk_pid %active_id%
  
  Tooltip,Character Resurected-restart SPAM Manually if needed.,wX,wY
  SetTimer, RemoveToolTip, 1500
  
  return
  
}


RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
