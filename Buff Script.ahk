;------------------------------------------------------------------
; ROSE Online AUTO-Cleric Script.
;
; This Script will enable you to take a cleric with you and control
; Healing, Curing, Buffing from guest client window.
;
; Date    : May 2017
; Version : 1.10
; Author  : Neanne
;
; Revisions: 	1.10: Don't cast skills you don't have.
;				1.00: First version
;
; Like it ? Send me a present ingame. I Love item mall points :)
;------------------------------------------------------------------

#SingleInstance, Force
#MaxThreadsPerHotkey 2
#Persistent
#NoEnv

;-- Yes, we use an ini file to store key bindings. 
IniFile = settings.ini

;-- Read Function keys for HealBar, Cure and Resurect
IniRead HealBar, %IniFile%, SkillBars, HealingSkillBar								;-- Skill Bar that contains the Healing Skills
IniRead Cure, %IniFile%, Healing, Cure									;-- Skill Bar that contains the Cure and Resurect Skills

;-- Where is the resurect skill?
IniRead Ressurect, %IniFile%, Healing, Ressurect

;-- Where is the Bonefire Skill ?
IniRead SummonBar, %IniFile%, SkillBars, SummonSkillBar						;-- Where are your summons?
IniRead BoneFire, %IniFile%, Summons, BoneFire				            ;-- Where is the bonefire skill?

;-- Read Function key Shortcuts for Buffer Bar
IniRead NormalBuffBar, %IniFile%, SkillBars, BuffingSkillBar			;-- Normal Buff: where is it ?
IniRead HittingSupport, %IniFile%, BuffSkills, HittingSupport			;-- Normal Buff: where is it ?
IniRead BattleSupport, %IniFile%, BuffSkills, BattleSupport				;-- Normal Buff: where is it ?
IniRead DamageSupport, %IniFile%, BuffSkills, DamageSupport				;-- Normal Buff: where is it ?
IniRead SharpenSupport, %IniFile%, BuffSkills, SharpenSupport			;-- Normal Buff: where is it ?
IniRead PowerSupport, %IniFile%, BuffSkills, PowerSupport				;-- Normal Buff: where is it ?
IniRead Support, %IniFile%, BuffSkills, Support							;-- Normal Buff: where is it ?

;-- Read Party Skills
IniRead PartyBar, %IniFile%, SkillBars, PartySkillBar
IniRead BlessingBody, %IniFile%, PartySkills, BlessingBody				;-- Where is Blessing Body (F..)
IniRead BlessingMind, %IniFile%, PartySkills, BlessingMind				;-- Where is Blessing Mind (F..)
IniRead PartyHealing, %IniFile%, PartySkills, PartyHealing				;-- Where is Party Healing (F..)

;-- Read Default Delays
IniRead BuffDelay, %IniFile%, Delays, BuffDelay							;-- Default delay inbetween buffs.

gosub ^i

ContHealing:=0				; Flag that Continuous Party Healing is Active, Also stops it when set to 0
ContCuring:=0				; Flag that Continuous Curing is Active, Also stops it when set to 0
bSpamActive:=0			; Flag Indicating that some spamming loop is active.

bMustBuff:=0			;-- Interrupt Flag
bMustPartyBuff:=0		;-- Interrupt Flag
bMustRessurect:=0		;-- Interrupt Flag
bMustBonefire:=0		;-- Interrupt Flag

;-- Default Skill and Spam Delays
SpamDelay:=1000				; 1000ms between spam skill
CureDelay:=2500				; Cure takes 2.5 seconds to cast.
PartyHealDelay=5500			; Party Heal Delay is 5.5 seconds.

;-- Location of Tooltips
wX:=25
wY:=160

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
	ToolTip, Buff Script by Neanne`n`nCTRL + W`t: Select Cleric Window`n`nCTRL + C`t: Cure`nCTRL + B`t: Full Buff`n`nCTRL + A`t: SPAM Cure (AutoHeal)`nCTRL + H`t: SPAM Party Heal`nCTRL + P`t: Party Buffs`nCTRL + R`t: Ressurect`nCTRL + F`t: Summon BoneFire`nCTRL + S`t: Stop Spam Heal`n`n pgUp`t: Faster Spam`n pgDwn`t: Slower Spam`n=`t: Reset Delays`n`n`nCTRL + I : Get Info`n`nCTRL+END`t: Suspend Script,wX,wY
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

^b::       ; Buffs
{
  bMustBuff:=1
  
  if (bSpamActive=0){
	 ;-- Buffing Sub is checked from Loops;
	 ;-- And executed when bMustBuff is 1;
	 ;-- So Manually execute it now, because we are not spamming.
	 goSub, Buff
  } else {
	 ;-- We are runninng in another loop; so we must wait until that thread has time.
	 Tooltip,** Normal Buffs Request **,wX,wY
	 SetTimer, RemoveToolTip, 2500  
  }
  
  return
 }

^p::		;Party Buffs
{
  bMustPartyBuff:=1
  
  if (bSpamActive=0){
	goSub, PartyBuff
  } else {
	Tooltip,** Party Buffs Request **,wX,wY
	SetTimer, RemoveToolTip, 2500  
  }
  
  return
}

^f::	; Summon BoneFire
{
	bMustBoneFire:=1
  
	if (bSpamActive=0){
	   ;-- Buffing Sub is checked from Loops;
	   ;-- And executed when bMustBuff is 1;
	   ;-- So Manually execute it now, because we are not spamming.
	   goSub, BoneFire
	} else {
	   ;-- We are runninng in another loop; so we must wait until that thread has time.
	   Tooltip,** BoneFire Requested **,wX,wY
	   SetTimer, RemoveToolTip, 2500  
	}
  
  return
}

^s::
{ 
  Tooltip,Continuous Cure/Party Healing OFF,wX,wY
  SetTimer, RemoveToolTip, 2500
  ContHealing:=0
  ContCuring:=0
  Return
}

^a::
{
  Tooltip,Continuous Cure ON,wX,wY
  
  ;-- Set a Condition for the loop. CTRL-S will stop this loop.
  ContCuring=1			;-- Continuous Healing is active now, others must stop
  ContHealing=0			;-- Stop Continuous Party Healing
  
  ;-- Select the Cure Bar.
  ControlSend, , {%HealBar%}, ahk_pid %active_id%
  Sleep, 100
  
  Loop{
	;-- ContCuring Flag is controlled by CTRL-S. If pressed, spamming is stopped.
    if(ContCuring=1){
		;-- Indicate the spam Flag so other actions know that we are spamming !
		bSpamActive:=1
		
		;-- Cure has a delay by itself; we need to add this delay to the default delay
		;-- to prevent skill spamming.
		ToolTip, AUTO-CURE Active,wX,wY
		SetTimer, RemoveToolTip, %CureDelay%
		
		;-- Send the Cure!
		ControlSend, , {%Cure%}, ahk_pid %active_id%
		Sleep, %CureDelay%
		Sleep,10
	   
		bInterrupted=0			;--- Don't know if there are interrupts waiting.
	    
		;-- Check Interrupts before continuing
		if (bMustBuff=1){
		   bInterrupted=1
		   gosub, Buff
		}
		
		if (bMustPartyBuff=1){
		   bInterrupted=1
		   gosub, PartyBuff
		}
		
		if (bMustBoneFire=1){
			bInterrupted=1
			goSub, BoneFire
		}
		
		if (bMustRessurect=1){
			bInterrupted=1
			;--Do Resurect
		}
		
		;-- Interrupts Finished.
		if (bInterrupted=0){
			;-- Finish the normal cycle and wait the delay.
			Sleep, %SpamDelay% 
		} else {
		    ;-- We had an interrupt; reset the skillbar for this loop!
		    ControlSend, , {%HealBar%}, ahk_pid %active_id%
		    Sleep, 100
		}
			
	   
	   
    } else {
       bSpamActive:=0
	   break
    }
  }
return
}

^h::
{
  Tooltip,Continuous Party Healing ON,wX,wY
  
  ;-- Set a Condition for the loop. CTRL-S will stop this loop.
  ContHealing=1		;-- This spam loop is active now, stop the others
  ContCuring=0		;-- Stop Curing Loop
  
  ;-- Select Party Healing Bar.
  ControlSend, , {%PartyBar%}, ahk_pid %active_id%
  Sleep, 100
  
  Loop{
	;-- ContCuring Flag is controlled by CTRL-S. If pressed, spamming is stopped.
    if(ContHealing=1){
		;-- Indicate the spam Flag so other actions know that we are spamming !
		bSpamActive:=1
		
		;-- Cure has a delay by itself; we need to add this delay to the default delay
		;-- to prevent skill spamming.
		ToolTip, AUTO Party Heal Active,wX,wY
		SetTimer, RemoveToolTip, %PartyHealDelay%
		
		;-- Send the Cure!
		ControlSend, , {%PartyHealing%}, ahk_pid %active_id%
		Sleep, %PartyHealDelay%
		Sleep,10
	   
		bInterrupted=0			;--- Don't know if there are interrupts waiting.
	    
		;-- Check Interrupts before continuing
		if (bMustBuff=1){
		   bInterrupted=1
		   gosub, Buff
		}
		
		if (bMustPartyBuff=1){
		   bInterrupted=1
		   gosub, PartyBuff
		}
		
		if (bMustBoneFire=1){
			bInterrupted=1
			goSub, BoneFire
		}
		
		if (bMustRessurect=1){
			bInterrupted=1
			;--Do Resurect
		}
		
		;-- Interrupts Finished.
		if (bInterrupted=0){
			;-- Finish the normal cycle and wait the delay.
			Sleep, %SpamDelay% 
		} else {
		    ;-- We had an interrupt; reset the skillbar for this loop!
		    ControlSend, , {%PartyBar%}, ahk_pid %active_id%
		    Sleep, 100
		}
		
    } else {
       bSpamActive:=0
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
{
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
}
	
Buff:
{
  if (bMustBuff=1){
	  ControlSend, , {%NormalBuffBar%}, ahk_pid %active_id%
	  Sleep, 100
	  
	  if (HittingSupport!=""){
		 ToolTip, Buff: Hitting Support,wX,wY
		 ControlSend, , {%HittingSupport%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }
	  
	  if (BattleSupport!=""){
		 ToolTip, Buff: Battle Support,wX,wY
		 ControlSend, , {%BattleSupport%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }
	  
	  if (DamageSupport!=""){
		 ToolTip, Buff: Damage Support,wX,wY
		 ControlSend, , {%DamageSupport%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }
	  
	  if (SharpenSupport!=""){
		 ToolTip, Buff: Sharpen Support,wX,wY
		 ControlSend, , {%SharpenSupport%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }
	  
	  if (PowerSupport!=""){
		 ToolTip, Buff: Power Support,wX,wY
		 ControlSend, , {%PowerSupport%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }
	  
	  if (Support!=""){
		 ToolTip, Buff: Support Support,wX,wY
		 ControlSend, , {%Support%}, ahk_pid %active_id%
		 Sleep, %BuffDelay%
	  }  
	  
	  ;-- Remove ToolTips
	  SetTimer, RemoveToolTip, 1000
	}
	
	;-- Buffing completed, reset the flag.
    bMustBuff=0
    return
}

;-- this piece of code will apply the party buffs.
PartyBuff:
{
	if (bMustPartyBuff=1){
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
	}
	
	bMustPartyBuff=0
	
	return
}

BoneFire:
{
	if (bMustBoneFire=1){
		Tooltip,Summon a BoneFire,wX,wY
		SetTimer, RemoveToolTip, 1500
  
		ControlSend, , {%SummonBar%}, ahk_pid %active_id%
		Sleep, 100
		ControlSend, , {%BoneFire%}, ahk_pid %active_id%
		Sleep, 100
	}
	
	bMustBoneFire=0
	
	return
 }