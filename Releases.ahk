Releases(){
	UpdateReleases(git.Send("GET",git.BaseURL "releases"))
}