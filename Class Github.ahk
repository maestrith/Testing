Class Github{
	static url:="https://api.github.com",http:=[]
	__New(){
		ea:=Settings.EA("//github")
		if(!(ea.owner&&ea.token))
			return m("Please setup your Github info")
		this.http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if(proxy:=Settings.SSN("//proxy").text)
			http.setProxy(2,proxy)
		for a,b in ea:=ea(Settings.SSN("//github"))
			this[a]:=b
		this.repo:=SSN(Node(),"@repo").text,this.token:="?access_token=" ea.token,this.owner:=ea.owner,this.tok:="&access_token=" ea.token,this.repo:=SSN(Node(),"@repo").text,this.baseurl:=this.url "/repos/" this.owner "/" this.repo "/",this.Refresh()
		return this
	}Branch(){
		Default("SysTreeView321")
		return vversion.SSN("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::branch/@name").text
	}
	Blob(repo,text,skip:=""){
		if(!skip)
			text:=Encode(text)
		json={"content":"%text%","encoding":"base64"}
		return this.Sha(this.Send("POST",this.url "/repos/" this.owner "/" repo "/git/blobs" this.token,json))
	}
	Commit(repo,tree,parent,message:="Updated the file",name:="placeholder",email:="placeholder@gmail.com"){
		message:=this.UTF8(message),parent:=this.cmtsha,url:=this.url "/repos/" this.owner "/" repo "/git/commits" this.token
		json={"message":"%message%","author":{"name": "%name%","email": "%email%"},"parents":["%parent%"],"tree":"%tree%"}
		sha:=this.Sha(info:=this.Send("POST",url,json))
		Clipboard:=url "`n" json "`n`n" tree "`n" parent
		return sha
	}
	CreateFile(repo,filefullpath,text,commit="First Commit",realname="Testing",email="Testing"){
		SplitPath,filefullpath,filename
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.token,file:=this.utf8(text)
		json={"message":"%commit%","committer":{"name":"%realname%","email":"%email%"},"content": "%file%"}
		this.http.Open("PUT",url),this.http.send(json),RegExMatch(this.http.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
	}
	CreateRepo(name,description="",homepage="",private="false",issues="true",wiki="true",downloads="true"){
		url:=this.url "/user/repos" this.token
		for a,b in {homepage:this.UTF8(homepage),description:this.UTF8(description)}
			if(b!=""){
				aa="%a%":"%b%",
				add.=aa
			}
		json={"name":"%name%",%add% "private":%private%,"has_issues":%issues%,"has_wiki":%wiki%,"has_downloads":%downloads%,"auto_init":true}
		return this.Send("POST",url,json)
	}
	Delete(filenames){
		node:=dxml.Find("//branch/@name",this.Branch())
		if(SN(node,"*[@sha]").length!=SN(node,"*").length)
			this.TreeSha()
		for c,d in filenames{
			StringReplace,cc,c,\,/,All
			url:=this.url "/repos/" this.owner "/" this.repo "/contents/" cc this.token,sha:=SSN(node,"descendant::*[@file='" c "']/@sha").text
			if(!sha)
				Continue
			this.http.Open("DELETE",url),this.http.send(this.json({"message":"Deleted","sha":sha,"branch":this.Branch()}))
			d.ParentNode.RemoveChild(d)
			return this.http
	}}
	Find(search,text){
		RegExMatch(text,"UOi)\x22" search "\x22\s*:\s*(.*)[,|\}]",found)
		return Trim(found.1,Chr(34))
	}
	GetTree(value:=""){
		info:=this.Send("GET",this.url "/repos/" this.owner "/" this.repo "/git/trees/" this.GetRef() this.token)
		if(value){
			temp:=new XML("tree"),top:=temp.SSN("//tree"),info:=SubStr(info,InStr(info,Chr(34) "tree" Chr(34))),pos:=1
			while,RegExMatch(info,"OU){(.*)}",found,pos){
				new:=temp.under(top,"node")
				for a,b in StrSplit(found.1,",")
					in:=StrSplit(b,":",Chr(34)),new.SetAttribute(in.1,in.2)
				pos:=found.pos(1)+found.len(1)
			}temp.Transform(2)
		}return temp
	}
	GetRef(){
		this.cmtsha:=this.Sha(info:=this.Send("GET",this.RepoURL("git/refs/heads/" this.branch())))
		RegExMatch(this.Send("GET",this.RepoURL("commits/" this.cmtsha)),"U)tree.:\{.sha.:.(.*)" Chr(34),found)
		return found1
	}
	json(info){
		for a,b in info
			json.=Chr(34) a Chr(34) ":" (b="true"?"true":b="false"?"false":Chr(34) b Chr(34)) ","
		return "{" Trim(json,",") "}"
	}
	Limit(){
		url:=this.url "/rate_limit" this.token,this.http.Open("GET",url),this.http.Send()
		m(this.http.ResponseText)
	}Node(){
		global x
		if(!node:=vversion.SSN("//info[@file='" x.Current(2).file "']"))
			node:=vversion.Under(vversion.SSN("//*"),"info"),node.SetAttribute("file",x.Current(2).file)
		if(git.repo){
			if(!SSN(node,"descendant::branch[@name='master']"))
				UpdateBranches()
		}
		return node
	}
	Ref(repo,sha){
		url:=this.url "/repos/" this.owner "/" repo "/git/refs/heads/" this.Branch() this.token,this.http.Open("PATCH",url)
		json={"sha":"%sha%","force":true}
		this.http.send(json)
		SplashTextOff
		return this.http.status
	}
	Refresh(){
		global x
		this.repo:=SSN(Node(),"@repo").text
		if(this.repo){
			if(!FileExist(x.Path() "\Github"))
				FileCreateDir,% x.Path() "\Github"
			dxml:=new XML(this.repo,x.Path() "\Github\" this.repo ".xml")
			branch:=SSN(Node(),"@branch").text
			dxml.Save(1)
		}
	}
	RepoURL(Path:="",Extra:=""){
		return this.baseurl:=this.url "/repos/" this.owner "/" this.repo (Path?"/" Path:"") this.token Extra
	}
	Send(verb,url,data=""){
		this.http.Open(verb,url),this.http.Send(IsObject(data)?this.json(data):data),SB_SetText("Remaining API Calls: " this.remain:=this.http.GetResponseHeader("X-RateLimit-Remaining"))
		return this.http.ResponseText
	}
	Sha(text){
		RegExMatch(this.http.ResponseText,"U)\x22sha\x22:(.*),",found)
		return Trim(found1,Chr(34))
	}
	Tree(repo,parent,blobs){
		url:=this.url "/repos/" this.owner "/" repo "/git/trees" this.token,open:="{"
		if(parent)
			json=%open% "base_tree":"%parent%","tree":[
		else
			json=%open% "tree":[
		for a,blob in blobs{
			add={"path":"%a%","mode":"100644","type":"blob","sha":"%blob%"},
			json.=add
		}
		return this.Sha(info:=this.Send("POST",url,Trim(json,",") "]}"))
	}
	/*
		Tree(repo,parent,blobs){
			;url:=this.RepoURL("git/trees"),open:="{"
			url:=this.url "/repos/" this.owner "/" repo "/git/trees" this.token,open:="{"
			if(parent)
				json=%open% "base_tree":"%parent%","tree":[
			else
				json=%open% "tree":[
			for a,blob in blobs{
				add={"path":"%a%","mode":"100644","type":"blob","sha":"%blob%"},
				json.=add
			}
			sha:=this.Sha(info:=this.Send("POST",url,Trim(json,",") "]}"))
			return sha
		}
	*/
	TreeSha(){
		node:=dxml.Find("//branch/@name",this.Branch()),url:=this.url "/repos/" this.owner "/" this.repo "/commits/" this.Branch() this.token,tree:=this.Sha(this.Send("GET",url)),url:=this.url "/repos/" this.owner "/" this.repo "/git/trees/" tree this.token "&recursive=1",info:=this.Send("GET",url),info:=SubStr(info,InStr(info,"tree" Chr(34)))
		for a,b in StrSplit(info,"{")
			if(path:=this.Find("path",b)){
				if(this.Find("mode",b)!="100644"||path="readme.md"||path=".gitignore")
					Continue
				StringReplace,path,path,/,\,All
				if(!nn:=SSN(node,"descendant::*[@file='" path "']"))
					nn:=dxml.Under(node,"file",{file:path})
				nn.SetAttribute("sha",this.Find("sha",b))
	}}
	UTF8(info){
		info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
		for a,b in {"`n":"\n","`t":"\t","`r":"\r"}
			StringReplace,info,info,%a%,%b%,All
		return info
	}
}