
meses = [
	"Janeiro",    // 0
	"Fevereiro",
	"Março",
	"Abril",
	"Maio",
	"Junho",
	"Julho",
	"Agosto",
	"Setembro",
	"Outubro",
	"Novembro",
	"Dezembro"   // 11
]


mes_atual = 0;
infraestrutura = 0;
felicidade = 50;
moeda = 1200;




NPCManager.npc_posicionar(mes_atual);
missionManager.mission_sortear_para_mes(mes_atual);
timeManager.reset()



function reset() {
	
	// botar aqui depois a verificação de consequências
	
	NPCManager.npc_posicionar(mes_atual);
	missionManager.mission_sortear_para_mes(mes_atual);
}


function novoMes() {
	mes_atual += 1
	moeda += 200
	
	obj_player.resetPosition()
	statusManager_UI.reset_values()
	show_debug_message("Passou o mês")
	show_debug_message(meses[gameManager.mes_atual])
	
	reset()
}
