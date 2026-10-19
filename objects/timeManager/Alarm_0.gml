//tick de tempo
t_mil -= 1

if t_mil = -1{//reduz os segundos por 1
	t_mil = 9
	t_sec -= 1
}

if t_sec = -1{//reduz os minutos por 1
	t_sec = 59
	t_min -= 1
}

//make sure timer doswnt tick if at 0
if!(t_sec = 0 && t_min = 0 && t_mil = 0){
	alarm[0] = 6
	
}else{
	//quando timer termina
	//da pra ao inves de game end colocar pra terminar o turno
	
	
	/// == por favor, lembrar de alterar toda essa função,
	///   isso não é responsabilidade de time_manger
	if (gameManager.mes_atual < 11) {
		
		gameManager.novoMes()
		
	} else {
		show_debug_message("Fim de jogo")
		// levar pra sala de finalização
		//room_goto(finished_screen)
	}
	
	space_to_reset()
}