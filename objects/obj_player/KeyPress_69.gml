

if (npc_proximo != noone and npc_proximo.i==0 and missionManager.missao_pendente_de(npc_proximo.id) != undefined) {
	// quer dizer que o player pode interagir
	/*
		Condições: 
			está perto de alguém
			não interagiu antes
			o npc esta disponivel pra falar
	*/
	
	
	show_debug_message("Player interagiu com " + npc_proximo.nome)

	npc_proximo.i+=1
}





var _npc_instancia = instance_place(x, y, objProximo); 


if (_npc_instancia != noone && dialogoManager_UI.estado == "fechado") {
    
	var NPCID = NPCManager.npc_get(_npc_instancia.npc_id);
	//show_debug_message(NPCID.id);
	
    var _missao = missionManager.missao_pendente_de(NPCID.id);

    if (_missao != undefined) {
		show_debug_message(_missao)
        dialogoManager_UI.abrir(_missao, _npc_instancia);
		
    } else {
        var _dado = NPCManager.npc_get(_npc_instancia.npc_id);
		dialogoManager_UI.abrir_texto_simples(_dado.nome + ": tudo tranquilo, diretor.", _npc_instancia);
	}
}













var _missao_no_ponto = missionManager.mission_verificar_pontos_busca();

if (_missao_no_ponto != undefined && dialogoManager_UI.estado == "fechado") {
    missionManager.mission_avancar_etapa(_missao_no_ponto.instance_id, "pronta_para_entregar");
    dialogoManager_UI.abrir_texto_simples("Você pegou o giz! Volte para entregar.", noone);
}