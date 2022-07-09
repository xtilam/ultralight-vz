#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <WindowsConstants.au3>

#include "../lib/AutoItObject_Internal.au3"
#include "../function.au3"


Const $VARIABLES_GUI_SET_STATUS_GET_DATA_EVENT[] = ['$mainForm.txtZoom', '$mainForm.btnZoom', '$mainForm.txtMemMaxZoom', '$mainForm.txtMemZoom', '$mainForm.btnGetData', '$mainForm.btnUpdate', '$mainForm.btnApply']
Opt("GuiOnEventMode", 1)
$mainForm = IDispatch()

#Region ### START Koda GUI section ### Form=c:\users\dynzeny\desktop\vzoom au3\form\koda\mainform.kxf
$mainForm.parent = GUICreate("MainForm", 287, 175, 192, 124)
$mainForm.lblZoom = GUICtrlCreateLabel("Zoom ", 14, 8, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
$mainForm.txtZoom = GUICtrlCreateInput("0", 80, 8, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
$mainForm.btnZoom = GUICtrlCreateButton("OK", 212, 8, 67, 21)
$mainForm.lblStatus = GUICtrlCreateLabel("", 8, 145, 270, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
$mainForm.configGroup = GUICtrlCreateGroup("Config", 8, 31, 270, 108)
$mainForm.lblMemMaxZoom = GUICtrlCreateLabel("MemMaxZ", 16, 49, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
$mainForm.txtMemMaxZoom = GUICtrlCreateInput("0", 83, 49, 185, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
$mainForm.txtMemZoom = GUICtrlCreateInput("0", 83, 78, 185, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
$mainForm.lblMemZoom = GUICtrlCreateLabel("MemZ", 16, 78, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
$mainForm.btnApply = GUICtrlCreateButton("Apply", 103, 106, 79, 22)
$mainForm.btnGetData = GUICtrlCreateButton("Reload", 16, 106, 79, 22)
$mainForm.btnUpdate = GUICtrlCreateButton("Update", 190, 106, 79, 22)
GUISetOnEvent($GUI_EVENT_CLOSE, closeProgram)
GUISetState(@SW_SHOW)
$mainForm.setFormStatus = IDispatch()

GUICtrlSetOnEvent($mainForm.btnGetData, btnReloadEventClick)
GUICtrlSetOnEvent($mainForm.btnZoom, btnZoomEventClick)
GUICtrlSetOnEvent($mainForm.txtZoom, txtZoomEventChangeValue)
GUICtrlSetOnEvent($mainForm.btnApply, applyMemChange)
GUICtrlSetOnEvent($mainForm.btnUpdate, showUpdateForm)
#Region Form Event

Func btnReloadEventClick()
	$zoom.getDataOnline()
EndFunc   ;==>btnReloadEventClick

Func btnZoomEventClick()
	$zoom.setZoom()
EndFunc   ;==>btnZoomEventClick

Func txtZoomEventChangeValue()
	$valueZoom = Number(GUICtrlRead($zoom.mainForm.txtZoom))
	If ($valueZoom < 1000) Then
		$valueZoom = 1000
	ElseIf ($valueZoom > 10000) Then
		$valueZoom = 10000
	Else
		$valueZoom = Int($valueZoom)
	EndIf
	$zoom.zoom = $valueZoom
	GUICtrlSetData($zoom.mainForm.txtZoom, $zoom.zoom)
EndFunc   ;==>txtZoomEventChangeValue

Func applyMemChange()
	$zoom.memMaxZoom = GUICtrlRead($zoom.mainForm.txtMemMaxZoom)
	$zoom.memZoom = GUICtrlRead($zoom.mainForm.txtMemZoom)
EndFunc   ;==>applyMemChange

Func showUpdateForm()
	Local $pwForm = Execute('$passwordForm.parent')
	GUISetState(@SW_SHOW, $pwForm)
	$mainForm.setCenterForm($pwForm)
EndFunc

#EndRegion

$mainForm.setFormStatus.__defineGetter('waitData', waitData)
Func waitData($oSelf)
	Local $state = ($oSelf.arguments.length >= 1) And $oSelf.arguments.values[0] ? $GUI_DISABLE : $GUI_ENABLE
	For $i = 0 To UBound($VARIABLES_GUI_SET_STATUS_GET_DATA_EVENT) - 1
		GUICtrlSetState(Execute($VARIABLES_GUI_SET_STATUS_GET_DATA_EVENT[$i]), $state)
	Next
EndFunc   ;==>waitData

$mainForm.__defineGetter('setStatus', setStatus)
Func setStatus($oSelf)
	Local $arr = $oSelf.arguments.values
	Local $message = 'Status: { ' & _ArrayToString($arr, ' -> ') & ' }' & @CRLF	
	GUICtrlSetData($mainForm.lblStatus, $message)
EndFunc

$mainForm.__defineGetter('setCenterForm', _MF_getCenterLocation)
Func _MF_getCenterLocation($oSelf)
	$formMain = HWnd($oSelf.parent.parent)
	$formChild = HWnd($oSelf.arguments.values[0])
	
	$posMain = WinGetPos($formMain)
	If @error Then Return
	$posChild = WinGetPos($formChild)
	If @error Then Return
	
	$centerX = $posMain[0] + $posMain[2] / 2
	$centerY = $posMain[1] + $posMain[3] / 2

	$xChange = $centerX > (@DesktopWidth / 2) ?  -1 : 0
	$yChange = $centerY > (@DesktopHeight / 2) ? -1 : 0

	$x = $centerX + $xChange * $posChild[2]
	$y = $centerY + $yChange * $posChild[3]

	WinMove($formChild, '', $x, $y)
EndFunc

Func closeProgram()
	Exit
EndFunc   ;==>closeProgram
