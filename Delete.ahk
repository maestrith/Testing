Delete(){
	static
	ControlGetFocus,Focus,% newwin.id
	if(Focus="SysTreeView321"){
		Default(),cn:=vversion.SSN("//*[@tv='" TV_GetSelection() "']")
		if(cn.NodeName="branch"){
			return m("Currently I am unable to remove Branches from a Github Repository")
		}else if(cn.NodeName="version"){
			if(SN(cn.ParentNode,"version").length=1)
				return m("You can not remove the last version.  Please right click this version to rename it")
			select:=cn.nextsibling?cn.nextsibling:cn.previoussibling?cn.previoussibling:""
			if(select)
				select.SetAttribute("select",1)
			cn.ParentNode.RemoveChild(cn),PopVer()
		}
	}if(focus="SysListView322"){
		Default("SysListView322"),LV_GetText(file,LV_GetNext(),2)
		while(node:=vversion.Find("//file/@filepath",file,1),ea:=XML.EA(node)){
			if(!ea.sha){
				node.ParentNode.RemoveChild(node)
				Continue
			}
			SplitPath,file,filename
			(path:=(ea.folder?ea.folder "/" filename:filename))
			/*
				GET /repos/:owner/:repo/contents/:path
				Name		Type		Description
				path		string	Required. The content path.
				message	string	Required. The commit message.
				sha		string	Required. The blob SHA of the file being replaced.
				branch	string	The branch name. Default: the repository’s default branch (usually master)
			*/
			Branch:=(Branch:=SSN(node,"ancestor-or-self::branch/@name").text)?Branch:"master"
			git.Send("DELETE",git.RepoURL("contents/" (ea.folder?ea.folder "/":"") ea.file),{path:(ea.folder?ea.folder "/":"") ea.file,message:"No longer needed",sha:ea.sha,branch:Branch})
			if(git.http.status!=200)
				return m("Error removing file","Status: " git.http.status,"Response: " git.http.ResponseText)
			else
				node.ParentNode.RemoveChild(node)
		}
		tv(1)
	}
}