Update(){
	Default("SysTreeView321")
	ea:=vversion.EA(node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']"))
	info:=newwin[] ;,TV_GetText(name,TV_GetSelection())
	if(node.NodeName="Branch")
		return Default("SysTreeView321"),TV_Modify(a.2,"Expand"),m("Please select a version number to Update")
	if(!info.edit)
		return m("Please enter Version Information for this release")
	json:=git.json(obj:={tag_name:ea.name,target_commitish:git.Branch(),name:ea.name,body:git.UTF8(info.edit),draft:info.draft?"true":"false",prerelease:info.prerelease?"true":"false"})
	/*
		;Fetch the release id for a given release
		;GET /repos/:owner/:repo/releases
		;check release list
		url:=git.url "/repos/" git.owner "/" git.repo "/releases" git.token,id:=git.find("id",git.send("GET",url)),SSN(Node(),"descendant::version[@name='" name "']").SetAttribute("id",id),m(Node().xml)
		return
	*/
	if(release:=ea.ID){
		id:=git.Find("id",msg:=git.Send("PATCH",git.RepoURL("releases/" release),json))
		if(!id)
			m("Something happened",msg,release)
		node.SetAttribute("draft",obj.draft),node.SetAttribute("prerelease",obj.prerelease)
	}else{
		id:=git.Find("id",info:=git.Send("POST",git.RepoURL("releases"),json))
		if(!id)
			return m("Something happened",info)
		SSN(Node(),"descendant::version[@name='" ea.name "']").SetAttribute("id",id)
	}
	vversion.Save(1)
}