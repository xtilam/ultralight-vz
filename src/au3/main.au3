#include "lib/ultralight.au3"
#include "lib/require.au3"

Global Const $APP_WIDTH = 600
Global Const $APP_HEIGHT = 600

main()

Func main()
	downloadLibrary()  
 
	Ultralight_ConfigWindowFlag(BitOR($kWindowFlags_Borderless,$kWindowFlags_Resizable))
	Ultralight_ConfigWindowFlag(BitOR($kWindowFlags_Borderless,0))
	Ultralight_ConfigWindowSize($APP_WIDTH, $APP_HEIGHT)
	Ultralight_InitApp()
	
	if(Ultralight_IsDevMode()) Then 
		Ultralight_LoadURL('http://localhost:3000')
	Else
		Ultralight_LoadURL('http://localhost:3000')
	EndIf 

	Ultralight_RunApp()
EndFunc

Func downloadLibrary()
	REQUIRE_Zip('https://raw.githubusercontent.com/xtilam/ultralight-lib-au3/master/au3-lib.zip', '', 'Ultralight Depenpencies')
	REQUIRE_StartDownload()
EndFunc

Func findProcess($name)
	Const $processList = ProcessList($name)
	Local $result[] = [1,2,3]
	return $result
EndFunc

Func exitApp()
	ProcessClose(@AutoItPID)
EndFunc