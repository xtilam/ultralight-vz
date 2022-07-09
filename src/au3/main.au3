#include "lib/ultralight.au3"
#include "auto_include/auto_include.au3"
#include "lib/require.au3"

Global Const $APP_WIDTH = 600
Global Const $APP_HEIGHT = 600
Global Const $INSPECTOR_WIDTH = 600

main()

Func main()
	downloadLibrary() 

	Ultralight_ConfigWindowFlag(BitOR($kWindowFlags_Borderless,$kWindowFlags_Resizable))

	if($isProduction) Then
		Ultralight_ConfigWindowSize($APP_WIDTH, $APP_HEIGHT)
		Ultralight_InitApp()
		Ultralight_LoadURL('file:///index.html')
	Else
		Ultralight_ConfigWindowSize($APP_WIDTH + $INSPECTOR_WIDTH, $APP_HEIGHT)
		Ultralight_InitApp()
		Ultralight_ResizeInspector($INSPECTOR_WIDTH + 200, 1) 
		Ultralight_SetEnableInspector(True)
		Ultralight_LoadURL('http://localhost:8000/ic.html')
	EndIf

	Ultralight_RunApp()
EndFunc

Func downloadLibrary()
	REQUIRE_Zip('https://raw.githubusercontent.com/xtilam/ultralight-lib-au3/master/au3-lib.zip', '', 'Ultralight Depenpencies')
	REQUIRE_StartDownload()
EndFunc