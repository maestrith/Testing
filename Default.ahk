Default(Control:="SysListView321"){
	Type:=InStr(Control,"SysListView32")?"Listview":"Treeview"
	Gui,%win%:Default
	Gui,%win%:%Type%,%Control%
}