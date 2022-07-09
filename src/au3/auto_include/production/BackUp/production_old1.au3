#include-once
#include <Array.au3>
#include <Crypt.au3>
#include <File.au3>
#include "auto_resource.au3"

Global $g_iAlgorithm = $CALG_MD5
Global Const $ASSETS_PATH = @ScriptDir & '/assets'
Global Const $isProduction = True
Global $maxIndexMd5Arr = UBound($md5Arr) - 1
Global Const $ASSETS_MD5_EXTENSION_REGEX= '(\.js$|\.css$|\.html$|\.json$)'

checkMD5Resource($md5Arr)

Func checkMD5Resource(Byref $md5Arr)
    if(FileExists($ASSETS_PATH) = 0) Then Exit
	md5CheckRecursive($md5Arr, $ASSETS_PATH)
    if(UBound($md5Arr)<>0) Then Exit
EndFunc

Func md5CheckRecursive(Byref $md5Arr, $path)
    if($maxIndexMd5Arr < 0) Then Return
    if(FileGetAttrib($path) = 'D') Then 
        Local $listFile = _FileListToArray($path)
        For $i = 1 To $listFile[0] Step +1
            md5CheckRecursive($md5Arr, $path & '\' & $listFile[$i])
        Next
    Else
        if(StringRegExp($path, $ASSETS_MD5_EXTENSION_REGEX, 0) = 0) Then Return
        
        Local $md5File = String(_Crypt_HashFile($path, $g_iAlgorithm))
        For $i = 0 To $maxIndexMd5Arr Step +1
            if($md5Arr[$i] = $md5File) Then
                _ArrayDelete($md5Arr, $i)
                $maxIndexMd5Arr -= 1
                ExitLoop
            EndIf
        Next
    EndIf 
EndFunc