UpdateReleases(releases){
	pos:=1,node:=Node()
	while(RegExMatch(releases,"OU)\x22id\x22:(\d+)\D.*\x22name\x22:\x22(.*)\x22.*\x22body\x22:\x22(.*)\x22\}",found,pos)),pos:=found.Pos(1)+20{
		if(!SSN(node,"branch/version[@name='" found.2 "']")){
			new:=vversion.Under(SSN(node,"descendant::branch"),"version",,RegExReplace(found.3,"\\n",Chr(127)))
			for a,b in {number:found.2,id:found.1}
				new.SetAttribute(a,b)
		}
	}
}