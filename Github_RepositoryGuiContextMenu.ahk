Github_RepositoryGuiContextMenu(a*){
	GuiControlGet,hwnd,%win%:hwnd,SysTreeView321
	if(a.1=hwnd){
		node:=vversion.SSN("//*[@tv='" a.2 "']")
		if(node.NodeName="branch")
			return Default("SysTreeView321"),TV_Modify(a.2,"Expand"),m("Please select a version number to edit")
		InputBox,version,New Version,Input a new version number,,,130,,,,,% SSN(node,"@name").text
		if(ErrorLevel||version="")
			return
		if(SSN(node.ParentNode,"descendant::version[@name='" version "']"))
			return m("Version number exists.")
		Default("SysTreeView321"),TV_Modify(a.2,"",version),node.SetAttribute("name",version)
		if(release:=SSN(node,"@id").text){
			ea:=XML.EA(node),Branch:=SSN(node,"ancestor-or-self::branch/@name").text,json:=git.json(obj:={tag_name:ea.name,target_commitish:Branch,name:ea.name,body:git.UTF8(node.text),draft:ea.draft?"true":"false",prerelease:ea.prerelease?"true":"false"})
			id:=git.Find("id",msg:=git.Send("PATCH",git.RepoURL("releases/" release),json))
			if(!id)
				m("Something happened",msg,release)
		}
	}
	GuiControlGet,hwnd,%win%:hwnd,SysListView321
	if(a.1=hwnd){
		m("Settings!")
	}
}