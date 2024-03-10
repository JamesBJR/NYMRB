#MaxThreadsPerHotkey 3
#SingleInstance force

	;Linked to Gits
	;Define Global variables to be used between functions / gui
		;variables for Gui
global PriestState, PwsToggle, HfToggle, HunterState, AspCheeta, DruidState, FeralState, BearState, CatState
global DebugOption, KillOpt, SpamOpt, KickOpt
global originalTexts := {} ; An associative array to store original checkbox labels
global clipboardContent := clipboard
; Shared Variables for Priest, Hunter, and Druid pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorTHP, probeColorCAST

; Variables specific to Priest
global probeColorPEN, probeColorSWP, probeColorVP, probeColorFT, probeColorPWS, probeColorSHT, probeColorRNW, probeColorHF, probeColorIF, probeColorHUM

; Variables specific to Hunter
global probeColorRNG, probeColorSRPT, probeColorSHOOT, probeColorMLEE, probeColorRPTR, probeColorARC, probeColorCHIM, probeColorCONC, probeColorTRGT, probeColorASPT, probeColorPHP, probeColorHSTL, probeColorMONG, probeColorLION, probeColorKILL, probeColorWEAP

; Variables specific to Druid
global probeColorWRATH, probeColorMOON, probeColorWILD, probeColorFURY, probeColorSUN, probeColorSTAR, probeColorTHORN
;Variables specific for FeralState



Gui, +AlwaysOnTop -MaximizeBox +Theme ; Add +AlwaysOnTop option to make the GUI window always on top
; Add DropDownList for Debug options
Gui, Add, DropDownList, x2 y4 w80 vDebugOption Choose1, Debug Off|PriestBug|HunterBug|DruidBug|FeralBug

; Add a slider for transparency control
Gui, Add, Slider, x87 y4 w80 h20 vTransparency gUpdateTransparency Range25-255, 175

Gui, Add, Checkbox, x12 y29 w40 h20 vKillOpt, KoS
Gui, Add, Checkbox, x63 y29 w45 h20 vSpamOpt gUpdateState, Spam
Gui, Add, Checkbox, x122 y29 w45 h20 vKickOpt, Kick
Gui, Add, Checkbox, x12 y49 w40 h20 vOption4, Opt 4
Gui, Add, Text, x62 y52 w52 h15 gCopyWeakAura +Border, ` `Copy WA
; Add a button to open Colorette
Gui, Add, Text, x23 y72 w57 h15 gOpenColorette +Border, ` `Color Find
Gui, Add, Text, x85 y72 w63 h15 gSetBackGround +Border, ` `Set BG Hex

originalTexts["PriestState"] := "Priest Rotation"
Gui, Add, Checkbox, x35 y100 w100 h20 vPriestState gToggleBold, % originalTexts["PriestState"]
Gui, Add, Checkbox, x10 y120 w85 h20 vPwsToggle, Power Shield
Gui, Add, Checkbox, x100 y120 w65 h20 vHfToggle, HolyFire
Gui, Add, GroupBox, x5 y93 w165 h50 , 
originalTexts["HunterState"] := "Hunter Rotation"
Gui, Add, Checkbox, x35 y150 w100 h20 vHunterState gToggleBold, % originalTexts["HunterState"]
Gui, Add, Checkbox, x10 y170 w85 h20 vAspCheeta, Cheetah
Gui, Add, GroupBox, x5 y143 w165 h50 , 
originalTexts["DruidState"] := "Druid Rotation"
Gui, Add, Checkbox, x35 y200 w100 h20 vDruidState gToggleBold, % originalTexts["DruidState"]
originalTexts["FeralState"] := "Feral Rotation"
Gui, Add, Checkbox, x35 y220 w100 h20 vFeralState gToggleBold, % originalTexts["FeralState"]
Gui, Add, GroupBox, x5 y193 w165 h70 , 
; Add Radio Buttons for Bear or Cat under FeralState
Gui, Add, Radio, x20 y243 vBearState, Bear
Gui, Add, Radio, x100 y243 vCatState, Cat




Gui, Font, s12 ; Change the font size to 12
Gui +LastFound +ToolWindow +E0x80000 ; WS_EX_LAYERED extended style
Gui, Color, FFFFFF ; Set GUI background color to white
WinSet, Transparent, 175 ; Set transparency level (0-255)



GuiOpen:

LoadGuiPositionFromRegistry()



Loop {
	Start:
	GetGuiStates()
	if (((PriestState + HunterState + DruidState + FeralState) = 0 )) {			
		Goto, Start
		Sleep 500
	}
	
	if ((PriestState + HunterState + DruidState + FeralState) >= 2 ){		;Idiot prevention if 2 or more variables are true then fuck off
		GuiControl,, KillOpt, 0 
		GuiControl,, PriestState, 0 
		GuiControl,, HfToggle, 0 
		GuiControl,, PwsToggle, 0 
		GuiControl,, HunterState, 0 
		GuiControl,, AspCheeta, 0
		GuiControl,, DruidState, 0
		GuiControl,, FeralState, 0
		GuiControl,, BearState, 0
		GuiControl,, CatState, 0

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

	If(FeralState = 1){
		FeralStart:
		GetGuiStates()
		Random, rand, 150, 300
		GetColorFeral()
		Sleep, rand


			
			; Cast order in and out of combat
		if (probeColorCAST="0xE8D8FF") { ;casting check
			Goto, FeralStart	
		} 
		
		if (probeColorCC="0x1705FF" || KillOpt=1) { ;main combat check, if combat use rotation53
			if (probeColorCAST="0xE8D8FF") { ;casting check
				Goto, FeralStart	
			} 
		}
		
		if (probeColorCC!="0x1705FF") { ;out of combat check
			if (probeColorCAST="0xE8D8FF") { ;casting check
				Goto, FeralStart	
			}else if (probeColorWILD="0x991569") {
				Send, =
				Sleep, rand
			} else if (probeColorTHORN="0x35E3DA") {
				Send, - 
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

		Case "FeralBug":
		GetColorFeral()
		FeralString := "probeColorCC: " . probeColorCC . "`n"
            . "probeColorHP25: " . probeColorHP25 . "`n"
            . "probeColorHP20: " . probeColorHP20 . "`n"
            . "probeColorHP65: " . probeColorHP65 . "`n"
            . "probeColorCAST: " . probeColorCAST . "`n"
            . "probeColorTHP: " . probeColorTHP . "`n"

		MsgBox, 0, Feral Colors, %FeralString%
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
	GetColorFeral() {
		PixelGetColor, probeColorCC, 1251, 920 ;CombatCheck
		PixelGetColor, probeColorHP25, 1442, 920 ;HP25% warning
		PixelGetColor, probeColorHP20, 1462, 920 ;HP20% warning
		PixelGetColor, probeColorHP65, 1478, 920 ;HP65% warning
		PixelGetColor, probeColorCAST, 1270, 920 ;Casting check
		PixelGetColor, probeColorTHP, 1496, 920 ;target HP lower then 45 warning 00A9FF
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
		GuiControlGet, FeralState
		GuiControlGet, BearState
		GuiControlGet, CatState
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
	
		; Check which state is true and set the filePath accordingly
		if (PriestState = 1)
			weakauralink = !WA:2!1IvFSTXzz8AmRB4IgjUFSKUsXRL21n2YYNTRzFKMl1PoTjXUNDsAlLfF23R9DnxU7YDNJJZgqBagHbtIfgd6GToctD8XgizPnHaeBeqcPPoPhSMeGeiyfOiqABsLn(hKw5559UZ1jTL2MT1)W59EV3pF(9XZZ1adh2othn1sZn1s4XdlhwE2nwjJu2XKTmm7XqZWAVbdgmrWMBQJ5DmYojZYw1q)6UTx)0zmSKzwcEd1Sobn1PNwYsoskddnhvtRPINlNnZjqg3rQmV7FJkNNzwFYjkizXI0BbnTiJOO6WklPNvXWkHHQUtMEIoyQOIEtiP60SRzb32Ul5hQS7tUNVabceSIubhC2XnDWtNDiRsE7TLuwEpBx02rYYjKGQUQtOm5W)yReAghl185XR063QLxZhCEzwMc5YLQKjZkw0(t07q9l4GpikvWsQ1zSnzAA9jBh602fYWMKP7KehT6uLhTNUtMA0KP6wmLqbCtYyQjvIzjQlnoZoKiFOzIXK0CuQo1ewmCQIjteT)(NRGU3ri08wS84HMocI5TmkyEwmMWS0L0g2n8)WLv1ZzynUeD3cnNntlhpUbRAtQYvsyPYSDIWpP2I2zL0ybfL0mvKcEw3GCVw4HIw(mj7rmA0b9cN9PJHSGTwqvUC2916bIEOmBVWi7BojDv3DA7q4EHgf0n0zlWKSzjDSy65DuU2kYySHgXOuKYYML1qx2EgAm0UaTlmUKQooxODOJRf2oSd4oXMRzP9mpgye53D7qLZrhsClKCKcopTGQUyRGMHKCVc2iRyDIJxaPAHeW7A21bDfsmRMKTn1kJdET1D4nXjNtnFOWz)PZU55vXNsAuWklBdRa(iHG6ITlXBRRvG)dcbRQswK8kBuupzrvtw6f8FKiTkc0CtdR963kSUZankYJWWgGpkCdqdM1xWMnAEMoZsnBsfJIX1txzrpEAB(F6XBjHndF8kwiHijTmdIxwRemDeGyvOvY2V30WngcUPkDZjYrgYwkJgd2i8XGiHMJgigHYow65Qo(gw5MEhylHmRNO(tYs5sQgWqM9SRa22dF2XymZUPaMJiHzkWTcRcj92soeiYuGo7CDqJvqOGSbi(NU8SRXmSdBkNrTvKWZ(b8uxMnY7K)JlFCuBVgq7Zv9DBAl2M1vZ0pVS90U96ZFf6EOuXnxnVtuqBq0USJOk7Oi0n(4zD3i1PyY8opwfx68b9oolWF)rky7OMReEPSmCWlukStHbJpyuOrl8srJzE(aZ67UfCoVBGUJzD9APoDK9xqsMiErsLArxC)DQcVVIOQzeljZzgXRH7bysvBveJs7DNRXxZS((gCWOIJkepvQ4di23EILQs1TMS5A07gDGfTp0B5(rXhkv)9ny0ZujVMrXETytuGPNTuIpyZn1AhU3o6flq)SBpfzWzONOzxjtbhhd94Ofo6mnp1D)C57AltT9VAZrpu14p4cifBp(9OWhz1dhFLvuZoMoZ2oiFIj5UncutfEh9RIVSE(Uj4MgiJctnVIZXG7zyo)LlztdcKuf2f)3U3AgBv98ASmje7lAYuuF3l)nBf2d0szPPevpqpQfBEYmqBCxj0dHSs8Dw25f0ZAUGEULqctBymEaOECfcbRjeS6qMRXxWtSMDRYfBYkqqmHhATkGcuDXZZBGBpOyrot0mmEv8v2OwdLwOWTNqwQ6uktuv1eChWDTk4UdnJ)wKgwzSDLFdwhDfR4dm7MHDJ(ryhg3sGJF8J)4CFP1oSVVeenn0RI3rD18tRVneeJBbT)gw5n9RG(sd7f2hzTa9BwFclkfueJCrgGH(N65HbDDtG4EoiqI0K5f6xaIC7bij3qas55dadn7AGHdaJGrSdGcz4GCHlCi4tchg(uW9Dmy0aqACgsqgC4zbz3qddYb5dakGkCK0WyGgmEJGEaWampdmHpNfSGskGduaMCTqXaWuUt2oimDa4tRapqq4(dcFM6HpRcCuIYahBPufyg4ZTycspHiJ9VsAypPHzDxWhSkg2AI4dWbJBpi8Log8qPr(uwRj6Fa5923G5fHVScbtFHaisHuep61ssCTZlFQSzVz040rdz)GjEiI11pPHg2fcMX66vtLkn2iyWYYQ2urcevlCtvwKdZg4OUzKAgIVdR5OoQJZ8EkGzDzr)oJXPrmKPms7GB60l27erPAO4U8M)dN3qPTcZZHizLN5iIgkQwmzxoesLiEcNkbd4XCqgdrCichYC2VxUgI7yEJx0ZQBdr6ilBU1l91rJLxkBPrZPzG2mlBrTazvIeVoxpN6E55lZ478(ivwuQTGWwfiV3z894bvZnDPp9JBipQfxYVTh2CZx6XzAXYQsvWfKOxOAVWJ2(Po1PEfZpXLEoYLWsivZoQJIfdRGqtUKLxkoH(J2BkFE9mK3ev9ar)VRGCkEDXEj73(p9VBRTwrs(ongz8j3rBfIp9WO8O8stfp)5ZR(5)WeZ)wZ4MMA2Bg(Qihgvups4MG5CzMWxla8Oi)4RxLC5zkTXQKR9FDDkap2fYLMlMHwPi9IeTlkNY1ncxLCwiZKxa0CuP386Oxp89HBWkw3IdGLLxbdszvy2UvxvXT6QbuTPuh4jy9WgZ4YR9D3orA44K723dE8Rgoc8TEe4BJec4jieZ6A(VNjxUOW3a(MKD5tfeEgmE9KOnhPYFJN8jFjsCJoKZdF3QydDL534wkhDFJus7o37T0XafUiWeIDFNsWjD9yF36aXXn0amwxV2etCuU5ZR8epXlEUZDUG))XspJI7drHxa(bPHF46NVpDSswxu75GFeo6nXbnx4Jc2e8r4Bv87b5nXxrz5t6G1sAtReugxXtBZFoowtJKJH1MU77jJBpH7GVSBjezoEKc68syBvsVKpaIHCkwVCbWAc1iv4P4XycjXGEn41C8Bl)YEEXunyFlLZSJKdFOdQT3HJztkdIt5bApJR6z56GD1P2iR8zxngvnxBcJIiarvI2zKEnSCuDki7Iv(fe4bhCKYl7pjkr8TQ)(zrOk6u4hoK09ZCv8S4r9BI00NL0xEDdlUQu59uvLZt)b(Iflw6sOQEZU6knN((MN4eC51Iuxc01fXKdkSDvzj1jABB7ErkRo3W2E7fEFrzfRR)vNDYtMhRR)(Z)88J2vKYQkUjkIFHyr)Y2iuXnGJGI33v6dtlopmHJ)mf45wW11RBUoHSp)5vXfVq57gGzzxBnYjEk)uC3)G)YtCUZ9olrIbV4sZtnZRpZV)oqy8qj2wZd1MD0DQitYaIdSyP1XvQbaEZ)8FzfCQXFOXg3Ll14kbaAQQWjCTcNKkQmn5LpCGQnFma3GtYZd6L7JwS(HfOjqldT(ufuB2lzNRnBLrysJHmc5ijnkOXNdTM0YFdWZE5q2CiYY)KkDg(rhkEG85Hxx4(9fq26F(qAN6u)ILaYz8INlbPDfKTuoUL5iJlmsU(hq6YG04YE5q0nwfrRpjV0gpinHKQETFwefh9DbrS0nzgbp)4AWZQOocQ1aOVahqXAAweM(BwkM(0397HAqmWGb6Lni5IqObnPkQ10KhxUeat7tLOu0dXoYitl5w)aKiHRb8F8Wh(OCxoeZTFLgozUCPxcMHO4vFfJZwNx2Py84QFgQA)A2gw5d8wEOZJPGiN5QjMoJswv7)xzUFvco0ALvzAV1oAT525G8frp5wwXYnBWfQbHF9vQ2JhCFJ79EPGlgcjfarz8s)HOggMNCSx41QV(RVwWR8WgQYrsOjLVavszXjZS)dMCh7Rypc1aNob2ChV8Hp5flXhYh9WOR4Kv1rH1TySiiIWfpicvs9ZFFveIWVxo9s()x4suRWvxqJOQV1V93HLXwt5cU2qt00FJONlTCUygJJLswqtTgcpL84FuSOBzX)12AZl5rlLBENt3CpJOFNhYOnIcVSvExGSi8KV6b(Fp
		else if (HunterState = 1)
			weakauralink = !WA:2!TZ1FSTX19DRYgxxI2oBzBv)JmNZ0l2soYYsu)Yoj2YIsuMYwwsMKYYQUUIhjFK3zD8UZV7O(Hh6wNAqM6asBI2cstbkwG(JGGSSUeLnVLMTmx3KSSSK1xvYs8agws8At3VQlQXAX66gY((9D3rEhf1pTBwXGfGpE89733pF)97rxXPQ0izZ11q911qL5QmDLPNAhZLum1iPPA6DOPOrpMpF(63x9118mMAPgLqnK1uxxT)WRMuJMMqdz3u91hsr(cxqKMwiUMMIPS(CI5nL0O9PBcDWWFsR2lnJ1NHtNLOVHyNpViLi0vEffHbLKnjZqjzHMhFcDs0SuT862npM8fi321LvnjuvrLtzTkEGzTQ0Azwrfv4JoEFzYyqmRGoHZlIP4ZFlrnmfPM(tMrwv2qYFi4dt)tAsLZMfgTTTBQ9R3)mPjjZNjdUeOrc3t)DnqpHmX1JyEQyWjn0jkkDN2W)vnYNKmkr1mg0A5XND4oApw8HJfV9OXdLhg8K6kItqOrvfZrm8hL30KriIkMsf6A)uc01OX6pCp9mDEv7LG)zfvtbKU(1GnCYoc3B8WrVS1w1Ax9XNvwnJgnNiU18pTOQS1RTWQSRlteniXmPe1SMsFm2wdPQPsMlnS2XwmmUtOgKuAQPnMeBkUpz1gkNOSAxS7c6aRw2(y1X2p85glTKaYPNlsEefeIH0bJOgPevi(Mndf2LWSkAk676wR(UWIWrpzSoIgoCVjH5mJCw)bZlNE2MpxdJ0EpsJgl0etBquYW3QS9mdqyIY5aakMOIUKOVzWLQSfpuifnX0DL0eMsvZQIMlpWN5peGiPQI1M)OPuenmW3czaSl4l2miDRcenFvM6X20u7DgzyaJPLNMIuXmPYByQLlozCZX)4)2zYRY5vQUg)cWFkAWwtihr0u4qc)6cn0qR1kem4bGNn2AR1ZF2qTcn18bpyTch4Gnhu4Z7QBzaEmE3Af7a0OG8NnYF2emqn0CZb59Rvp9ljLiMM3XMAUP6Xw3eFsAI3)MGE2ul13aVJ17DcZRMnVHvpBPER21m)zl8NTYFEaSNnDaV9KMx20EkBeBCZnYxYnEa(ZdY7O1ATrpDmLeHyq49my9ifPPgW5ni02gAfNWgpyWwX(1OdTXvNjPLtQW7SN1IMgU7RV0wNkpLIIleCHoaiC1bqNmZtjDjMtwzIQdOtmdutXE5aLa8rZsg2ueMlJQRRU6SAtXbwKMfxdqnF(sQjN44fwjUzhGXlDXLDHzKpRAub5AfgvqwvqxuMAunm81iKwRqlW)KZiSRrfomFcmLiQEQe)ZAM31OEQGOM2F5ENpNhc4iWELwtWtNWkphw5UW9zP1AVyGQoZ5o7zKplF1yVdpZUS(8UA4SWAPytCp1l2YIsa0XzW87UwV4dWdLAKtMNyywTC6sbNZNcM7Jsm51B0HwoDfIjjD1fBhS8pFQZiN(SZNsAVcmP5jZBf6zTSV9fbSHDoTKczeLvmeZq40ToueZbtNPqS8uDQmWOFECzC3(TNxxR8wAPH6Rr4qhcgafODEwkffskNmYNF(lhCODXTFiHa9nMsabyfvsXdQPKPCLhvu3uJwUAIPldkdlBnP0OqLb8U2liJIkbTwPW(B(lWoenl3G2bvlLMISXiLTsrkfzacjtxKP1LWlUgQLRxTMfzPeQ8lLJQrLvuexwtexFyT2kuxS5kYee1v0qIBHfBahuwnTqmcvhkBznUwmx1Az1yPjoXfbl2GpgCMaUW(kHuuRnV8Iod5PMkKv1GVul(oOIjxvd8YK4estSSIgHiI0veySWtVhoapQdDuIVl7H2LjdyLcQa72KKRdnWZRQTAbOlUgWgs9LqqSgmUn0cTRuJp86)noKtFX13iLvpEPQLSg4dnVj1wtBG(YBkOLr4uq)G9txqRduGEp)w3fbSJce5DgOWKH)ZVF26JCKtk(Zxd8hB3S9mxkiCI0AJPgBmzDsIl78vmacPqOZCjyB(BSBwvVp4O6oO5v5owhcc(qJTl2V2KoE(wzdSDothf8LKj4NTd2DWUD2VkB7(NmVbzy0P9eZA5si3p5KqidM5nMgRuurEusIzWxJiAaR7eSpnBlS70pmZJY2AsRUXIP)sL1nsjrDDzvIHHLfnO)rCkP6AUhhkCXwb4JQSIx2opn4EfACzAZZd13vR4gRklOd)dPlr5M4sMxpTOjH1hRF2ozbqAk7oRIflGFCRF)CQWwzBd7W0yes8WD221DGxHWzYqsbRidsVqnjy7ii4RwXrY)SPLnohNKnkbiFvA7sUvKq9OLvoLE)fiP2bizrzlSB5LDgWtfrq)PZxdA91Qv1mluwJNfO1WUtFdI85ZEwoHwAYtTg2N8bU(ieIE7y8eMrrMgj2EXqQkebeemegwu9tTXP5X90fSU0F)cRoDQwwkao1kWJ1802Foe8j26tB)5qUzmevZYvLuOZc7vii8piGoP60LRryFcvB)UW(fc6zNBnlc3Lq1vB1gdz1Q5dynqHnuZ(dwdmsvBn5Wa1qn14SKwEDAiRoXfmtYlz8()Onux9nbXYbHChYN1Nh1Nf5Gh1UEEGTIlYWllbsXS67e29vh2Malqg29ursQgiIrQOYjQOYXRG1tLbbADmBAT1G3U9Ke1hgoQxKacv3addagcjQDQjUn2DV3QyBDoissmngyseutp1M1R0eIYBydjrq5XPTtoW08YWhbUZu6R3vlkMsHRAvQtmQHAFG49PVrEHOogmW7udkN2uku7WxVoVciMEsAEH)wZzfm8q2Z4L51FoGhxoZeq8Uw7Fma0q92xVHzBLcRBSnZWBykReWePT)L)E8VxjsBFVnH)vVpRLEgnvt913fv(ccNmVyAm8BH4XT3REM5NAnZXlCmiG4bPI6toO9lZvyG4z8OVbI3t39g2My4kpexU7E7nC0Hd1x849Dc9TwGYnSvIigoL9lSAT2JJkBGgGsuC8XC4StB6Hdc4bwCisjLiYzLm)ISd94CgjuLovIDymIEw77ojWXcSRjJmaMyeOmEJ4b)N4QCgpm1eJOcgjsWcX70rWNCL3P0YLe46NPyBw327JEbnvs3Pn(ijn4jgiPCoDnQjBdG0Fl00AdNvrBmjwSX)43X(2x3DAWnyNwg0SHEkWnmA4FvKVGvtUcwv5jy1LJGvv(bwn5gW)8Zjqj5dyfLga)lr4)Lp0)5h2F5d53)Ylu)fnm)5fIFP(CTGH1V4H0FJeoFPlbVHWZ9nBXcBF5eY(ceUEPUTuWxWvAO5lVWYxQqY5t9VKegU3qW)fE43lDO33GHDVSc5E5fU9Yiu7vuy2RGqSxrHxVIcTE5gw9kiK6Lx40R8qPVHcJ(gneAl1rlqyZROqMxWWLxQqLlOLYsZhfgKbH6BhCh1OoRJXY4mbIMpPM5EmWqHWqIiCTxggYPcCw7g5yrh6p3CgHFWjvhiuEttn1a1AfQCHVrHcIraQlPDUUyRkItanTqFrRFjV7yeZ2vu4UTbHx6uIjWBMmVjm0yWT4aZDckaetuPnWQIAlgLE5AeeirwI5(Kb6m0uKwvZ9mn4SKveCsSnTB0JPbVLht3YJPB5X0)F2JP9TVOHprFNkCmRrDFuY5Zltboa7(HBcScbmxmPC2H1zNVVB5P1T806wEADlpTULNwRipTypAc2g9Z8Z6EsNJercZLoERJ6oLM6w(iF0WbZtv03UKPPUXDV)9pMywT6K12)fc3v)bhJ00b3FqwJ(yToBxx48rmZrprt10zOlOPLRcwtSM1RmVbPd7r(eAPJc75e6BYzUWuw2PSbYnLwkPbj3OeA0gQR(6AG5BD1(ddiNwFRliIWwRF294l6yygs)ISJlXAXpvwftGlrI9Re5iN7N(7Gh)t0uo3)mFS71pRMDplWhMIegpGhJe6BroRQgLyFbZ4LgMs1OgjyhKTNP2dvlVPISkHDFW8PFx20M4UYzP(WMY5idNEcvWBOudBkrjgsW(Bc26JCjJFYv)3FTx71WZGsxyH7S13QqF9fVlrdyDIj78QEtqmBuEcf9JW2M8Z28NA3SQMA98JbzRr58btZFINtYJWpyQDK0c513aM6YSevcvovmjTX6tnXCE(6vn4F4Gxmb)ZbC4kXCgVPXKtlaT1CUczi168y2UFwVj4G9WwtwuBR3jy7ColgFHb44mpnRMuW)cNZ(I95EQ1OV9YsBSEjksIsRV7fM8PqYkMAIHZOOPrDoULsUfA1V03lTqy(Lz)MS7EBvbfRXo0Pypyc7egFe70gZ(YSVc(gpJWt6Kq6hAophjGpM)qygPzhmPvMUN11sVY60dSW7KCAPhMYfs21c3iDkjLmEmf(MP4HeCFFc2N8bM0jZ8SjP2NpqOEc3vChXPzJkQMLi0b6TgiZgUHGNAWbYps4MQbfIbbw2tCmFvePTF0Wd)fazhFGmfkkn699698AV2RpNNmSF7Rz2spMd29U3DZgOfwv(MCurQmI3x26QoQYN4OJkQKN4JMsc)Mb04VBL1nPovtNqnNG9IW3pwK2E)wA5iWKhPTNDJBuaxf(yVb7jShy23HXyF3kyZz1zOgEVWf9uBzlhXP1SA8p1Ey)bGu7lcn61VD(PaZ(dRG9ny7K9hvwHOkNevnI8ZRl4vypBc2Fm7pb4QzpZJW2AiSkU0eiODzKf2PTidoA6simWWRRtsZUi7pL9NXfj2bBw8eIFUeSN3nZo7pN9xWEbj2RWMK9xUs43yx6HyFlG5IDz2tnb7LsGGvK2EJ34nENp4d(GiT9sp8d)7dV4J9Y(y)va7aQ(5iBp1B7)WaNb7VM9QoCbtpirx4eefcb4b6THjoq1N3S6i10IdpaG4M3XxAVp5t(mi(dQzxTsuS)2sylSqpFLIE30WCqN932g3DTjEQjCtlklJWM48c2mcS3CDBQFhoauZkYcW(744)Bbao7Tr(II4maWcwOTxCgqOxW9P)cehxeVskzJZRKfI3OixHfxsP8gaydygYD9YFOr6rjmKTUuUmUypYfvq9sK2((p8d)y48ePT3(rEe(BaB4eIbdnupngjBQ(4IS2CoiFShyfhG3)Ix8swdqH1aaXlhH8FkqmFAoe9Cio(nDaza(U4CwHaked8yAeIn0IOVZn8aa3N5nFoxGlqOx1sgRwb)1YjgCA9lZDOb4ZZ)8v)ktnLj7fduNF3ia7FWfLhLa(zFZhCQP(sa1(O5J2CZ0E7sk4j5mkEP2VGubInGZV1B9wV7Awd8YvJgnbhTSLNShTftE6Zb08lYVzhdUT5SJHdiWYQzNdSNbXpyy55XCwEECczd8yz5xSduCcaaBDUicneiCrJ0E0t01a9u4oZW2b3xejnWyNIS5ej4DSxl5WDQVjmDvG9or8k8dE6aTkLX0fAn16nccQNjieqyb9Za2EJOFg4ow1Y92QVrfyFVd)dgBSZWzTDJR)JUWvKBaeF6UtAtNS76tD84ilcNtWr5RFpykVQLc(Sfz6fVruxLFO4YzKtXVcuvX(Yjvr3ruyxvIdpGBI8df3HilXHae0(ESVpGHw(f6DusGq0oz)tia6OY8mS3FrnpE)ShuIFhRWdAxAwN36oTHdQ87fQLMBO(saNQyFLeLth5lLGt7SKIqkSlcUlIT(w8W3kecI)BeHMe68eaz)u92E2Hoq8(s3ygh8yvRraG0NWcXa5lVcKR1Frbs7gSuA7qjVP24vDUsAYg4tj2)Qekj9GsinNJA4nTcDYpNe)sZG4PnY8p7Nft)SLCr0SZzikvfECqAYWjUYa1WVPuUZomEvqCvnMwHtqqx)aEaLa8ligEFW2U)zkUcbvTdaZoW8y9BBXqFZ93t7dfo6WXBp6rdhF4oI0EVhnCNCwmUoGP2i7hZ3xyjwBm21T2m4Od7wCZGCJ4EJVP(S3C3uHvi5GLQZE6)WEp8ty)uKuc6WSuUOoHBU7B6gowkVcaTcatVf3oW6xQTc9nxg2Ccf4XBwIQQ0xQqt03OU15yfzGJaJlfkEzDbPyBExh1sltDplL56zBNMsuLWdhDbmw35l41tSBef6CtH2waJ023AdBaCv6J4B1dJfWcKFaKNDRE)N7s9ERZgkvgWXKOFMOhVFofFR)Sp31U2FdxbWc5K0Y3aDrQ8ZSL122qLqNrc6fVChsqqNur3uAx3715hAZnOPtypA8zpDDx7AFBoFgaD2gex1gul185)dqv7l05pPEphRZqDhZTVP2imG1V7t)0xYje4f3IQtTRmhqrAxjS0xVdn1u5bRKJww2AR4iFM1TX)7BES1aNsrJGaWvIp8SpOeF3lib8wN6uwV8QFTVgqNQa9HV78JprWg7jxp56crr60v(4zY04cRBy1k8uKlFbj5UJNBdGZN6vADJCX7wUPeriI4yJ4jcpKQAFdK5WcIhWU3cbgkHlay(bYJuWvRAzGoD(392(ux7A)4vp)DrreabrQ9)1PFZl8ED7gidX3WTo7qD0zFNS9otFmXJ7gwT1NfPT378N)lWH1FWGdMyrz)lQy31wWwXJ98VKPCHJmBYlYCcn1rituwSXw5ecafXgHcWdGni6vMGV)qm(muySyWzi)zPwAtAVd9kyztVJ02R8v)QxIRa67Ch3XrSfSAya6bpWaJ2CNKgTTJVqA(lyH9E7COh9r)AlNKDaqWgIqePfqGEapJyVd7DD0lH07HsuismBLwfraK2BdpLOF6MG8XA9FZiwkeh8MdSq8DzRZMBO0h4GgJMMsJ6goEBh447Np)8fiWyUF5F3)Lh9r)6U8vVuXc3(7SyOHRyT4OXvQ4J5H7FlR9uNMB1abaEuTaaGWZfVExkIQJGER5jNfaouuIqWY9t2)5)xM0c0TLF0tUUPM6(4SeoPMcTHwIVpxPc)Liy8Ep0d9ywwKFN35DxJTaX5sMPM(7m7XUq1PxoocTmeg61kuclYVdZVn9VTDvG(BloGqasGV4LpUSIIqhA5Ybbku0AXZjHq4ZNywNaJZsmKMpqSywUxkbJfG2auuB1p3mDz6kv8jaQEtJDksZhqAGUoE7UtvSnYUqgkkJYPfZ(W8SCVzV2h6qIqmfLC53exJJTckey4ETwq7KZpTiB5bq44x(vonPLjcHGar)GMJNTBJZD6uJpUBXIRD4dBPG6FB7B3k9TxA9RxWLckxMKxafufGJwwB2XgBSLzCclqYtHvCwnndIaEujlq8yMNDfCcildAV3WdkpzKVOaY4yJ0HX4hnUy3TtCDuxrA7h(1)6xIt(UYPpDXJ8Q)BRXwQVUgNhXB1c1LsXFV1VlzwRlkfFhOaWMzxnbxN0h1HyJPuZILEhfsQH9HpG55yi3gMFomlB8FWkw)geLCzF21p7UDOxLoHMcI9xI)FSidJhhNOPgDBvEyRdn2t14GoNNs2wL1xiLTE8(6gu2YLTIfaG7vloptmOjbJ4KtD6SX7NA6X8XjpjpGUkCKl0xZRgEGbI(lmOnuTX7SZJSKqlkmTdo2yrdLC8V6kvSL9gOXMXFPPCs6N56LIkbU3dbqqsBAFGd2ILBWxPIpDIRurv7fQUYdx83v6JZLAF2efTzn5jiQ8BjcYMGTd5RqoJ7BDF4cFZG32iR)ZSbaqjtZJnIASQ7O)t750IgyGeUDaRqjoa6fuAgpC6BAaALJ(MN()n
		else if (DruidState = 1)
			weakauralink = "druid"
		
		if (weakauralink != "")
		{
			; Copy the content to the clipboard
			Clipboard := weakauralink
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
	SetBackGround:
		clipboardContent := RTrim(Clipboard) ; Removes trailing whitespace
		Gui, Color, %clipboardContent% ; Set GUI background color	
		;MsgBox, +%Clipboard%+ +%clipboardContent%+
	return

	RemoveToolTip:
    	ToolTip ; This will clear the tooltip
	Return
