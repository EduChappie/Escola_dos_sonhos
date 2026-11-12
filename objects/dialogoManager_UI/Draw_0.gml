// função de "disponível pra falar"
// verifica se o NPC está disponível pra falar
// desenha balão de conversa



var ids = variable_struct_get_names(NPCManager.instancias)


for (var n = 0; n < array_length(ids); n++) {
	
	
	var _npc = ids[n];
	var _inst = NPCManager.instancias[$ _npc];
	
	
	if (!instance_exists(_inst)) {
		continue;
	}
	
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
    
    draw_sprite(sArea50x, 0, _p.x, _p.y);  // balão em cima da zona
	
}





// ===== BALÃO "APERTE E" NA CABEÇA DO PLAYER =====
// Aparece quando o player pode interagir (está na zona de um NPC ou num
// ponto de coleta) E nenhum diálogo está aberto. Some ao apertar E
// (o diálogo abre) e volta quando o diálogo fecha, se ele ainda estiver na zona.
// Posição: balao_acao_dx / balao_acao_dy no Create deste objeto.
if (estado == "fechado" && instance_exists(obj_player)) {
	var _na_zona_de_npc = (obj_player.npc_proximo != noone);
	var _no_ponto_coleta = (_missao_no_ponto != undefined);

	if (_na_zona_de_npc || _no_ponto_coleta) {
		draw_sprite(balao_acao, 0, obj_player.x + balao_acao_dx, obj_player.y + balao_acao_dy);
	}
}
