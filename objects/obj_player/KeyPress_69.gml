

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