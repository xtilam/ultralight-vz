#include-once
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include "lib/NomadMemory.au3"
#include "lib/_HttpRequest.au3"

#include "Form/mainForm.au3"
#include "Form/updateForm.au3"
#include "Form/passwordForm.au3"

#include "lib/AutoItObject_Internal.au3"
;~ #include "lib/propertyCode.au3"

#Region Common Method
$common = IDispatch()

$common.__defineGetter('debug', commonDebug)
Func commonDebug($oSelf)
	Local $arr = $oSelf.arguments.values
	Local $message = 'Debug{ ' & _ArrayToString($arr, ' -> ') & ' }' & @CRLF
	ConsoleWrite($message)
EndFunc   ;==>commonDebug

$common.__defineGetter('readPointer', __readPointer)
Func __readPointer($oSelf)
	$length = $oSelf.arguments.length
	$args = $oSelf.arguments.values
	If ($length >= 2) Then
		$handle = $args[0]
		$address = $args[1]
		For $i = 2 To $length - 1
			$value = _MemoryRead($address, $handle, "int")
			If (@error) Then Return Null
			$address = $value + $args[$i]
		Next
		Return $address
	Else
		Return Null
	EndIf
EndFunc   ;==>__readPointer

#EndRegion Common Method

#Region Zoom
$zoom = IDispatch()

$zoom.mainForm = $mainForm

$zoom.__defineGetter('updateData', updateZoomData)
;~ $zoom -> $memMaxZoom -> $memZoom -> $note -> $update
Func updateZoomData($oSelf)
	Local $this = $oSelf.parent
	Local $data = $oSelf.arguments.values
	Local $lengh = UBound($data)
	If ($lengh > 0 And $data[0] <> Null) Then $this.zoom = $data[0]
	If ($lengh > 1 And $data[1] <> Null) Then $this.memMaxZoom = $data[1]
	If ($lengh > 2 And $data[2] <> Null) Then $this.memZoom = $data[2]
	If ($lengh > 3 And $data[3] <> Null) Then $this.note = $data[3]
	If ($lengh > 4 And $data[4] <> Null) Then $this.updateDate = $data[4]
EndFunc   ;==>updateZoomData

$zoom.__defineGetter('getDataOnline', getDataOnline)
Func getDataOnline($oSelf)
	Local $this = $oSelf.parent
	$this.mainForm.setFormStatus.waitData(True)
	GUICtrlSetData($this.mainForm.lblStatus, 'Loading ....')
	While True
;~ Local $result = _HttpRequest(2, $config.urlAPI)
		Local $result = '{"max_zoom":"0x01C28938,12,552,40","zoom":"0x01C28938,12,608","note":"update","update_date":"2020-05-24 01:21:41","zoom_default":"2500"}'
		SetExtended('200')
;		$common.debug($result, 'request', @extended)
		If @extended <= 0 Then
			GUICtrlSetData($this.mainForm.lblStatus, 'Connect Failed!')
			Local $reload = MsgBox($MB_ICONERROR + $MB_OKCANCEL, "Error", "Connect Failed! Again?")
			If ($reload <> 1) Then
				ExitLoop
			EndIf
		Else
			Local $oJson = _HttpRequest_ParseJSON($result)
			$this.updateData($oJson.zoom_default, $oJson.max_zoom, $oJson.zoom, $oJson.note, $oJson.update_date)
			$this.updateForm()
			ExitLoop
		EndIf
	WEnd
	$this.mainForm.setFormStatus.waitData(False)
EndFunc   ;==>getDataOnline

$zoom.__defineGetter('updateForm', updateMainForm)
Func updateMainForm($oSelf)
	$this = $oSelf.parent
	Local $form = $this.mainForm
	GUICtrlSetData($form.txtZoom, $this.zoom)
	GUICtrlSetData($form.txtMemMaxZoom, $this.memMaxZoom)
	GUICtrlSetData($form.txtMemZoom, $this.memZoom)
	GUICtrlSetData($form.lblStatus, 'Update Date: ' & $this.updateDate)
EndFunc   ;==>updateMainForm

$zoom.__defineGetter('setZoom', setMemProcess)

Func setMemProcess($oSelf)
	$this = $oSelf.parent
	$PID = ProcessExists($config.nameProcess)
	If Not $PID Then
		$this.mainForm.setStatus('Not Found Process!')
	Else
		$handle = _MemoryOpen($PID)
		$baseAddress = _ProcessGetModuleBaseAddress($PID, $config.baseAddress)

		Local $zoomStatus = 'Zoom: Mem?', $zoomMaxStatus = 'MaxZ: Mem?'

		$zoomAddress = Execute('$common.readPointer($handle, ' & $baseAddress & '+' & $this.memZoom & ')')
		If ($zoomAddress <> Null) Then
			_MemoryWrite($zoomAddress, $handle, $this.zoom, 'float')
			$zoomStatus = _MemoryRead($zoomAddress, $handle, 'float') = $this.zoom ? 'Zoom: OK' : 'Zoom: WriteFailed'
		EndIf

		$zoomMaxAddress = Execute('$common.readPointer($handle, ' & $baseAddress & '+' & $this.memMaxZoom & ')')
		If ($zoomAddress <> Null) Then
			_MemoryWrite($zoomAddress, $handle, $this.zoom, 'float')
			$zoomMaxStatus = _MemoryRead($zoomMaxAddress, $handle, 'float') = $this.zoom ? 'MaxZ: OK' : 'MaxZ: WriteFailed'
		EndIf

		$zoom.mainForm.setStatus($zoomStatus, $zoomMaxStatus)

;		$common.debug(Hex($zoomAddress), Hex($zoomMaxAddress), $this.zoom)
	EndIf
EndFunc   ;==>setMemProcess

#EndRegion Zoom
