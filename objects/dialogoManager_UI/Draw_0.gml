// função de "disponível pra falar"
// verifica se o NPC está disponível pra falar
// desenha balão de conversa

var ids = variable_struct_get_names(NPCManager.instancias)


for (x = 0; x < array_length(ids); x++) {
	var _npc = ids[x];
	var _inst = NPCManager.instancias[$ _npc];
	
	if (missionManager.missao_pendente_de(_npc) != undefined) {
        draw_sprite(ballon, 0, _inst.x, _inst.y - 30);
    }
	//a maneira correta, é fazer com a informação vindo do misisonManager
	//mas não temos isso ainda, da pra aguardar.
}






var _missao_no_ponto = missionManager.mission_verificar_pontos_busca();

if (_missao_no_ponto != undefined) {
    var _md = missionManager.mission_data_get(_missao_no_ponto.mission_id);
    var _p = _md.ponto_busca;
    
    draw_sprite(sArea50x, 0, _p.x + _p.w/2, _p.y - 10);  // balão em cima da zona
}