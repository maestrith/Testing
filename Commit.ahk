Commit(){
	global settings,x
	if(!git.repo)
		return m("Please setup a repo name in the GUI by clicking Repository Name:")
	if(!vversion.EA("//*[@tv='" TV_GetSelection() "']").name)
		return m("Please select a version")
	info:=newwin[],CommitMsg:=info.Edit,Current:=main:=file:=x.Current(2).file,ea:=settings.EA("//github"),Delete:=[],Path:=x.Path() "\Github\" git.repo,Default("SysTreeView321"),TV_GetText(Version,TV_GetSelection())
	if(!CommitMsg)
		return m("Please select a commit message from the list of versions, or enter a commit message in the space provided")
	if(!(ea.name&&ea.email&&ea.token&&ea.owner))
		return m("Please make sure that you have set your Github information")
	if(!vversion.Find("//@file",file))
		vversion.Add("info",,,1).SetAttribute("file",file)
	if(!FileExist(x.Path() "\github"))
		FileCreateDir,% x.Path() "\Github"
	temp:=new XML("temp"),temp.XML.LoadXML(files.Find("//main/@file",Current).xml),Default("SysTreeView321"),list:=SN(Node(),"files/*"),mainfile:=Current,Branch:=git.Branch(),Uploads:=[]
	if(!Branch)
		return m("Please select the branch you wish to update.")
	if(!top:=dxml.Find("//branch/@name",Branch))
		top:=dxml.Under(dxml.SSN("//*"),"branch",{name:Branch})
	DeleteList:=[]
	Default("SysTreeView321"),node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::branch"),AllFiles:=SN(node,"descendant::files/file|ancestor::info/files/file")
	while(aa:=AllFiles.item[A_Index-1],ea:=XML.EA(aa))
		if(ea.sha)
			DeleteList[ea.filepath]:={node:aa,ea:ea}
	all:=SN(top,"descendant::file")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(ea.sha)
			DeleteList[ea.filepath]:={node:aa,ea:ea}
	SplitPath,Current,FileName,,,NNE
	if(!FileExist(Path))
		FileCreateDir,%Path%
	if(info.OneFile){
		OOF:=FileOpen(Path "\" FileName,"RW",ea.encoding),text:=OOF.Read(OOF.Length)
		PublishText:=x.Publish(1)
		if(!(PublishText==text))
			Uploads[FileName]:={text:PublishText,time:time,local:Path "\" Filename}
	}else{
		all:=temp.SN("//file")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			fn:=ea.file,GitHubFile:=ea.github?ea.github:ea.filename
			SplitPath,fn,FileName
			if(!ii:=dxml.Find(top,"descendant::file/@file",GithubFile))
				ii:=dxml.Under(top,"file",{file:GithubFile})
			FileGetTime,time,%fn%
			DeleteList.Delete(GithubFile)
			if(SSN(ii,"@time").text!=time)
				file:=FileOpen(fn,"RW",ea.encoding),file.Seek(0),text:=file.Read(file.Length),file.Close(),Uploads[RegExReplace(GithubFile,"\\","/")]:={text:text,time:time,node:ii,local:ea.file}
	}}
	for a,b in DeleteList
		llist.=a "`n"
	while(aa:=AllFiles.item[A_Index-1],ea:=XML.EA(aa)){
		fn:=ea.filepath
		FileGetTime,time,%fn%
		DeleteList.Delete(ea.filepath)
		;#[Working Here]
		if(ea.time!=time||!ea.sha){
			branch:=(name:=SSN(aa,"ancestor-or-self::branch/@name").text)?name:"master"
			SplitPath,fn,filename
			Uploads[(ea.folder?ea.folder "/":"") ea.file]:=EncodeFile(fn,time,aa,branch)
	}}
	for a,b in Uploads
		DeleteList.Delete(a),Finish:=1
	VersionText:=WholeList(1),VTObject:=FileOpen(Path "\" NNE ".text","RW"),CheckVersionText:=VTObject.Read(VTObject.Length)
	if(VersionText==CheckVersionText=0)
		Uploads[NNE ".text"]:={text:VersionText},VTObject.Seek(0),VTObject.Write(VersionText),VTObject.Length(VTObject.Position)
	VTObject.Close()
	if(!finish){
		if(IsObject(OOF))
			OOF.Close()
		return m("Nothing to upload")
	}
	if(!current_commit:=git.GetRef())
		git.CreateRepo(git.repo),current_commit:=git.GetRef()
	Store:=[],Upload:=[]
	for a,b in Uploads{
		WinSetTitle,% newwin.id,,Uploading: %a%
		NewText:=b.text?b.text:";Blank File"
		if((blob:=Store[a])=""||b.force){
			Store[a]:=blob:=git.Blob(git.repo,RegExReplace(NewText,Chr(59) "github_version",version),b.skip)
			if(!blob)
				return m("Error occured while uploading " text.local)
			Sleep,250
		}
		Upload[a]:=blob
	}
	tree:=git.Tree(git.repo,current_commit,upload),commit:=git.Commit(git.repo,tree,current_commit,CommitMsg,git.name,git.email),info:=git.Ref(git.repo,commit)
	if(info=200){
		top:=dxml.Find("//branch/@name",Branch)
		for a,b in Uploads{
			if(b.node)
				b.node.SetAttribute("time",b.time),b.node.SetAttribute("sha",Upload[a])
		}if(IsObject(OOF))
			OOF.Seek(0),OOF.Write(PublishText),OOF.Length(OOF.Position),OOF.Close()
		DeleteExtraFiles(DeleteList)
		dxml.Save(1),x.TrayTip("GitHub Update Complete"),Update()
	}Else
		m("An Error Occured" ,commit)
	WinSetTitle,% NewWin.ID,,Github Repository
	return
}