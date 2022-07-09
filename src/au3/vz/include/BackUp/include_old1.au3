#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
Opt('GUIOnEventMode', 1)
$Form1 = GUICreate("Form1", 219, 80, 192, 124)
$Input1 = GUICtrlCreateInput("Input1", 60, 24, 121, 21)
GUISetState(@SW_SHOW)
$Form2 = GUICreate("Form2", 219, 80, 192, 324)
$Input2 = GUICtrlCreateInput("Input1", 60, 24, 121, 21)
GUISetState(@SW_SHOW)
$Form3 = GUICreate("Form2", 219, 101, 192, 524)
$Input3 = GUICtrlGetHandle(GUICtrlCreateInput("Input1", 60, 24, 121, 21))
$Button3 = GUICtrlCreateButton("Button", 60, 53, 121, 21)
GUISetState(@SW_SHOW)
GUISetOnEvent($Button3, exec)

Func exec()
    ConsoleWrite('->')
    ConsoleWrite( '-> ' & Execute(GUICtrlRead($Input3)) & @CRLF)
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
