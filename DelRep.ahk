DelRep(){
	global vversion
	if(m("title:Delete This Repository","THIS CAN NOT BE UNDONE! ARE YOU SURE?","ico:!","btn:ync","def:2")="YES"){
		if(git.repo="AHK-Studio")
			return m("NO! you can not.")
		info:=git.Send("DELETE",git.RepoURL())
		if(InStr(git.http.status,204)){
			rem:=vversion.SSN("//info[@file='" SSN(Node(),"@file").text "']"),rem.ParentNode.RemoveChild(rem),git.repo:=""
			FileRemoveDir,% A_ScriptDir "\github\" ea.repo,1
		}else
			m("Something went wrong","Please make sure that you have a repository named " ea.repo " on the Gethub servers")
		PopVer()
}}