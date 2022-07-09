#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include "updateForm.au3"

#include "../lib/AutoItObject_Internal.au3"
#include "../lib/_HttpRequest.au3"

Opt("GuiOnEventMode", 1)

$passwordForm = IDispatch()
$passwordForm.parent = GUICreate("Admin PW", 246, 99, -1, -1)
$passwordForm.passwordEdit = GUICtrlCreateInput("", 8, 32, 233, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$passwordForm.btnOk = GUICtrlCreateButton("OK", 86, 64, 75, 25)
$passwordForm.btnCancel = GUICtrlCreateButton("Cancel", 167, 64, 75, 25)
$passwordForm.EnterPassLabel = GUICtrlCreateLabel("Enter password", 8, 12, 77, 17, 0)

GUICtrlSetOnEvent($passwordForm.btnOk, _PF_EV_showUpdateForm)
GUICtrlSetOnEvent($passwordForm.btnCancel, hidePasswordForm)
GUISetOnEvent($GUI_EVENT_CLOSE, hidePasswordForm, $passwordForm.parent)

Func hidePasswordForm()
	GUISetState(@SW_HIDE, $passwordForm.parent)
	GUICtrlSetData($passwordForm.passwordEdit, '')
EndFunc

#region Form Event
Func _PF_EV_showUpdateForm()
	$passwordInput = GUICtrlRead($passwordForm.passwordEdit)
	$rs = _HttpRequest('2', $config.urlAPI, 'action=update&password=' & $passwordInput)
	if (@extended >= 0 ) Then
		MsgBox($MB_ICONERROR, 'Error', 'Connect Failed!')
	Execute('$common.debug($rs, $passwordInput, VarGetType($updateForm.reloadForm))')
		Return
	EndIf
	$oJson = _HttpRequest_ParseJSON($rs)
	if Not @error Then
		$password = $oJson.get('password')
		$passwordForm.password = $password
		hidePasswordForm()
		GUISetState(@SW_SHOW, $updateForm.parent)
		$as = $updateForm.reloadForm
		Local $_ = $updateForm
		$updateForm.setData($_.txtZoom, $oJson.zoom).setData($_.txtMaxZoom, $oJson.max_zoom).setData($_.txtNote, $oJson.note).setData($_.txtZoomDefault, $oJson.zoom_default).setData($_.txtNewPassword, '').setData($_.txtConfimNewPassword, '')
		Execute('$mainForm.setCenterForm($passwordForm.parent)')
	Else
		MsgBox($MB_ICONWARNING + $MB_OKCANCEL, 'Warning', 'Password Wrong')
	EndIf
EndFunc
#endregion