#MaxThreadsPerHotkey 3
#Persistent
#Include %A_ScriptDir%\Gdip.ahk
#Include %A_ScriptDir%\Colorette.ahk
#SingleInstance force

; Define Global variables to be used between functions / gui
global PriestState, PwsToggle, HfToggle, HunterState, AspCheeta, DruidState
global DebugOption, KillOpt, SpamOpt, KickOpt
global originalTexts := {} ; An associative array to store original checkbox labels

; Variables for color picker
global bgColor := "FFFFFF" ; Default background color is white

; Variables for priest pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorTHP, probeColorPEN, probeColorSWP, probeColorVP, probeColorFT, probeColorPWS, probeColorSHT, probeColorRNW, probeColorHF, probeColorCAST, probeColorIF, probeColorHUM

; Variables for Hunter pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorTHP, probeColorRNG, probeColorSRPT, probeColorSHOOT, probeColorMLEE, probeColorRPTR, probeColorARC, probeColorCHIM, probeColorCONC, probeColorTRGT, probeColorASPT, probeColorPHP, probeColorCAST, probeColorHSTL, probeColorMONG, probeColorLION, probeColorKILL, probeColorWEAP

; Variables for Druid pixels
global probeColorCC, probeColorHP25, probeColorHP20, probeColorHP65, probeColorCAST, probeColorTHP, probeColorWRATH, probeColorMOON, probeColorWILD, probeColorFURY, probeColorSUN, probeColorSTAR, probeColorTHORN

Gui, +AlwaysOnTop -MaximizeBox +Theme ; Add +AlwaysOnTop option to make the GUI window always on top

; Add DropDownList for Debug options
Gui, Add, DropDownList, x2 y4 w80 vDebugOption Choose1, Debug Off|PriestBug|HunterBug|DruidBug 

; Add a slider for transparency control
Gui, Add, Slider, x87 y4 w80 h20 vTransparency gUpdateTransparency Range25-255, 175

; Add a color picker for background color
Gui, Add, Color, x87 y29 w80 h20 vBgColor, Background Color

; Add checkboxes
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


Gui, Font, s12 ; Change the font size to 12
Gui +LastFound +ToolWindow +E0x80000 ; WS_EX_LAYERED extended style
Gui, Color, %bgColor% ; Set GUI background color
WinSet, Transparent, 175 ; Set transparency level (0-255)

GuiOpen:
return

UpdateBgColor:
    Gui, Submit, NoHide
    GuiControlGet, bgColor
    GuiControl, +Background%bgColor% ; Change the background color dynamically
    return