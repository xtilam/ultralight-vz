#include "../lib/_HttpRequest.au3"

Local $sJson = '{"user_info": 12}'

 

Local $oJson = _HttpRequest_ParseJSON($sJson)

MsgBox(0, 0, $oJson.user_info)
$oJson.user_info = MsgBox
MsgBox(0, 0, VarGetType($oJson.user_info))
$oJson.user_info(0, 0, 1)
