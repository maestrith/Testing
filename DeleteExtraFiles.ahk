DeleteExtraFiles(DeleteList){
	static
	DL:=DeleteList
	Gui,Delete:Destroy
	Gui,Delete:Default
	Gui,Add,Text,,Some of these items are still on Github and do not appear to be in your Project
	Gui,Add,ListView,w800 h500 Checked,Delete Files
	Gui,Add,Button,gDeleteChecked,Delete Checked
	for a,b in DeleteList
		LV_Add("",b.ea.file)
	Gui,Show
	return
	DeleteChecked:
	for a,b in DL
		total.=a " - " b.ea.sha "`n"
	m("Coming Soon:",total),total:=""
	return
	DeleteGuiEscape:
	DeleteGuiClose:
	KeyWait,Escape,U
	Gui,Delete:Destroy
	return
	/*
			;make a GUI that has the files in DeleteList and ask if the user wants to remove them from Github
		for a,b in DeleteList{
			ea:=b.ea
			branch:=(name:=SSN(b.node,"ancestor-or-self::branch/@name").text)?name:"master"
			git.Send("DELETE",git.RepoURL("contents/" (ea.folder?ea.folder "/":"") ea.file),{path:(ea.folder?ea.folder "/":"") ea.file,message:"No longer needed",sha:ea.sha,branch:Branch})
			if(git.http.status!=200)
				m(git.http.status,b.node.xml,git.http.ResponseText)
			else
				b.node.ParentNode.RemoveChild(b.node)
		}
	*/
	
}