#include "function.au3"

#Region Config
$config = IDispatch()
$config.urlAPI = 'https://maxe17q.000webhostapp.com/API/data.php'
$config.nameProcess = 'League of Legends.exe'
$config.baseAddress = 'League of Legends.exe'
$config.zoomDefault = 2250
$mainForm.isHide = False
#EndRegion Config

#Region MainProgram
$zoom.getDataOnline()
HotKeySet('{F10}', _HK_HideOrShowForm)
HotKeySet('{F11}', _HK_SetMem)

Func _HK_HideOrShowForm()
;	$common.debug(String(HWnd($mainForm.parent)), $mainForm.isHide)
	If $mainForm.isHide Then
		$mainForm.isHide = False
		GUISetState(@SW_SHOW, HWnd($mainForm.parent))
	Else
		$mainForm.isHide = True
		GUISetState(@SW_HIDE, HWnd($mainForm.parent))
	EndIf
EndFunc   ;==>_HK_HideOrShowForm

Func _HK_SetMem()
	$zoom.setZoom()
EndFunc   ;==>_HK_SetMem

While True
	Sleep(250)
WEnd
#EndRegion MainProgram
