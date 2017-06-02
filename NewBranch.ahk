NewBranch(){
	InputBox,branch,Enter a new branch,Branch Name?,,,150
	if(ErrorLevel||branch="")
		return
	branch:=RegExReplace(branch," ","-"),info:=git.Send("POST",git.baseurl "git/refs" git.token,git.json({"ref":"refs/heads/" branch,"sha":git.sha(git.Send("GET",git.baseurl "git/refs/heads/" git.Branch() git.token))}))
	if(git.http.status!=201)
		return m(info,git.http.status)
	UpdateBranches()
}