#SingleInstance,Force
;menu Github Repository
/*
	have a "download then update" the xml for the plugin list
	pull the whole repo list of shas but only use the one that matches the name of the project
*/
#NoTrayIcon
#NoEnv
x:=Studio(),x.Save() ;dxml:=new XML()
global settings,git,vversion,NewWin,v,win,ControlList:={owner:"Owner (GitHub Username)",email:"Email",name:"Your Full Name",token:"API Token"},new,files,dxml
win:="Github_Repository",settings:=x.Get("settings"),NewWin:=new GUIKeep(win),files:=x.Get("files"),v:=x.Get("v"),vversion:=new XML("github",x.Path() "\lib\Github.xml")
Hotkey,IfWinActive,% NewWin.id
for a,b in {"^Down":"Arrows","^Up":"Arrows","~Delete":"Delete","F1":"CompileVer","F2":"ClearVer","F3":"WholeList","^!u":"UpdateBranches"}
	Hotkey,%a%,%b%,On
NewWin.Add("Text,Section,Branches:","Text,x+140,Version &Information:"
		,"TreeView,xm w200 h200 gtv AltSubmit section,,h","Edit,x+M w400 h200 gedit vedit,,wh"
		,"Radio,xm h23 vfullrelease gUpdateRelease,&Full Release,y","Radio,x+M h23 vprerelease Checked gUpdateRelease,&Pre-Release,y","Radio,x+M h23 vdraft gUpdateRelease,&Draft,y","Checkbox,x+M h23 vonefile gonefile " (check:=SSN(Node(),"@onefile").text?"Checked":"") " ,Commit As &One File,y"
		,"ListView,xm w450 h200 geditgr AltSubmit NoSortHdr,Github Setting|Value,y","ListView,x+m w150 h200,Additional Files (Folder)|Directory,yw"
		,"Button,xm gUpdate,&Update Release Info,y"
		,"Button,x+M gcommit,Co&mmit,y"
		,"Button,x+M gDelRep,Delete Repository,y"
		,"Button,xm gAdd_Files Default,&Add Files,y"
		,"Button,x+M ghelp,&Help,y"
		,"Button,x+M gRefreshBranch,&Refresh Branch,y"
		,"Button,xm gNewBranch,New &Branch,y"
		,"Button,x+M greleases,Update Releases,y"
		,"Button,x+M gUpdateReadme,Update Readm&e.md,y"
		,"StatusBar")
git:=new Github(),node:=git.Node(),SB_SetText("Remaining API Calls: Will update when you make a call to the API"),PopVer()
NewWin.Show("Github Repository")
Gui,%win%:+MinSize800x600
node:=dxml.Find("//branch/@name",git.Branch())
if(SN(node,"*[@sha]").length!=SN(node,"*").length)
	git.TreeSha()
git.GetRef()
/*
	UpdateBranches()
	FIX!{
		everything Node needs to be re-evaluated.
		test all the things.
		Delete() needs fixed so that you can't delete the last version
		if the branch is selected and delete
			DON'T DELETE THE BRANCH!
	}
*/
/*
	DELETE /repos/:USER/:REPO/git/refs/heads/:BRANCH
	response: 204 on success
*/
return
/*
	GuiContextMenu(a*){ ;}GuiHwnd,Control,EventInfo,IsRightClick,x,y){
		return m(Control)
		Default("SysTreeView321"),cn:=SSN(Node(),"descendant::version[@tv='" TV_GetSelection() "']")
		InputBox,nv,Enter a new version number,New Version Number,,,,,,,,% SSN(cn,"@name").text
		if(ErrorLevel||nv="")
			return
		cn.SetAttribute("number",nv),PopVer()
	}
*/
#Include Add_Files.ahk
#Include Arrows.ahk
#Include Class Github.ahk
#Include ClearVer.ahk
#Include Commit.ahk
#Include CompileVer.ahk
#Include Decode.ahk
#Include Default.ahk
#Include Delete.ahk
#Include DeleteExtraFiles.ahk
#Include DelRep.ahk
#Include DropFiles.ahk
#Include Edit.ahk
#Include Encode.ahk
#Include EncodeFile.ahk
#Include Exit.ahk
#Include Github_RepositoryGuiContextMenu.ahk
#Include Help.ahk
#Include NewBranch.ahk
#Include Node.ahk
#Include OneBranch.ahk
#Include OneFile.ahk
#Include PopVer.ahk
#Include RefreshBranch.ahk
#Include Releases.ahk
#Include Text.ahk
#Include tv.ahk
#Include Update.ahk
#Include UpdateBranches.ahk
#Include UpdateReadme.ahk
#Include UpdateRelease.ahk
#Include UpdateReleases.ahk
#Include verhelp.ahk
#Include WholeList.ahk