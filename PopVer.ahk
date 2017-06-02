PopVer(){
	static InfoList:=[]
	for a,b in ["SysTreeView321","SysListView321","SysListView322"]
		GuiControl,%win%:-Redraw,%b%
	Default("SysListView321"),LV_Delete(),ea:=settings.EA("//github")
	all:=SN((MainNode:=Node()),"descendant::branch|descendant::version"),TV_Delete()
	for a,b in ControlList
		InfoList[LV_Add("",b,a="token"?(ea[a]?"Entered":"Needed"):ea[a])]:=a
	for a,b in [["repo","Repository Name"],["website","Website URL: (Optional)"],["description","Repository Description: (Optional)"]]
		InfoList[LV_Add("",b.2,SSN(MainNode,"@" b.1).text)]:=b.1
	Default("SysTreeView321"),Expand:=[]
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		aa.SetAttribute("tv",tv:=TV_Add(ea.name?ea.name:ea.number,SSN(aa.ParentNode,"@tv").text))
		if(ea.Expand)
			Expand[tv]:=1
	}if(tv:=SSN(MainNode,"descendant::*[@select=1]/@tv").text){
		TV_Modify(tv,"Select Vis Focus")
		GuiControl,%win%:+Redraw,SysTreeView321
		TV_Modify(tv,"Select Vis Focus")
	}else
		TV_Modify(TV_GetChild(0),"Select Vis Focus")
	while(rem:=SSN(MainNode,"descendant::*[@select=1]"))
		rem.RemoveAttribute("select")
	Default("SysListView321")
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	LV_ModifyCol(1,"AutoHDR")
	for tv in Expand
		TV_Modify(tv,"Expand")
	for a,b in ["SysTreeView321","SysListView321","SysListView322"]{
		GuiControl,%win%:+Redraw,%b%
	}
	Default("SysListView321"),LV_Modify(1,"Select Vis Focus")
	return
	EditGR:
	if(A_GuiEvent~="i)(Normal)"){
		Default("SysListView321")
		Value:=InfoList[LV_GetNext()],LV_GetText(Input,LV_GetNext())
		if(Value~="i)(email|name|owner|token)"){
			if(!Settings.SSN("//github/@" Value))
				Settings.Add("github").SetAttribute(Value,"")
			CurrentValue:=(CurrentNode:=Settings.SSN("//github/@" Value)).text
		}else if(Value~="i)\b(repo|description|website)\b"){
			if(!SSN(Node(),"@" Value))
				Node().SetAttribute(Value,"")
			CurrentValue:=(CurrentNode:=SSN(Node(),"@" Value)).text
		}
		InputBox,Output,Enter Value,% "Please enter a value for " Input (Value="repo"?"`n`nWARNING!: All Un-Committed Version Information Will Be Lost!`n`nAll spaces will be replaced with '-'":""),% (Value="token"?"Hide":""),,% (Value="repo"?220:150),,,,,%CurrentValue%
		if(ErrorLevel||Output="")
			return
		if(Value="repo"){
			Output:=RegExReplace(Output,"\s","-"),Node().SetAttribute("repo",Output),git.repo:=Output,git.Refresh()
			git.Send("GET",git.RepoURL())
			if(git.http.status!=200){
				data:=git.CreateRepo(git.repo,git.description,git.website)
				for a,b in {id:"\x22id\x22:(\d+)",created_at:"",updated_at:"",pushed_at:""}
					RegExMatch(data,(b?b:"U)\x22" a "\x22:\x22(.*)\x22"),Found),TopNode:=dxml.Add("Repository/Data").SetAttribute(a,Found1)
			}else{
				releases:=git.Send("GET",git.RepoURL("releases"))
				if(git.http.status=200)
					UpdateReleases(releases)
			}UpdateBranches(),PopVer()
		}else if(Value="website"){
			CurrentNode.text:=Output
			if(git.repo)
				git.Send("PATCH",git.RepoURL(),git.json({name:git.repo,homepage:Output}))
		}else if(Value="description"){
			CurrentNode.text:=Output
			if(git.repo)
				git.Send("PATCH",git.RepoURL(),git.json({name:git.repo,description:Output}))
		}else
			CurrentNode.text:=Output
		git.Refresh(),PopVer()
	}
	return
}