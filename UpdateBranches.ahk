UpdateBranches(){
	root:=dxml.SSN("//*"),pos:=1,node:=Node()
	info:=git.Send("GET",git.RepoURL("git/refs/heads")),List:=[]
	while(RegExMatch(info,"OUi)\x22ref\x22:\x22(.*)\x22",Found,pos),pos:=Found.Pos(1)+Found.len(1)){
		List[(item:=StrSplit(Found.1,"/").Pop())]:=1
		if(!dxml.Find("//branch/@name",item))
			dxml.Under(root,"branch",{name:item})
		if(!new:=vversion.Find(node,"branch/@name",item))
			new:=vversion.Under(node,"branch",{name:item,onefile:1})
		if(item="master"&&SSN((before:=SSN(node,"branch")),"@name").text!="master")
			node.InsertBefore(new,before)
	}blist:=dxml.SN("//branch")
	while(bl:=blist.item[A_Index-1],ea:=XML.EA(bl))
		if(!List[ea.name])
			bl.ParentNode.RemoveChild(bl)
	all:=SN(node,"branch")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(!List[ea.name])
			aa.ParentNode.RemoveChild(aa)
	pos:=1,info:=git.Send("GET",git.RepoURL("releases"))
	while(pos:=RegExMatch(info,"{\x22url\x22:",,pos)){
		commit:=[]
		for a,b in {id:",",target_commitish:",",name:",",draft:",",prerelease:",",body:"\}"}
			RegExMatch(info,"OUi)\x22" a "\x22:(.*)" b,Found,pos),commit[a]:=Trim(Found.1,Chr(34))
		if(!top:=vversion.Find(node,"branch/@name",commit.target_commitish))
			top:=vversion.Under(node,"branch",{name:commit.target_commitish})
		if(!version:=vversion.Find(top,"version/@name",commit.name))
			version:=dxml.Under(top,"version",{name:commit.name})
		for a,b in commit{
			if(a!="body")
				version.SetAttribute(a,b)
			else
				version.text:=RegExReplace(b,"\R|\\n|\\r",Chr(127))
		}
		pos:=found.Pos(1)+found.Len(1)
	}for a in list{
		if(!SSN((top:=vversion.Find(node,"branch/@name",a)),"version"))
			vversion.Under(top,"version",{name:1})
	}PopVer()
}