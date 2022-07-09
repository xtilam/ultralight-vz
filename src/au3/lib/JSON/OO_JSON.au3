#include-once
#include <WinAPI.au3>
#include <Array.au3>

Local $mainThread = _WinAPI_GetCurrentThreadId()
Local $js = -1
Local $applyVariable
Local $preloadScript = 'Object.keys || (Object.keys = function () { "use strict"; var t = Object.prototype.hasOwnProperty, r = !{ toString: null }.propertyIsEnumerable("toString"), e = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "constructor"], o = e.length; return function (n) { if ("object" != typeof n && ("function" != typeof n || null === n)) throw new TypeError("Object.keys called on non-object"); var c, l, p = []; for (c in n) t.call(n, c) && p.push(c); if (r) for (l = 0; l < o; l++)t.call(n, e[l]) && p.push(e[l]); return p } }());' & @CR & '' & @LF & '"object" != typeof JSON && (JSON = {}), function () { "use strict"; function f(t) { return 10 > t ? "0" + t : t } function quote(t) { return escapable.lastIndex = 0, escapable.test(t) ? ' & "'" & '"' & "'" & ' + t.replace(escapable, function (t) { var e = meta[t]; return "string" == typeof e ? e : "\\u" + ("0000" + t.charCodeAt(0).toString(16)).slice(-4) }) + ' & "'" & '"' & "'" & ' : ' & "'" & '"' & "'" & ' + t + ' & "'" & '"' & "'" & ' } function str(t, e) { var n, r, o, f, u, i = gap, p = e[t]; switch (p && "object" == typeof p && "function" == typeof p.toJSON && (p = p.toJSON(t)), "function" == typeof rep && (p = rep.call(e, t, p)), typeof p) { case "string": return quote(p); case "number": return isFinite(p) ? String(p) : "null"; case "boolean": case "null": return String(p); case "object": if (!p) return "null"; if (gap += indent, u = [], "[object Array]" === Object.prototype.toString.apply(p)) { for (f = p.length, n = 0; f > n; n += 1)u[n] = str(n, p) || "null"; return o = 0 === u.length ? "[]" : gap ? "[\n" + gap + u.join(",\n" + gap) + "\n" + i + "]" : "[" + u.join(",") + "]", gap = i, o } if (rep && "object" == typeof rep) for (f = rep.length, n = 0; f > n; n += 1)"string" == typeof rep[n] && (r = rep[n], o = str(r, p), o && u.push(quote(r) + (gap ? ": " : ":") + o)); else for (r in p) Object.prototype.hasOwnProperty.call(p, r) && (o = str(r, p), o && u.push(quote(r) + (gap ? ": " : ":") + o)); return o = 0 === u.length ? "{}" : gap ? "{\n" + gap + u.join(",\n" + gap) + "\n" + i + "}" : "{" + u.join(",") + "}", gap = i, o } } "function" != typeof Date.prototype.toJSON && (Date.prototype.toJSON = function () { return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null }, String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function () { return this.valueOf() }); var cx, escapable, gap, indent, meta, rep; "function" != typeof JSON.stringify && (escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, meta = { "\b": "\\b", "' & @TAB & '": "\\t", "\n": "\\n", "\f": "\\f", "\r": "\\r", ' & "'" & '"' & "'" & ': ' & "'" & '\\"' & "'" & _
    ', "\\": "\\\\" }, JSON.stringify = function (t, e, n) { var r; if (gap = "", indent = "", "number" == typeof n) for (r = 0; n > r; r += 1)indent += " "; else "string" == typeof n && (indent = n); if (rep = e, e && "function" != typeof e && ("object" != typeof e || "number" != typeof e.length)) throw new Error("JSON.stringify"); return str("", { "": t }) }), "function" != typeof JSON.parse && (cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, JSON.parse = function (text, reviver) { function walk(t, e) { var n, r, o = t[e]; if (o && "object" == typeof o) for (n in o) Object.prototype.hasOwnProperty.call(o, n) && (r = walk(o, n), void 0 !== r ? o[n] = r : delete o[n]); return reviver.call(t, e, o) } var j; if (text = String(text), cx.lastIndex = 0, cx.test(text) && (text = text.replace(cx, function (t) { return "\\u" + ("0000" + t.charCodeAt(0).toString(16)).slice(-4) })), /^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) return j = eval("(" + text + ")"), "function" == typeof reviver ? walk({ "": j }, "") : j; throw new SyntaxError("JSON.parse") }) }();' & _
		'Object.prototype.del = function(key){ delete this[key]; return this; };' & _
		'Object.prototype.keys = function(){ return Object.keys(this); };' & _
		'Object.prototype.json = function(v1){ return JSON.stringify(this, 0, v1); };'& _
		'Object.prototype.set = function(k, v){ this[k] = v; return this; };'& _
		'Array.prototype.isArray = function(){ return true };'& _
		'Object.prototype.isArray = function(){ return false };'& _
		'Object.prototype.at = function(k){ return this.hasOwnProperty(k) ? this[k] : null; };' & _
		'var applyVariable = function(script){ try{ return eval("(" + script + ")"); }catch(e){ return {}; } };'

Func _JSVal($obj)
	Local $currentThread = _WinAPI_GetCurrentThreadId()
	
	if($currentThread = $mainThread) Then
		if($js = -1) Then
			$js = ObjCreate("HTMLFile")
			$js.parentwindow.execScript($preloadScript)
			$applyVariable = $js.parentwindow.applyVariable
		EndIf
		Return $applyVariable($obj)
	Else
		Local $apply

		if(Not IsDeclared('js'&$currentThread)) Then
			Local $jsLocal = ObjCreate("HTMLFile") 
			$jsLocal.parentwindow.execScript($preloadScript)
			$apply = $jsLocal.parentwindow.applyVariable
			Assign('js'&$currentThread, $jsLocal, 2)
			Assign('jsApply'&$currentThread, $apply, 2)
		Else
			$apply = Eval('jsApply'& $currentThread)
		EndIf
		
		Return $apply($obj)
	EndIf
EndFunc   ;==>_JSObject

Func _JS_onThreadDeath()
	Local $currentThread = _WinAPI_GetCurrentThreadId()
	Assign('jsApply'&$currentThread, Null, 2)
	Assign('js'&$currentThread, Null, 2)
EndFunc