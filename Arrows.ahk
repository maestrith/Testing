Arrows(){
	Default("SysTreeView321"),node:=vversion.SSN("//*[@tv='" TV_GetSelection() "']")
	ver:=StrSplit(SSN(node,"@name").text,"."),version:=""
	last:=ver[ver.MaxIndex()]
	for a,b in ver
		if(a!=ver.MaxIndex())
			build.=b "."
	if(A_ThisHotkey="^Up"){
		if(next:=node.previoussibling)
			return TV_Modify(next.SelectSingleNode("@tv").text,"Select Vis Focus")
		build.=Format("{:0" StrLen(last) "}",last+1),new:=vversion.Under(node.ParentNode,"version"),new.SetAttribute("name",build),new.SetAttribute("select",1),node.ParentNode.InsertBefore(new,node),PopVer()
	}else{
		if(next:=node.nextsibling)
			return TV_Modify(next.SelectSingleNode("@tv").text,"Select Vis Focus")
		if(last-1<0)
			return m("Minor versions can not go below 0","Right Click to change the major version")
		build.=Format("{:0" StrLen(last) "}",last-1),new:=vversion.Under(node.ParentNode,"version"),new.SetAttribute("name",build),new.SetAttribute("select",1),PopVer()
}}