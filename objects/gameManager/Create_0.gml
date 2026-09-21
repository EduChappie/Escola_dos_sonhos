
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

