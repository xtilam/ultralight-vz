#include-once
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include "JSON/OO_JSON.au3"

Global $ultralightDLL = -1
Global $Ultralight_WHWND = -1

Global $ultralightOldLocationX = 0
Global $ultralightOldLocationY = 0
Global $ultralightOldHeight = 0
Global $ultralightOldWidth = 0
Global $ultralightIsStartWatchMove = 0

Global Const $JS_TYPE_NUMBER = 1
Global Const $JS_TYPE_STRING = 2
Global Const $JS_TYPE_OBJECT = 3
Global Const $JS_TYPE_UNDEFINED = 4
Global Const $JS_TYPE_NULL = 5
Global Const $JS_TYPE_BOOLEAN = 6
Global Const $kWindowFlags_Borderless = 1
Global Const $kWindowFlags_Maximizable = 8
Global Const $kWindowFlags_Resizable = 4
Global Const $kWindowFlags_Titled = 2

#NoTrayIcon


Func Ultralight_RunApp()
	DllCall($ultralightDLL, 'NONE', 'runApp')
EndFunc   ;==>Ultralight_RunApp

Func Ultralight_InitApp()
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, 'NONE', 'initApp')
	$Ultralight_WHWND = Ultralight_GetWindowHandle()
	DllCall($ultralightDLL, 'NONE', 'setCallbackHandleCallFunction', 'ptr', DllCallbackGetPtr(DllCallbackRegister(Ultralight_MainHandleData, 'none', 'int;str;ptr;ptr')))
EndFunc   ;==>Ultralight_InitApp


Func Ultralight_MainHandleData($length, $stringInit, $pointer, $pointerResult)
	$callString = ''

	Local $struct = DllStructCreate($stringInit, $pointer)
	Local $args[$length]
	Local $call = ""
	For $i = 0 To $length - 1 Step +1
		Local $variable = DllStructGetData($struct, 'v' & $i)
		Local $type = DllStructGetData($struct, 'tv', $i + 1)
		Switch ($type)
			Case $JS_TYPE_OBJECT
				$variable = _JSVal($variable)
			Case $JS_TYPE_NULL
				$variable = Null
			Case $JS_TYPE_UNDEFINED
				$variable = Null
			Case $JS_TYPE_STRING
				If (IsNumber($variable)) Then $variable = ''
			Case $JS_TYPE_BOOLEAN
				If ($variable = 0) Then
					$variable = False
				Else
					$variable = True
				EndIf
		EndSwitch
		$args[$i] = $variable

		$call = $call & ',$args[' & $i & ']'
	Next

	Local $result = Execute('Call(' & StringTrimLeft($call, 1) & ')')

	If (@error <> 0) Then Return
	Switch (VarGetType($result))
		Case 'String'
			DllCall($ultralightDLL, 'none', 'makeString', 'ptr', $pointerResult, 'wstr', $result)
		Case 'Object'
			DllCall($ultralightDLL, 'none', 'makeObject', 'ptr', $pointerResult, 'wstr', $result.json())
		Case Else
			If (IsNumber($result)) Then
				DllCall($ultralightDLL, 'none', 'makeNumber', 'ptr', $pointerResult, 'double', $result)
			Else
				DllCall($ultralightDLL, 'none', 'makeNull', 'ptr', $pointerResult)
			EndIf
	EndSwitch
EndFunc   ;==>Ultralight_MainHandleData

Func Ultralight_createThread($func)
	Local $handle = DllCallbackRegister($func, 'none', '')
	DllCall($ultralightDLL, 'none', 'createThread', 'ptr', DllCallbackGetPtr($handle), 'int', $handle)
EndFunc   ;==>Ultralight_createThread

Func Ultralight_LoadDLL($ultralightDLLPath = "AU3Utralight.dll")
	If ($ultralightDLL = -1) Then
		$ultralightDLL = DllOpen($ultralightDLLPath)
		If ($ultralightDLL = -1) Then
			MsgBox($MB_ICONERROR, "Lỗi", "Không load đc dll (AU3Utralight.dll)")
			Exit
		EndIf
		DllCall($ultralightDLL, 'NONE', 'setCallbackFreeFunction', 'ptr', DllCallbackGetPtr(DllCallbackRegister(Ultralight_FreeCallback, 'none', 'int')))
	EndIf
EndFunc   ;==>Ultralight_LoadDLL

Func Ultralight_LoadURL($url)
	DllCall($ultralightDLL, "NONE", "loadURL", "str", $url)
EndFunc   ;==>Ultralight_LoadURL

Func Ultralight_GetWindowHandle()
	If ($Ultralight_WHWND <> -1) Then $Ultralight_WHWND
	Return DllCall($ultralightDLL, "hwnd", "getWindowHandle")[0]
EndFunc   ;==>Ultralight_GetWindowHandle

Func Ultralight_LoadHTML($html)
	DllCall($ultralightDLL, "NONE", "loadHTML", "str", $html)
EndFunc   ;==>Ultralight_LoadHTML

Func Ultralight_ConfigWindowSize($width, $height)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "NONE", "configWindowSize", "int", $width, 'int', $height)
EndFunc   ;==>Ultralight_ConfigWindowSize

Func Ultralight_ConfigWindowFlag($flag)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "NONE", "configWindowFlag", "int", $flag)
EndFunc   ;==>Ultralight_ConfigWindowFlag

Func Ultralight_ResizeWindow($width, $height)
	Local $aPos = WinGetPos($Ultralight_WHWND)
	WinMove($Ultralight_WHWND, '', $aPos[0], $aPos[1], $width, $height)
EndFunc   ;==>Ultralight_ResizeWindow

Func Ultralight_MoveWindow($x, $y)
	Local $aPos = WinGetPos($Ultralight_WHWND)
	WinMove($Ultralight_WHWND, '', $x, $y, $aPos[2], $aPos[3])
EndFunc   ;==>Ultralight_MoveWindow

Func Ultralight_ResizeInspector($width, $direction = 0)
	DllCall($ultralightDLL, 'none', 'resizeInspector', 'int', $direction, 'short', $width)
EndFunc   ;==>Ultralight_ResizeInspector

Func Ultralight_SetEnableInspector($isEnable = False)
	DllCall($ultralightDLL, 'none', 'setEnableInspector', 'bool', $isEnable)
EndFunc   ;==>Ultralight_SetEnableInspector

Func Ultralight_SetWindowTitle($title = '')
	DllCall($ultralightDLL, 'none', 'setTitle', 'str', $title)
EndFunc   ;==>Ultralight_SetWindowTitle

Func Ultralight_SendSignal($value)
	Local $type = VarGetType($value)
	Local $pointerSignal = DllCall($ultralightDLL, 'ptr', 'createSignal')[0]
	If (IsNumber($value)) Then
		DllCall($ultralightDLL, 'none', 'pushNumberParamToSignal', 'ptr', $pointerSignal, 'double', $value)
	ElseIf (IsObj($value)) Then
		DllCall($ultralightDLL, 'none', 'pushObjectParamToSignal', 'ptr', $pointerSignal, 'wstr', $value.json())
	ElseIf (IsString($value)) Then
		DllCall($ultralightDLL, 'none', 'pushStringParamToSignal', 'ptr', $pointerSignal, 'wstr', $value)
	ElseIf (IsArray($value)) Then
		For $item In $value
			If (IsNumber($item)) Then
				DllCall($ultralightDLL, 'none', 'pushNumberParamToSignal', 'ptr', $pointerSignal, 'double', $item)
			ElseIf (IsObj($item)) Then
				DllCall($ultralightDLL, 'none', 'pushObjectParamToSignal', 'ptr', $pointerSignal, 'wstr', $item.json())
			ElseIf (IsString($item)) Then
				DllCall($ultralightDLL, 'none', 'pushStringParamToSignal', 'ptr', $pointerSignal, 'wstr', $item)
			Else
				DllCall($ultralightDLL, 'none', 'pushNullParamToSignal', 'ptr', $pointerSignal)
			EndIf
		Next
	Else
		DllCall($ultralightDLL, 'none', 'pushNullParamToSignal', 'ptr', $pointerSignal)
	EndIf
	DllCall($ultralightDLL, 'ptr', 'sendSignal', 'ptr', $pointerSignal)
	Return 1
EndFunc   ;==>Ultralight_SendSignal

Func Ultralight_FreeCallback($id)
	DllCallbackFree($id)
	_JS_onThreadDeath()
EndFunc   ;==>Ultralight_FreeCallback

Func Ultralight_StartMoveApp()
	if($ultralightIsStartWatchMove) Then Return
	Local $pos = MouseGetPos()
	Local $winPos = WinGetPos(Ultralight_GetWindowHandle(), '')
	$ultralightOldLocationX = $pos[0]
	$ultralightOldLocationY = $pos[1]
	$ultralightOldWidth = $winPos[0]
	$ultralightOldHeight = $winPos[1]
	$ultralightIsStartWatchMove = True
	Ultralight_createThread(Ultralight_StartMoveAppThread)
EndFunc   ;==>Ultralight_StartMoveApp

Func Ultralight_StartMoveAppThread()
	While ($ultralightIsStartWatchMove)
		Local $pos = MouseGetPos()
		Local $x = $ultralightOldWidth + $pos[0] - $ultralightOldLocationX
		Local $y = $ultralightOldHeight + $pos[1] - $ultralightOldLocationY
		Ultralight_MoveWindow($x, $y)
	WEnd
EndFunc   ;==>Ultralight_StartMoveAppThread

Func Ultralight_StopMoveApp()
	$ultralightIsStartWatchMove = False
EndFunc   ;==>Ultralight_StopMoveApp


Func ll($content, $subScription = '')
	ConsoleWrite($subScription & " => " & $content & @CRLF)
EndFunc   ;==>ll



