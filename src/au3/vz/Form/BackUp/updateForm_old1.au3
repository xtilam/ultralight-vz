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
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlSetOnEvent($updateForm.btnOK, updateDataOnline)
Func updateDataOnline()
    $dataSend = ''
    $password = GUICtrlRead($updateForm.txtNewPassword)
    $passwordConfim = GUICtrlRead($updateForm.txtConfimNewPassword)
    $max_zoom = GUICtrlRead($updateForm.txtMaxZoom)
    $zoom = GUICtrlRead($updateForm.txtZoom)
    $note = GUICtrlRead($updateform.txtNote)
    $zoomDefault = GUICtrlRead($updateform.txtZoomDefault)

    if($password = $passwordConfim) Then 
        MsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, 'Warning','New password and confim password are not same')
        Return
    ElseIf StringLen($password) <> 0 Then
        $password = Null
    Else
        $dataSend = $dataSend & '&new_password=' & $password
    EndIf

    If StringLen($zoom) > 0 Then $dataSend = $dataSend & '&zoom=' & $zoom
    If StringLen($maz_zoom) > 0 Then $dataSend = $dataSend & '&max_zoom=' & $max_zoom
    If StringLen($note) > 0 Then $dataSend = $dataSend & '&note=' & $note
    If StringLen($zoomDefault) > 0 Then $dataSend = $dataSend & '&zoom_default=' & $zoomDefault

    $dataSend = 'action=update&password=' & Execute('$passwordForm.password') & $dataSend 
    MsgBox(0, 0, $dataSend)
    $result = Execute('_HttpRequest_ParseJSON(_HttpRequest('2', $config.urlAPI, $dataSend))')
EndFunc
