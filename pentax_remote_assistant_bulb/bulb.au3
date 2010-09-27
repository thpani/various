; (c) 2010  Thomas Pani
; control bulb exposure in PENTAX Remote Assistant 

#RequireAdmin

#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

Opt('MustDeclareVars', 1)

Const $pra = "PENTAX REMOTE Assistant"

Main()

Func OpenPRA()
	If Not WinExists($pra) Then
		Run(@ProgramFilesDir & "\Pentax\Digital Camera Utility\PRMAST01.exe")
		WinWait($pra)
	EndIf
	
	WinActivate($pra)
	Local $size = WinGetPos("")
	Local $pos = ControlGetPos($pra, "", "Release")
	MouseMove($pos[0]+$size[0]+20, $pos[1]+$size[1]+60)
EndFunc

Func Main()
	;Initialize variables
	Local $GUIWidth = 320, $GUIHeight = 100
	Local $inputDelay, $inputLength, $OK_Btn, $Cancel_Btn, $msg, $checkBeep

	;Create window
	GUICreate("Bulb Exposure Control", $GUIWidth, $GUIHeight)

	;Create an updown
	GUICtrlCreateLabel("Delay:", 10, 12)
	$inputDelay = GUICtrlCreateInput("2", 50, 10, 50, 20, $ES_NUMBER)
    GUICtrlCreateUpdown($inputDelay)
	
	GUICtrlCreateLabel("Exposure Length:", 110, 12)
	$inputLength = GUICtrlCreateInput("2", 200, 10, 50, 20, $ES_NUMBER)
    GUICtrlCreateUpdown($inputLength)

	;Create an "OK" button
	$OK_Btn = GUICtrlCreateButton("OK", 75, 50, 70, 25)

	;Create a "CANCEL" button
	$Cancel_Btn = GUICtrlCreateButton("Beenden", 165, 50, 70, 25)
	
	$CheckBeep = GUICtrlCreateCheckbox("Beep", 260, 10)

	;Show window/Make the window visible
	GUISetState(@SW_SHOW)

	While 1
		;After every loop check if the user clicked something in the GUI window
		$msg = GUIGetMsg()

		Select

			;Check if user clicked on the close button
			Case $msg = $GUI_EVENT_CLOSE
				;Destroy the GUI including the controls
				GUIDelete()
				;Exit the script
				Exit

				;Check if user clicked on the "OK" button
			Case $msg = $OK_Btn
				Shoot(GUICtrlRead($inputDelay), GUICtrlRead($inputLength), GUICtrlRead($checkBeep) == $GUI_CHECKED)

				;Check if user clicked on the "CANCEL" button
			Case $msg = $Cancel_Btn
				;Destroy the GUI including the controls
				GUIDelete()
				;Exit the script
				Exit

		EndSelect

	WEnd
EndFunc

Func Shoot($delay, $length, $beep)
	ProgressOn("Delay", "Waiting " & $delay & " seconds before opening shutter", "0 seconds")
	For $i = 0 to $delay step 1
		sleep(1000)
		ProgressSet( $i / $delay * 100, $i & " seconds")
	Next
	ProgressSet(100 , "Done", "Complete")
	sleep(500)
	ProgressOff()
	
	If $beep Then
		Beep(1000, 500)
		Beep(1000, 500)
		Beep(1000, 500)
	EndIf
	
	OpenPRA()
	
	MouseDown("left")
	ProgressOn("Bulb Exposure", "Waiting " & $length & " seconds for bulb exposure", "0 seconds")
	For $i = 0 to $length step 1
		sleep(1000)
		ProgressSet( $i / $length * 100, $i & " seconds")
	Next
	ProgressSet(100 , "Done", "Complete")
	sleep(500)
	ProgressOff()
	MouseUp("left")
	
	If $beep Then
		Beep(1000, 500)	
		Beep(1000, 500)
		Beep(1000, 500)
	EndIf
EndFunc
