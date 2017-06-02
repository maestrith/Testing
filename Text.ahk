Text(text){
	return RegExReplace(text,"\x7f","`r`n")
}