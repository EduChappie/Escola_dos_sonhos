gmil -= 1

if gmil = -1{//reduz os segundos por 1
	gmil = 9
	gsec -= 1
}

if gsec = -1{//reduz os minutos por 1
	gsec = 59
	gmin -= 1
}

//make sure timer doswnt tick if at 0
if!(gsec = 0 && gmin = 0 && gmil = 0){
	alarm[1] = 6
	
}else{
	
	reset()
}