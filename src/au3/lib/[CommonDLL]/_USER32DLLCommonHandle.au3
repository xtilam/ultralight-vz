#include-once
; ===============================================================================================================================
; <_USER32DLLCommonHandle.au3>
;
; Just a common DLL handle shared among different modules
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===================================================================================================================
;	--------------------	GLOBAL COMMON DLL HANDLE	--------------------
; ===================================================================================================================

Global $_COMMON_USER32DLL=DllOpen("user32.dll")		; DLLClose() will be done automatically on exit. [this doesn't reload the DLL]