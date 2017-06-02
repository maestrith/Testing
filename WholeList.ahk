WholeList(Return:=0){
	Default("SysTreeView321"),list:=SN(vversion.SSN("//*[@tv='" TV_GetSelection() "']"),"ancestor-or-self::branch/version")
	while,ll:=list.item[A_Index-1]
		Info.=SSN(ll,"@name").text "`r`n" Trim(ll.text,"`r`n") "`r`n"
	if(Return)
		return Info
	else
		m("Version list copied to your clipboard.","","",Clipboard:=Info)
	return
}