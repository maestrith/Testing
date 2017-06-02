CompileVer(){
	Default("SysTreeView321"),TV_GetText(ver,TV_GetSelection())
	WinGetPos,,,w,,% newwin.ahkid
	info:=newwin[],text:=info.edit
	vertext:=ver&&text?ver "`r`n" text:""
	if(vertext){
		Clipboard.=vertext "`r`n"
		ToolTip,%Clipboard%,%w%,0,2
	}else
		m("Add some text")
	return
}