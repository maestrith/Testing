OneFile(){
	info:=NewWin[],Default("SysTreeView321"),node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::branch"),(info.onefile?node.SetAttribute("onefile",1):node.RemoveAttribute("onefile")),SSN(dxml.Find("//branch/@name",git.Branch()),"file").RemoveAttribute("time")
	ControlFocus,SysTreeView321,% NewWin.ID
}