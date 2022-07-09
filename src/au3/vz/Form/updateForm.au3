#include-once
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "../lib/AutoItObject_Internal.au3"

Opt("GuiOnEventMode", 1)

$updateForm = IDispatch()
$updateForm.parent = GUICreate("Form1", 275, 359, 192, 124)
$updateForm.Group1 = GUICtrlCreateGroup("Update", 8, 8, 257, 341)
$updateForm.btnOK = GUICtrlCreateButton("OK", 16, 316, 116, 25)
$updateForm.btnCancel = GUICtrlCreateButton("Cancel", 141, 316, 116, 25)
$updateForm.lblZoom = GUICtrlCreateLabel("Zoom", 16, 28, 31, 17, $SS_CENTERIMAGE)
$updateForm.txtZoom = GUICtrlCreateInput("", 16, 50, 240, 21)
$updateForm.lblMaxZoom = GUICtrlCreateLabel("Max Zoom", 16, 76, 54, 17, $SS_CENTERIMAGE)
$updateForm.txtMaxZoom = GUICtrlCreateInput("", 16, 98, 240, 21)
$updateForm.lblZoomDefault = GUICtrlCreateLabel("Zoom Default", 16, 124, 68, 17, $SS_CENTERIMAGE)
$updateForm.txtZoomDefault = GUICtrlCreateInput("", 16, 146, 240, 21)
$updateForm.lblNewPassword = GUICtrlCreateLabel("New Password", 16, 172, 75, 17, $SS_CENTERIMAGE)
$updateForm.txtNewPassword = GUICtrlCreateInput("", 16, 194, 240, 21, $ES_PASSWORD)
$updateForm.lblConfimPassword = GUICtrlCreateLabel("Confim Password", 16, 220, 85, 17, $SS_CENTERIMAGE)
$updateForm.txtConfimNewPassword = GUICtrlCreateInput("", 16, 242, 240, 21, $ES_PASSWORD)
$updateForm.lblNote = GUICtrlCreateLabel("Note", 16, 268, 27, 17, $SS_CENTERIMAGE)
$updateForm.txtNote = GUICtrlCreateInput("", 16, 290, 240, 21)
$updateForm.__defineGetter('setData', __UF_setData)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlSetOnEvent($updateForm.btnOK, _UF_EV_updateDataOnline)
GUICtrlSetOnEvent($updateForm.btnCancel, _UF_EV_hideForm)
GUISetOnEvent($GUI_EVENT_CLOSE, _UF_EV_hideForm)
Func _UF_EV_updateDataOnline()
	$dataSend = ''
	$password = GUICtrlRead($updateForm.txtNewPassword)
	$passwordConfim = GUICtrlRead($updateForm.txtConfimNewPassword)
	$max_zoom = GUICtrlRead($updateForm.txtMaxZoom)
	$zoom = GUICtrlRead($updateForm.txtZoom)
	$note = GUICtrlRead($updateForm.txtNote)
	$zoomDefault = GUICtrlRead($updateForm.txtZoomDefault)
;    Execute('$common.debug($password, $passwordConfim)')
	If ($password <> $passwordConfim) Then
		MsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, 'Warning', 'New password and confim password are not same')
		Return
	ElseIf StringLen($password) <> 0 Then
		$dataSend = $dataSend & '&new_password=' & $password
	EndIf

	If StringLen($zoom) > 0 Then $dataSend = $dataSend & '&zoom=' & $zoom
	If StringLen($max_zoom) > 0 Then $dataSend = $dataSend & '&max_zoom=' & $max_zoom
	If StringLen($note) > 0 Then $dataSend = $dataSend & '&note=' & $note
	If StringLen($zoomDefault) > 0 Then $dataSend = $dataSend & '&zoom_default=' & $zoomDefault

	$dataSend = 'action=update&password=' & Execute('$passwordForm.password') & $dataSend
    $rs = Execute("_HttpRequest('2', $config.urlAPI, $dataSend)")
    If @extended <= 0 Then
        MsgBox(0, 0, 'Connnect Failed')
        Return
    EndIf
	$oJson = Execute("_HttpRequest_ParseJSON()")
    If @error = 0 Then
        MsgBox($MB_ICONERROR, 'Error', 'Password Wrong')
        Return
	EndIf
;    Execute('$common.debug($rs, $dataSend)')
    MsgBox($MB_ICONINFORMATION, 'Success', 'Update Success')
    GUISetState(@SW_HIDE, $updateForm.parent)
EndFunc   ;==>updateDataOnline

Func _UF_EV_hideForm()
    GUISetState(@SW_HIDE, $updateForm.parent)
EndFunc

Func __UF_setData($oSelf)
    GUICtrlSetData($oSelf.arguments.values[0], $oSelf.arguments.values[1])
;    Execute("$common.debug($oSelf.arguments.values[0], $oSelf.arguments.values[1])")
    Return $oSelf.parent
EndFunc