UpdateReadme(){
	static
	Default("SysTreeView321"),Branch:=git.Branch()
	if(!Branch)
		return m("Please Select The Branch To Update")
	info:=git.Send("GET",git.RepoURL("contents/README.md","&ref=" Branch),{ref:Branch,path:"README.md"}),sha:=git.Sha(info),Contents:=git.Find("content",info)
	Gui,EditReadme:Destroy
	Gui,EditReadme:Default
	Gui,Add,Edit,w800 h600 vReadMeEdit,% RegExReplace(Decode(Contents),"i)<br>","`r`n")
	Gui,Add,Button,gReadMeUpdate,&Update
	Gui,Show,,Edit Readme.md
	return
	ReadMeUpdate:
	Gui,EditReadme:Submit,Nohide
	msg:=git.Send("PUT",git.RepoURL("contents/README.md"),git.json({path:"README.md",message:"Updating the README.md file",content:Encode(RegExReplace(ReadMeEdit,"\R","<br>")),sha:sha,branch:branch}))
	if(git.http.status=200){
		EditReadmeGuiEscape:
		EditReadmeGuiClose:
		KeyWait,Escape,U
		Gui,EditReadme:Destroy
		return
	}else
		return m(git.http.status,msg)
}