DropFiles(a,b:="",c:="",d:=""){
	global x
	Default("SysTreeView321"),node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']"),ProjectFile:=x.Current(2).file
	SplitPath,ProjectFile,,Dir
	/*
		ret:=m("Add " (a.MaxIndex()=1?"this":"these") " " a.MaxIndex() " file" (a.MaxIndex()=1?"":"s") " to the overall project?","Yes=All Branches","No=Only the " SSN(node,"ancestor-or-self::branch/@name").text " Branch","btn:ync")
	*/
	under:=vversion.SSN("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::branch")
	if(!top:=SSN(under,"files"))
		top:=vversion.Under(under,"files")
	for c,d in a{
		SplitPath,d,filename,AddDir
		/*
			m(AddDir,Dir)
			Continue
		*/
		VarSetCapacity(NewDir,32)
		foo:=DllCall("Shlwapi\PathRelativePathTo",ptr,&NewDir,str,ProjectFile,int,0,str,d,int,0)
		/*
			if .\then path
				it is fine to just use that path
			if ..\then path
				put it all in lib
			  ;#[Drop Path]
		*/
		/*
			Loop,Files,%Dir%\%filename%,R
				m(A_LoopFileFullPath)
		*/
		/*
			if(InStr(AddDir,Dir))
				folder:=RegExReplace(AddDir,"\Q" Dir "\E")
			else
				folder:="lib"
		*/
		nd:=StrGet(&NewDir)
		if(SubStr(nd,1,2)=".\"){
			folder:=SubStr(nd,3)
			SplitPath,folder,,folder
		}else
			folder:="lib"
		if(!vversion.Find(top,"descendant::file/@filepath",d)&&!vversion.Find(top,"ancestor::info/files/file/@filepath",d))
			folder:=RegExReplace(Trim(folder,"\"),"\\","/"),vversion.Under(top,"file",{file:filename,filepath:d,folder:folder})
	}
	tv(1)
}