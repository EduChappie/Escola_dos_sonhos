
npcs       = {};   // "prof_gilson" -> struct de dado
instancias = {};   // "prof_gilson" -> id da instância na tela


var _lista = npc_catalog(); // lista dos npcs

for (var i = 0; i < array_length(_lista); i++) {
    var _n = _lista[i];
    npcs[$ _n.id] = _n;
}





// função de pegar o npc especifico
function npc_get(_id) {
    return NPCManager.npcs[$ _id];       // "quem é o Gilson?"
}


// função de pegar as posições do npc
function npc_posicao_no_mes(_dado, _mes) {
    for (var i = 0; i < array_length(_dado.agenda_mensal); i++) {
        if (_dado.agenda_mensal[i].mes == _mes) return _dado.agenda_mensal[i];
    }
    return _dado.agenda_mensal[0];            // fallback
}







function npc_posicionar(_mes) {
	 var _ids = variable_struct_get_names(npcs);
	 
	 for (var i = 0; i < array_length(_ids); i++) {
        var _dado = npcs[$ _ids[i]];
        var _pos  = npc_posicao_no_mes(_dado, _mes);

        var _inst = instance_create_layer(_pos.x, _pos.y, "Instances", oNpc);
        _inst.npc_id       = _dado.id;        // <- aqui o corpo recebe a alma????
        _inst.sprite_index = _dado.sprite;
		_inst.talk         = _dado.talk; // esse talk existe temporáriamente, depois tirar
		
		var interaction_zone = instance_create_layer(
			_pos.x,
			_pos.y,
			"Instances",
			objProximo
		)
		interaction_zone.npc_id = _dado.id


        instancias[$ _dado.id] = _inst;
    }
	

}






function npc_sortear_por_tipo(_tipo) {
    var _ids = variable_struct_get_names(NPCManager.npcs);
    var _candidatos = [];

    for (var i = 0; i < array_length(_ids); i++) {
        var _dado = NPCManager.npcs[$ _ids[i]];
        if (_tipo == "qualquer" || _dado.tipo == _tipo) {
            array_push(_candidatos, _dado.id);
        }
    }

    if (array_length(_candidatos) == 0) return undefined;
    return _candidatos[irandom(array_length(_candidatos) - 1)];
}