#MaxThreadsPerHotkey 3
#Persistent
#Include %A_ScriptDir%\Gdip.ahk
;#Include %A_ScriptDir%\Colorette.ahk
#SingleInstance force

	;Linked to Gits
	;Define Global variables to be used between functions / gui
		;variables for Gui
global PriestState, PwsToggle, HfToggle, HunterState, AspCheeta, DruidState
global DebugOption, KillOpt, SpamOpt, KickOpt
global originalTexts := {} ; An associative array to store original checkbox labels

		;variables for priest pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorTHP, probeColorPEN, probeColorSWP, probeColorVP, probeColorFT, probeColorPWS, probeColorSHT, probeColorRNW, probeColorHF, probeColorCAST, probeColorIF, probeColorHUM

	;variables for Hunter pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorTHP, probeColorRNG, probeColorSRPT, probeColorSHOOT, probeColorMLEE, probeColorRPTR, probeColorARC, probeColorCHIM, probeColorCONC, probeColorTRGT, probeColorASPT, probeColorPHP, probeColorCAST, probeColorHSTL, probeColorMONG, probeColorLION, probeColorKILL, probeColorWEAP

	;variables for Druid pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorCAST, probeColorTHP, probeColorWRATH, probeColorMOON, probeColorWILD, probeColorFURY, probeColorSUN, probeColorSTAR, probeColorTHORN

Gui, +AlwaysOnTop -MaximizeBox +Theme ; Add +AlwaysOnTop option to make the GUI window always on top
; Add DropDownList for Debug options
;Gui, Add, DropDownList, x2 y4 w80 vDebugOption Choose1, Debug Off|PriestBug|HunterBug|DruidBug 

; Add a slider for transparency control
Gui, Add, Slider, x87 y4 w80 h20 vTransparency gUpdateTransparency Range25-255, 175

Gui, Add, Checkbox, x12 y29 w40 h20 vKillOpt, KoS
Gui, Add, Checkbox, x63 y29 w45 h20 vSpamOpt gUpdateState, Spam
Gui, Add, Checkbox, x122 y29 w45 h20 vKickOpt, Kick
Gui, Add, Checkbox, x12 y49 w40 h20 vOption4, Opt 4
Gui, Add, Text, x70 y52 w60 h15 gCopyWeakAura +Border, ` `Weak Aura

originalTexts["PriestState"] := "Priest Rotation"
Gui, Add, Checkbox, x35 y80 w100 h20 vPriestState gToggleBold, % originalTexts["PriestState"]
Gui, Add, Checkbox, x10 y100 w85 h20 vPwsToggle, Power Shield
Gui, Add, Checkbox, x100 y100 w65 h20 vHfToggle, HolyFire
Gui, Add, GroupBox, x5 y73 w165 h50 , 
originalTexts["HunterState"] := "Hunter Rotation"
Gui, Add, Checkbox, x35 y130 w100 h20 vHunterState gToggleBold, % originalTexts["HunterState"]
Gui, Add, Checkbox, x10 y150 w85 h20 vAspCheeta, Cheetah
Gui, Add, GroupBox, x5 y123 w165 h50 , 
originalTexts["DruidState"] := "Druid Rotation"
Gui, Add, Checkbox, x35 y180 w100 h20 vDruidState gToggleBold, % originalTexts["DruidState"]
Gui, Add, GroupBox, x5 y173 w165 h50 , 

; Add a button to open Colorette
Gui, Add, Button, x12 y200 w100 h20 gOpenColorette, Pick a Color

Gui, Font, s12 ; Change the font size to 12
Gui +LastFound +ToolWindow +E0x80000 ; WS_EX_LAYERED extended style
Gui, Color, FFFFFF ; Set GUI background color to white
WinSet, Transparent, 175 ; Set transparency level (0-255)



GuiOpen:

LoadGuiPositionFromRegistry()



Loop {
	Start:
	GetGuiStates()
	if (((PriestState + HunterState + DruidState) = 0 )) {			
		Goto, Start
		Sleep 500
	}
	
	if ((PriestState + HunterState + DruidState) >= 2 ){		;Idiot prevention if 2 or more variables are true then fuck off
		GuiControl,, KillOpt, 0 
		GuiControl,, PriestState, 0 
		GuiControl,, HfToggle, 0 
		GuiControl,, PwsToggle, 0 
		GuiControl,, HunterState, 0 
		GuiControl,, AspCheeta, 0
		GuiControl,, DruidState, 0

		ResetCheckboxNames()
		Sleep 500
		Goto, Start
	}
	if (PriestState = 1) {
		
		PriestStart:
		GetGuiStates()
		Random, rand, 150, 300
		Random, randLong, 250, 450
		GetColorPriest()
		Sleep, rand 
		
		; Cast order in and out of combat
        ; Casting check
		if (probeColorCAST="0xE8D8FF") {
			Goto, PriestStart
		} else if (probeColorHP20="0xBEFF00") {
			Send, 0
			Sleep, rand
		} else if (probeColorHP25="0x06FF00") {
			Send, 6
			Sleep, rand
		} else if (probeColorHP65="0xFFA51D") {
			if (probeColorRNW!="0xADFFD1") {
				Send, 7
				Sleep, rand
			} else {
				Send, 6
				Sleep, rand
			}
		} else if (probeColorFT="0xFFFCF9") {
			Send, =
			Sleep, rand
		} else if (probeColorIF="0x3B8BFF") {
			Send, 9
			Sleep, rand
		}
		
        ; Main combat check, if combat use rotation
		if (probeColorCC="0x1705FF" || KillOpt=1) {
			if (probeColorCAST="0xE8D8FF") {
				Goto, PriestStart
			} else if (probeColorPWS="0xFF64FE" && probeColorTHP!="0x00A9FF" && PwsToggle=1) {
				Send, -
				Sleep, rand
			} else if (probeColorHUM="0xFF99BB") {
				Send, 2
				Sleep, rand
			} else if (probeColorVP="0x00F1FF" && probeColorTHP!="0x00A9FF") {
				Send, 8
				Sleep, rand
			} else if (probeColorSWP="0x7141FF" && probeColorTHP!="0x00A9FF") {
				Send, 4
				Sleep, rand
			} else if (probeColorHF="0x00FFF4" && probeColorTHP!="0x00A9FF" && HfToggle=1) {
				Send, 5
				Sleep, rand
			} else if (probeColorPEN="0xFF5118") {
				Send, 3
				Sleep, rand
			} else if (probeColorSHT="0x1A74DD") {
				Send, 1
				Sleep, rand
			}
		}
		
        ; Out of combat check
		if (probeColorCC!="0x1705FF") {
			if (probeColorHP65="0xFFA51D") {
				Send, 6
				Sleep, rand
			}
		}
	}
	
	if (HunterState = 1) {
		HunterStart:
		GetGuiStates()
		Random, rand, 150, 300
		Random, randLong, 250, 450
		GetColorHunter()
		Sleep, rand
		
        ; Cast order in and out of combat
		if (probeColorCAST="0xE8D8FF") { ; casting check
			Goto, HunterStart
		} else if (probeColorLION="0xBAAB5D") {
			Send, +4
		}
		
		; main combat check, if combat use rotation
		if (probeColorCC="0x1705FF" || KillOpt=1) { 
			if (probeColorCAST="0xE8D8FF") {
				Goto, HunterStart
			} else if (probeColorHSTL!="0x00008A") {
				Send, 0
			} else if (probeColorKILL="0x7F008C") && (probeColorTHP!="0x00A9FF") {
				Send, =
				Sleep, rand
			} else if (probeColorSRPT="0x925B00") && (probeColorRNG="0xFF13B1") && (probeColorTHP!="0x00A9FF") {
				Send, 4
				Sleep, rand
			} else if (probeColorCONC="0x355992") && (probeColorRNG="0xFF13B1") && (probeColorTRGT="0x7E9285") {
				Send, 8
				Sleep, rand
			} else if (probeColorARC="0x229200") && (probeColorRNG="0xFF13B1") {
				Send, 5
				Sleep, rand
			} else if (probeColorSHOOT="0xF7FBF7") && (probeColorRNG="0xFF13B1") {
				Send, 3
				Sleep, rand
			} else if (probeColorRNG="0x0300FF") && (probeColorASPT!="0x3E31BA") && (probeColorTRGT="0x7E9285") && (probeColorTHP!="0x00A9FF") {
				Send, +2
			} else if (probeColorMONG="0x61ECFF") && (probeColorRNG="0x0300FF") {
				Send, -
				Sleep, rand
			} else if (probeColorRPTR="0x03FFB5") && (probeColorRNG="0x0300FF") {
				Send, 2
				Sleep, rand
			} else if (probeColorMLEE="0x080C93") && (probeColorRNG="0x0300FF") {
				Send, 1
				Sleep, rand
			}
			
			Sleep, rand
		}
		
			; Out of combat check
		if (probeColorCC!="0x1705FF") { 
			if (probeColorCAST="0xE8D8FF") { ; casting check
				Goto, HunterStart
			} else if (((probeColorASPT="0x3E31BA") || (probeColorASPT="0xBA8B22")) && (AspCheeta=1)) {
				Send, +3
			}
		}
	}
	
	If(DruidState = 1){
		DruidStart:
		GetGuiStates()
		Random, rand, 150, 300
		Random, randLong, 250, 450
		GetColorDruid()
		Sleep, rand
		
			; Cast order in and out of combat
		if (probeColorCAST="0xE8D8FF") { ;casting check
			Goto, DruidStart	
		} else if (probeColorWILD="0x991569") {
			Send, =
			Sleep, rand
		} else if (probeColorHP65="0xFFA51D") {
			Send, 4 
			Sleep, rand
		} else if (probeColorTHORN="0x35E3DA") {
			Send, - 
			Sleep, rand
		}
		
		if (probeColorCC="0x1705FF" || KillOpt=1) { ;main combat check, if combat use rotation53
			if (probeColorCAST="0xE8D8FF") { ;casting check
				Goto, DruidStart	
			} else if (probeColorSTAR="0xE2A7FF") {
				Send, 6
				Sleep, rand
			} else if (probeColorMOON="0xFF35E1") {
				Send, 3
				Sleep, rand
			} else if (probeColorSUN="0x006CFF") {
				Send, 5
				Sleep, rand
			} else if (probeColorWRATH="0x03FFB5") {
				Send, 2
				Sleep, rand
			}
		}
		
		if (probeColorCC!="0x1705FF") { ;out of combat check
			if (probeColorCAST="0xE8D8FF") { ;casting check
				Goto, DruidStart	
			} else if (probeColorFURY="0xFFF917") {
				Send, 4
				Sleep, rand
			}
		}
		
	}
	
	
	
}

;HotKeys start Here
	;Spam Num keys
	$1::SpamOrSend(1)
	$2::SpamOrSend(2)
	$3::SpamOrSend(3)
	$4::SpamOrSend(4)
	$5::SpamOrSend(5)
	$6::SpamOrSend(6)
	$7::SpamOrSend(7)
	$8::SpamOrSend(8)
	$9::SpamOrSend(9)
	$0::SpamOrSend(0)
	Return
	SpamOrSend(checkkey){
	    if (SpamOpt = 1){
        	Spam(checkkey)
		} else {
        ; Send key down
        SendInput, {%checkkey% down}
        ; Wait for key up event
        KeyWait, %checkkey%
        ; Send key up
        SendInput, {%checkkey% up}
		}   
	 }
	

	$^3:: ; Used for finding color values
	GetGuiStates()
	
	Switch DebugOption {
		Case "Debug Off":
		Send, 3
		
		Case "PriestBug":
		GetColorPriest()
		PriestString := "probeColorCC: " . probeColorCC . "`n"
            . "probeColorHP25: " . probeColorHP25 . "`n"
            . "probeColorHP20: " . probeColorHP20 . "`n"
            . "probeColorHP65: " . probeColorHP65 . "`n"
            . "probeColorTHP: " . probeColorTHP . "`n"
            . "probeColorPEN: " . probeColorPEN . "`n"
            . "probeColorSWP: " . probeColorSWP . "`n"
            . "probeColorVP: " . probeColorVP . "`n"
            . "probeColorFT: " . probeColorFT . "`n"
            . "probeColorPWS: " . probeColorPWS . "`n"
            . "probeColorSHT: " . probeColorSHT . "`n"
            . "probeColorRNW: " . probeColorRNW . "`n"
            . "probeColorHF: " . probeColorHF . "`n"
            . "probeColorCAST: " . probeColorCAST . "`n"
            . "probeColorIF: " . probeColorIF . "`n"
            . "probeColorHUM: " . probeColorHUM
		MsgBox, 0, Priest Colors,  %PriestString%
		
		Case "HunterBug":
		GetColorHunter()
		HunterString := "probeColorCC: " . probeColorCC . "`n"
            . "probeColorHP25: " . probeColorHP25 . "`n"
            . "probeColorHP20: " . probeColorHP20 . "`n"
            . "probeColorHP65: " . probeColorHP65 . "`n"
            . "probeColorTHP: " . probeColorTHP . "`n"
            . "probeColorRNG: " . probeColorRNG . "`n"
            . "probeColorSRPT: " . probeColorSRPT . "`n"
            . "probeColorSHOOT: " . probeColorSHOOT . "`n"
            . "probeColorMLEE: " . probeColorMLEE . "`n"
            . "probeColorRPTR: " . probeColorRPTR . "`n"
            . "probeColorARC: " . probeColorARC . "`n"
            . "probeColorCHIM: " . probeColorCHIM . "`n"
            . "probeColorCONC: " . probeColorCONC . "`n"
            . "probeColorTRGT: " . probeColorTRGT . "`n"
            . "probeColorASPT: " . probeColorASPT . "`n"
            . "probeColorPHP: " . probeColorPHP . "`n"
            . "probeColorCAST: " . probeColorCAST . "`n"
            . "probeColorHSTL: " . probeColorHSTL . "`n"
            . "probeColorMONG: " . probeColorMONG . "`n"
            . "probeColorLION: " . probeColorLION . "`n"
            . "probeColorKILL: " . probeColorKILL . "`n"
            . "probeColorWEAP: " . probeColorWEAP
		MsgBox, 0, Hunter Colors, %HunterString%
		
		Case "DruidBug":
		GetColorDruid()
		DruidString := "probeColorCC: " . probeColorCC . "`n"
            . "probeColorHP25: " . probeColorHP25 . "`n"
            . "probeColorHP20: " . probeColorHP20 . "`n"
            . "probeColorHP65: " . probeColorHP65 . "`n"
            . "probeColorCAST: " . probeColorCAST . "`n"
            . "probeColorTHP: " . probeColorTHP . "`n"
            . "probeColorWRATH: " . probeColorWRATH . "`n"
            . "probeColorMOON: " . probeColorMOON . "`n"
            . "probeColorWILD: " . probeColorWILD . "`n"
            . "probeColorFURY: " . probeColorFURY . "`n"
            . "probeColorSUN: " . probeColorSUN . "`n"
            . "probeColorSTAR: " . probeColorSTAR . "`n"
            . "probeColorTHORN: " . probeColorTHORN
		MsgBox, 0, Druid Colors, %DruidString%
	}
	
	Return

	;Functions Start here

	Spam(Key) {
    While (GetKeyState(Key, "P")) {
        Send, %Key%
		Random, rand, 150, 300 ; Generate a new random number for each key press
		Sleep rand
    }
	}
	
	GetColorPriest() {
    ; Repeated code block for getting colors		
		PixelGetColor, probeColorCC, 1251, 920 ; CombatCheck
		PixelGetColor, probeColorHP25, 1442, 920 ; HP25% warning
		PixelGetColor, probeColorHP20, 1462, 920 ; HP20% warning
		PixelGetColor, probeColorHP65, 1478, 920 ; HP65% warning
		PixelGetColor, probeColorTHP, 1496, 920 ; target HP lower than 45 warning
		PixelGetColor, probeColorPEN, 1397, 920 ; Pennence
		PixelGetColor, probeColorSWP, 1360, 920 ; Word pain
		PixelGetColor, probeColorVP, 1415, 920 ; Void Plague
		PixelGetColor, probeColorFT, 1378, 920 ; Fortitude
		PixelGetColor, probeColorPWS, 1343, 920 ; Shield
		PixelGetColor, probeColorSHT, 334, 1036 ; Shoot
		PixelGetColor, probeColorRNW, 1513, 920 ; Renew
		PixelGetColor, probeColorHF, 1326, 920 ; HolyFire
		PixelGetColor, probeColorCAST, 1270, 920 ; Casting 00FFF4
		PixelGetColor, probeColorIF, 1325, 920 ; Inner Fire
		PixelGetColor, probeColorHUM, 1309, 920 ; Homunculi BB99FF
		Sleep, 100
	}
	
	GetColorHunter() {
    ; Repeated code block for getting colors
		PixelGetColor, probeColorCC, 1251, 920 ; CombatCheck
		PixelGetColor, probeColorHP25, 1442, 920 ; HP25% warning
		PixelGetColor, probeColorHP20, 1462, 920 ; HP20% warning
		PixelGetColor, probeColorHP65, 1478, 920 ; HP65% warning
		PixelGetColor, probeColorTHP, 1496, 920 ; target HP lower than 45 warning 00A9FF
		PixelGetColor, probeColorRNG, 1417, 920 ; Range check RANGE: MELEE:
		PixelGetColor, probeColorSRPT, 1384, 920 ; Serpent Sting
		PixelGetColor, probeColorSHOOT, 443, 1036 ; shoot
		PixelGetColor, probeColorMLEE, 346, 1036 ; Melee
		PixelGetColor, probeColorRPTR, 1402, 920 ; Raptor Strike
		PixelGetColor, probeColorARC, 1368, 920 ; Arcane Shot
		PixelGetColor, probeColorCHIM, 1354, 920 ; Chimera Shot
		PixelGetColor, probeColorCONC, 1337, 920 ; Concussive Shot
		PixelGetColor, probeColorTRGT, 1234, 920 ; Check for if Target of Target
		PixelGetColor, probeColorASPT, 1323, 920 ; Check for aspect
		PixelGetColor, probeColorPHP, 1497, 905 ; Pet Health 50%
		PixelGetColor, probeColorCAST, 1270, 920 ; Casting check
		PixelGetColor, probeColorHSTL, 1285, 920 ; Hostility Check
		PixelGetColor, probeColorMONG, 1417, 905 ; Mongoose Strike
		PixelGetColor, probeColorLION, 1402, 905 ; Lion Buff
		PixelGetColor, probeColorKILL, 1385, 904 ; Flanking Strike
		PixelGetColor, probeColorWEAP, 1369, 904 ; Weapon check
		Sleep, 100
	}
	GetColorDruid() {
		
		PixelGetColor, probeColorCC, 1251, 920 ;CombatCheck
		PixelGetColor, probeColorHP25, 1442, 920 ;HP25% warning
		PixelGetColor, probeColorHP20, 1462, 920 ;HP20% warning
		PixelGetColor, probeColorHP65, 1478, 920 ;HP65% warning
		PixelGetColor, probeColorCAST, 1270, 920 ;Casting check
		PixelGetColor, probeColorTHP, 1496, 920 ;target HP lower then 45 warning 00A9FF
		PixelGetColor, probeColorWRATH, 1425, 920
		PixelGetColor, probeColorMOON, 1411, 920	
		PixelGetColor, probeColorWILD, 1396, 920	
		PixelGetColor, probeColorFURY, 1383, 920 ; 0xFFF917
		PixelGetColor, probeColorSUN, 1369, 920 ; 
		PixelGetColor, probeColorSTAR, 1353, 920 ; E2A7FF
		PixelGetColor, probeColorTHORN, 1339, 920 ;35E3DA
		Sleep, 100
	}
	GetGuiStates(){
	;refresh states from Gui to script
		GuiControlGet, KillOpt
		GuiControlGet, DebugOption
		GuiControlGet, DruidState
		GuiControlGet, PriestState
		GuiControlGet, PwsToggle
		GuiControlGet, HfToggle
		GuiControlGet, HunterState
		GuiControlGet, SpamOpt
	}
	
	
; Function to check and load the GUI position from the registry
	LoadGuiPositionFromRegistry() {
		
    ; Attempt to read the registry values
		RegRead, X, HKEY_CURRENT_USER, Software\NYMRB\WindowPosition, X
		RegRead, Y, HKEY_CURRENT_USER, Software\NYMRB\WindowPosition, Y
		If ((X = "") || (Y = "")){ ; Assuming that an empty string means the value wasn't found
			
			X := 100 ; Fallback to a default value
			Y := 100
		}
    ; Use the values to position the GUI
		Gui, Show, x%X% y%Y%, NYMRB by B.J.R.
	}
	
; Function to reset the checkbox names
	ResetCheckboxNames() {
    ; Loop through each key-value pair in the originalTexts array
		for controlName, originalText in originalTexts
		{
        ; Update the checkbox label to its original text
			GuiControl,, % controlName, % originalText
		}
	}
; Function to check pixel color and perform action
	CheckPixelColorAndAct(x, y, expectedColor, actionKey) {
		Random, rand, 150, 300
		PixelGetColor, color, x, y
		if (color = expectedColor) {
			if (actionKey != "") {
				Send, %actionKey%
			}
			Sleep, rand
			return true
		}
		return false
	}
	CheckActiveWindowIsWoW() {
   	 WinGetTitle, activeWindowTitle, A ; Gets the title of the active (foreground) window
	    if (activeWindowTitle = "World of Warcraft") 
	        return 1 ; The active window is World of Warcraft
    	 else 
        	return 0 ; The active window is not World of Warcraft
	    
	}


	; Subrutines start here
   ; To save the GUI window position to the registry
	GuiClose:
	WinGetPos, X, Y, Width, Height, NYMRB by B.J.R.
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\NYMRB\WindowPosition, X, %X%
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\NYMRB\WindowPosition, Y, %Y%
	ExitApp
	Return
	
	UpdateTransparency:
	Gui, Submit, NoHide  ; Update the value of the variable associated with the controls
	WinSet, Transparent, %Transparency%
	Return
	
; ToggleBold subroutine to visually indicate the checkbox is active/inactive
	ToggleBold:
	GuiControlGet, State, , %A_GuiControl%
	If (State = 1) ; If checkbox is checked
	{
    ; Append an indicator to the checkbox label to simulate the bold effect
		GuiControl,, %A_GuiControl%, % "*" originalTexts[A_GuiControl] "*"
	}
	Else ; If checkbox is unchecked
	{
    ; Restore the original label text
		GuiControl,, %A_GuiControl%, % originalTexts[A_GuiControl]
	}
	return
; Update state sub called after ticking boxes to update variables in function
	UpdateState:
		GetGuiStates()
		return

	CopyWeakAura:
		; Determine the base path for the files
		basePath := A_ScriptDir . "\"
		
		; Initialize filePath variable
		filePath := ""
		
		; Check which state is true and set the filePath accordingly
		if (PriestState = 1)
			filePath := basePath . "Priest Weak Aura.txt"
		else if (HunterState = 1)
			filePath := basePath . "Hunter Weak Aura.txt"
		else if (DruidState = 1)
			filePath := basePath . "Druid Weak Aura.txt"
		
		; If a state was true and filePath was set, proceed to copy the file content
		if (filePath != "")
		{
			; Read the content of the file
			FileRead, fileContent, %filePath%
			
			; Copy the content to the clipboard
			Clipboard := fileContent
			
			; Show a tooltip as a notification that it was copied, which will disappear after 1 second
			ToolTip, Content copied to clipboard.
			SetTimer, RemoveToolTip, -1000 ; Remove the tooltip after 1 second
		}
		else
		{
			; If no state was true, show a tooltip notification
			ToolTip, No active state detected.
			SetTimer, RemoveToolTip, -1000
		}
	Return

	OpenColorette:
		; Dynamically include Colorette script
		FileAppend, % "#Include " A_ScriptDir "\Colorette.ahk`n", *
		Run "Colorette.ahk"
	return

	RemoveToolTip:
    	ToolTip ; This will clear the tooltip
	Return
