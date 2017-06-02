Node(){
	global x
	if(!node:=vversion.Find("//info/@file",x.Current(2).file))
		node:=vversion.Under(vversion.SSN("//*"),"info"),node.SetAttribute("file",x.Current(2).file)
	return node
}