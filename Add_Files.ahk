Add_Files(){
	global x
	main:=x.Current(2).file
	SplitPath,main,,dir
	FileSelectFile,file,M,%dir%,Select A File to Add To This Repo Upload,*.ahk;*.xml
	if(ErrorLevel)
		return
	list:=[]
	for a,b in StrSplit(file,"`n"){
		if(A_Index=1)
			Dir:=b
		else
			list.Push(Dir "\" b)
	}DropFiles(list)
}