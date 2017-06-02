tv(Manual:=""){
	if(A_GuiEvent="S"||Manual="1"){
		Default("SysTreeView321"),cn:=vversion.SSN("//*[@tv='" TV_GetSelection() "']")
		GuiControl,%win%:,Edit1,% cn.NodeName="branch"?"":Text(cn.text)
		GuiControl,% win ":" (cn.NodeName="branch"?"Disabled":"Enabled"),Edit1
		if((all:=SN(SSN(cn,"ancestor-or-self::branch"),"descendant::files/file|//info/files/file")).length){
			Default("SysListView322"),LV_Delete()
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				Default("SysListView322"),LV_Add("",ea.folder,ea.filepath)
		}else
			Default("SysListView322"),LV_Delete()
		ea:=XML.EA(cn)
		if(ea.draft="true")
			GuiControl,%win%:,&Draft,1
		else if(ea.prerelease="true"||ea.prerelease=""&&ea.draft="")
			GuiControl,%win%:,&Pre-Release,1
		else{
			GuiControl,%win%:,&Full Release,1
		}
		LV_ModifyCol(2,"","Files Repo: " SSN(cn,"ancestor-or-self::branch/@name").text)
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		LV_Modify(1,"Select Vis Focus")
		GuiControl,%win%:,Commit As &One File,% SSN(cn,"ancestor-or-self::branch/@onefile")?1:0
	}else if(A_GuiEvent="+"||A_GuiEvent="-"){
		cn:=vversion.SSN("//*[@tv='" TV_GetSelection() "']"),(A_GuiEvent="+"?cn.SetAttribute("expand",1):cn.RemoveAttribute("expand"))
	}
}