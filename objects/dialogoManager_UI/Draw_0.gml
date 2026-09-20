
// função de "disponível pra falar"
// verifica se o NPC está disponível pra falar
// desenha balão de conversa

var ids = variable_struct_get_names(NPCManager.instancias)

for (x = 0; x < array_length(ids); x++) {
	
	var _npc = ids[x];
	var _inst = NPCManager.instancias[$ _npc];
	
	//if (missao_pendente_de(_npc_id) != undefined) {
    //    draw_sprite(spr_balao_fala, 0, _inst.x, _inst.y - 40);
    //}
	// a maneira correta, é fazer com a informação vindo do misisonManager
	// mas não temos isso ainda, da pra aguardar.
	
	if (_inst.talk) {
		draw_sprite( ballon_talking, 0, _inst.x, _inst.y - 30 );
	}
	
	
}