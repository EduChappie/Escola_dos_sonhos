
npcs       = {};   // "prof_quimica" -> struct de dado
instancias = {};   // "prof_quimica" -> id da instância na tela


var _lista = npc_catalog(); // lista dos npcs

for (var i = 0; i < array_length(_lista); i++) {
    var _n = _lista[i];
    _n.agenda_mensal = npc_montar_agenda(_n.rota);   // rota (nomes de sala) -> agenda (x, y)
    npcs[$ _n.id] = _n;
}





// função de pegar o npc especifico
function npc_get(_id) {
    return NPCManager.npcs[$ _id];       // "quem é o Gilson?"
}


// função de pegar a posição do npc naquele mês
// - mês sem entrada na agenda: repete a última posição conhecida
// - sala "ausente": devolve undefined (NPC não aparece naquele mês)
function npc_posicao_no_mes(_dado, _mes) {
    var _ultima = undefined;

    for (var i = 0; i < array_length(_dado.agenda_mensal); i++) {
        var _e = _dado.agenda_mensal[i];
        if (_e.mes == _mes) {
            if (_e.sala == "ausente") return undefined;
            return _e;
        }
        if (_e.mes < _mes) _ultima = _e;
    }

    if (_ultima != undefined && _ultima.sala == "ausente") return undefined;
    return _ultima;
}



function npc_remover_atuais() {
    var _ids = variable_struct_get_names(instancias);

    for (var i = 0; i < array_length(_ids); i++) {
        var _id = _ids[i];
        var _inst = instancias[$ _id];

        if (instance_exists(_inst)) {
            instance_destroy(_inst);
        }
    }

    instancias = {};
}



function npc_posicionar(_mes) {
	
	npc_remover_atuais()
	var _ids = variable_struct_get_names(npcs);
	 
	for (var i = 0; i < array_length(_ids); i++) {
		var _dado = npcs[$ _ids[i]];
		var _pos  = npc_posicao_no_mes(_dado, _mes);
		
		if (_pos == undefined) continue;

		var _inst = instance_create_layer(_pos.x, _pos.y, "Instances", oNpc);
        _inst.npc_id       = _dado.id;        // <- aqui o corpo recebe a alma????
        _inst.sprite_index = _dado.sprite;
		
		
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
