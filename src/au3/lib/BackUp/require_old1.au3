
#include-once
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>


#include <WinAPIFiles.au3>
#include <File.au3>
#include <GuiStatusBar.au3>
#include <Array.au3>
#include <String.au3>
#include <Crypt.au3>

#include "zip.au3"
#include "JSON/OO_JSON.au3"

Global Const $REQUIRE_DOWNLOADED_PATH = @ScriptDir & '\downloaded.json'
Global Const $REQUIRE_TEMP_FOLDER_DOWNLOAD = @ScriptDir & '\require_temp_download'

Global $REQUIRE_DownloadGUI = -1
Global $REQUIRE_listFile[0][5]
Global $REQUIRE_statusDownload
Global $REQUIRE_isCreateTempFolderDownload = False

Global $REQUIRE_download_Counted = 0
Global $REQUIRE_download_Files = 0

REQUIRE_Init()

Func REQUIRE_StartDownload()
	$REQUIRE_download_Files = UBound($REQUIRE_listFile)
	$REQUIRE_download_Counted = 0

	Local $downloadInfo = FileRead($REQUIRE_DOWNLOADED_PATH)

	$REQUIRE_statusDownload = _JSVal($downloadInfo)

	If (VarGetType($REQUIRE_statusDownload) <> 'Object') Or ($REQUIRE_statusDownload.isArray()) Then
		$REQUIRE_statusDownload = _JSVal('{}')
		writeDownloadedLog()
	EndIf

	REQUIRE_showDownloadGUI()
	REQUIRE_setDownload('testajsdklsajdkl12j3lk12j3kl12j3kl12j3luj1i2o3u12803o.com', 100000)
	REQUIRE_setPercentDownload(10000, 100000)

	While ( true )
		
	WEnd
	For $i = 0 To $REQUIRE_download_Files - 1 Step +1
		Local $md5Zip = $REQUIRE_listFile[$i][2]

		if($md5Zip) Then
			Local $zipPath = $REQUIRE_TEMP_FOLDER_DOWNLOAD & '\' & $md5Zip & '.zip'
			if Not($REQUIRE_statusDownload.at($md5Zip)) Then
				if (Not FileExists($zipPath) Or $REQUIRE_statusDownload.at($zipPath) <> True) Then REQUIRE_downloadFile($REQUIRE_listFile[$i][0], $REQUIRE_listFile[$i][1])
				_Zip_UnzipAll($zipPath, $REQUIRE_listFile[$i][4]) 
				$REQUIRE_statusDownload.del($REQUIRE_listFile[$i][1])
				$REQUIRE_statusDownload.set($md5Zip, True) 
				writeDownloadedLog()
			EndIf
		Else
			REQUIRE_downloadFile($REQUIRE_listFile[$i][0], $REQUIRE_listFile[$i][1])
		EndIf

	Next

	$REQUIRE_statusDownload = ''

	If (FileExists($REQUIRE_TEMP_FOLDER_DOWNLOAD)) Then DirRemove($REQUIRE_TEMP_FOLDER_DOWNLOAD, 1)
	Redim $REQUIRE_listFile[0][5]

	REQUIRE_closeDownloadGUI()
EndFunc   ;==>REQUIRE_StartDownload

Func REQUIRE_File($url, $savePath, $name = '')
	Local $index = _ArrayAdd($REQUIRE_listFile, '')
	$REQUIRE_listFile[$index][0] = $url
	$REQUIRE_listFile[$index][1] = $savePath
	$REQUIRE_listFile[$index][2] = $name
EndFunc   ;==>REQUIRE_File

Func REQUIRE_Zip($url, $extractPath = '', $name = '')
	If ($REQUIRE_isCreateTempFolderDownload = False) Then
		If (FileGetAttrib($REQUIRE_TEMP_FOLDER_DOWNLOAD) <> 'D') Then
			If (FileExists($REQUIRE_TEMP_FOLDER_DOWNLOAD)) Then FileDelete($REQUIRE_TEMP_FOLDER_DOWNLOAD)
			DirCreate($REQUIRE_TEMP_FOLDER_DOWNLOAD)
		EndIf
		$REQUIRE_isCreateTempFolderDownload = True
	EndIf

	Local $md5URL = String(_Crypt_HashData($url, $CALG_MD5))
	Local $filePath = 'require_temp_download/' & $md5URL & '.zip'
	Local $index = _ArrayAdd($REQUIRE_listFile, '')
	
	$REQUIRE_listFile[$index][0] = $url
	$REQUIRE_listFile[$index][1] = $filePath
	$REQUIRE_listFile[$index][2] = $name
	$REQUIRE_listFile[$index][3] = $md5URL
	$REQUIRE_listFile[$index][4] = _PathFull(@ScriptDir & '/' & $extractPath)
EndFunc   ;==>REQUIRE_Zip

Func REQUIRE_downloadFile($url, $savePath, $name = '')
	$savePath = StringStripWS($savePath, 3)
    if(Not $name) Then $name = $savePath
	Local $filePath = _PathFull(@ScriptDir & '/' & $savePath)
	REQUIRE_CreateFolder($filePath)

	If ($REQUIRE_statusDownload.at($savePath) <> True Or Not FileExists($filePath)) Then
		If (FileExists($filePath)) Then FileDelete($filePath)

		Local $URLSize = InetGetSize($url)
		Local $error = @error
		If ($error <> 0) Then Return REQUIRE_handleErrorRequireFile($url, $savePath)
		REQUIRE_showDownloadGUI()
		REQUIRE_setDownload($savePath, $URLSize)

		Local $hDownload = InetGet($url, $filePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

		While (True)
			;~ Download error
			If (InetGetInfo($hDownload, $INET_DOWNLOADERROR)) Then
				InetClose($hDownload)
				REQUIRE_handleErrorRequireFile($url, $savePath)
			EndIf

			If (InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)) Then ExitLoop
			Local $currentSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
			REQUIRE_handleEventDownloadGUI()
			REQUIRE_setPercentDownload($currentSize, $URLSize)
			Sleep(5)
		WEnd

		InetClose($hDownload)

		$REQUIRE_statusDownload.set($name, True)
		writeDownloadedLog()
	EndIf

	$REQUIRE_download_Counted += 1
EndFunc   ;==>REQUIRE_downloadFile

Func REQUIRE_handleErrorRequireFile($url, $filename)
	MsgBox($MB_ICONERROR, "Download Error", 'LINK:' & $url & @CRLF & 'Filename:' & $filename)
	Exit
EndFunc   ;==>REQUIRE_handleErrorRequireFile

Func REQUIRE_Init()
;~ set environment
	EnvSet("PATH", @ScriptDir & '\bin' & ';' & EnvGet('PATH'))
EndFunc   ;==>REQUIRE_Init

Func REQUIRE_CreateFolder($path)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	Local $aPathSplit = _PathSplit($path, $sDrive, $sDir, $sFileName, $sExtension)
	Local $dirname = $aPathSplit[1] & $aPathSplit[2]
	If (Not FileExists($dirname)) Then DirCreate($dirname)
EndFunc   ;==>REQUIRE_CreateFolder


Func REQUIRE_showDownloadGUI()
	If ($REQUIRE_DownloadGUI <> -1) Then Return
	$Form1_1 = GUICreate("Form1", 420, 227, 192, 124)
GUISetFont(12, 800, 0, "Segoe UI")
GUISetBkColor(0x0080C0)
$downloadPercentVal = GUICtrlCreateLabel(" 100%", 10, 10, 100, 25)
GUICtrlSetColor(-1, 0x008000)
GUICtrlSetBkColor(-1, 0xF7F7F7)
$downloadProgressBorder = GUICtrlCreateLabel("", 10, 35, 400, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xF7F7F7)
$downloadProgressVal = GUICtrlCreateLabel("", 15, 40, 300, 15)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x008000)
$speedDownloadVal = GUICtrlCreateLabel("0 KB/s ", 110, 10, 300, 25, $SS_RIGHT)
GUICtrlSetColor(-1, 0x400080)
GUICtrlSetBkColor(-1, 0xF7F7F7)
$nameFileDownload = GUICtrlCreateLabel("Ultralight.zip", 10, 70, 400, 25, $SS_CENTER)
GUICtrlSetColor(-1, 0xFF8000)
GUICtrlSetBkColor(-1, 0x000000)
$pathLabel = GUICtrlCreateLabel(" Path", 10, 100, 80, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$pathVal = GUICtrlCreateLabel(" /bin", 95, 100, 315, 25)
GUICtrlSetColor(-1, 0xFF8000)
GUICtrlSetBkColor(-1, 0x000000)
$urlLabel = GUICtrlCreateLabel(" URL", 10, 130, 80, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$urlVal = GUICtrlCreateLabel(" www.google.com/test.zip", 95, 130, 315, 25)
GUICtrlSetColor(-1, 0xFF8000)
GUICtrlSetBkColor(-1, 0x000000)
$sizeLabel = GUICtrlCreateLabel(" Size", 10, 160, 80, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$sizeVal = GUICtrlCreateLabel(" 10 MB ( 5.2 MB )", 95, 160, 315, 25)
GUICtrlSetColor(-1, 0xFF8000)
GUICtrlSetBkColor(-1, 0x000000)
$timeLeftLabel = GUICtrlCreateLabel(" Time left", 10, 190, 80, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
$timeLeftVal = GUICtrlCreateLabel(" www.google.com/test.zip", 95, 190, 315, 25)
GUICtrlSetColor(-1, 0xFF8000)
GUICtrlSetBkColor(-1, 0x000000)
GUISetState(@SW_SHOW)
	WinActivate($REQUIRE_DownloadGUI)
EndFunc   ;==>REQUIRE_showDownloadGUI

Func REQUIRE_setDownload($filename, $totalSize)
	_GUICtrlStatusBar_SetText($REQUIRE_DownloadGUI_StatusBar, @TAB & $REQUIRE_download_Counted & '/' & $REQUIRE_download_Files, 0)
	_GUICtrlStatusBar_SetText($REQUIRE_DownloadGUI_StatusBar, @TAB & $filename & ' (' & REQUIRE_CalcSizeText($totalSize) & ')', 1)
EndFunc   ;==>REQUIRE_setDownload

Func REQUIRE_setPercentDownload($currentSize, $totalSize, $speedDownload = 0)
	Local $percent = 0
	If ($currentSize > 0) Then $percent = Round($currentSize / $totalSize * 100, 1)
	GUICtrlSetData($REQUIRE_DownloadGUI_DownloadProgress, $percent)
	GUICtrlSetData($REQUIRE_DownloadGUI_PercentLabel, $percent & '%')
EndFunc   ;==>REQUIRE_setPercentDownload

Func REQUIRE_closeDownloadGUI()
	GUIDelete($REQUIRE_DownloadGUI)
EndFunc   ;==>REQUIRE_closeDownloadGUI

Func REQUIRE_CalcSizeText($sizeByte)
	Local $sizes[] = ['KB', 'MB', 'GB', 'TB']
	Local $unitSize = $sizes[0]
	For $cs In $sizes
		If ($sizeByte < 700) Then
			ExitLoop
		EndIf
		$sizeByte = $sizeByte / 1024
		$unitSize = $cs
	Next
	Return Round($sizeByte, 1) & ' ' & $unitSize
EndFunc   ;==>REQUIRE_CalcSizeText

Func REQUIRE_handleEventDownloadGUI()
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $REQUIRE_DownloadGUI_ExitBTN
			Exit
	EndSwitch
EndFunc   ;==>REQUIRE_handleEventDownloadGUI

Func writeDownloadedLog()
	Local $handle = FileOpen($REQUIRE_DOWNLOADED_PATH, $FO_OVERWRITE)
	FileWrite($REQUIRE_DOWNLOADED_PATH, $REQUIRE_statusDownload.json(@TAB))
	FileClose($handle)
EndFunc   ;==>writeDownloadedLog
