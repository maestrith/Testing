EncodeFile(fn,time,nn,branch){
	FileRead,bin,*c %fn%
	FileGetSize,size,%fn%
	DllCall("Crypt32.dll\CryptBinaryToStringW",Ptr,&bin,UInt,size,UInt,1,UInt,0,UIntP,Bytes),VarSetCapacity(out,Bytes*2),DllCall("Crypt32.dll\CryptBinaryToStringW",Ptr,&bin,UInt,size,UInt,1,Str,out,UIntP,Bytes)
	StringReplace,out,out,`r`n,,All
	return {text:out,encoding:"UTF-8",time:time,skip:1,node:nn,branch:branch}
}