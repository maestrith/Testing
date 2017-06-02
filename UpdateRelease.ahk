UpdateRelease(){
	Default("SysTreeView321"),node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']")
	if(node.NodeName!="version")
		return
	info:=A_GuiControl="fullrelease"?{prerelease:"false",draft:"false"}:A_GuiControl="prerelease"?{prerelease:"true",draft:"false"}:{prerelease:"false",draft:"true"}
	for a,b in info
		node.SetAttribute(a,b)
	ControlFocus,SysTreeView321,% NewWin.ID
}