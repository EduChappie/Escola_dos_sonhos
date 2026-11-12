// ===== PAUSA DO RELÓGIO =====
// O tempo NÃO corre durante diálogos/perguntas (o jogador precisa ler e pensar)
// nem durante o fim de mês (resumo e fades). Só continua a "tick" depois.
var _dialogo_aberto = instance_exists(dialogoManager_UI)
	&& variable_instance_exists(dialogoManager_UI, "estado")
	&& dialogoManager_UI.estado != "fechado";

if (gameManager.fase != "jogando" || _dialogo_aberto) {
	alarm[0] = 6;   // continua verificando, mas sem gastar tempo
	exit;
}


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
	// tempo acabou: o gameManager cuida do resto (fade, resumo, mês novo, e
	// reinicia este relógio em terminar_transicao()). Em dezembro o mesmo fluxo
	// termina na avaliação final.
	gameManager.fim_do_mes()
}
