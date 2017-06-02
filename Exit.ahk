Github_RepositoryClose:
Github_RepositoryEscape:
node:=Node()
all:=vversion.SN("//*[@tv]")
all:=vversion.SN("//files")
while(aa:=all.item[A_Index-1])
	if(!SSN(aa,"file"))
		aa.ParentNode.RemoveChild(aa)
Default("SysTreeView321"),SSN(node,"descendant::*[@tv='" TV_GetSelection() "']").SetAttribute("select",1),vversion.Save(1)
Default("SysTreeView322"),TV_GetText(branch,TV_GetSelection()),node.SetAttribute("branch",branch)
while(aa:=all.item[A_Index-1])
	aa.RemoveAttribute("tv")
dxml.Save(1),NewWin.Exit()
return