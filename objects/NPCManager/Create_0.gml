
npcs       = {};   // "prof_quimica" -> struct de dado
instancias = {};   // "prof_quimica" -> id da instância (corpo) na tela
zonas      = {};   // "prof_quimica" -> id da zona de interação (objProximo) na tela


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



// Remove TUDO que pertence aos NPCs do mês anterior: o corpo (oNpc)
// E a zona de interação (objProximo). Antes só o corpo era removido,
// e as zonas ficavam espalhadas pelo mapa se acumulando a cada mês.
function npc_remover_atuais() {
    // o diálogo pode estar apontando para uma zona que vai sumir
    if (instance_exists(dialogoManager_UI) && dialogoManager_UI.estado != "fechado") {
        dialogoManager_UI.fechar();
    }

    var _ids = variable_struct_get_names(instancias);
    for (var i = 0; i < array_length(_ids); i++) {
        var _inst = instancias[$ _ids[i]];
        if (instance_exists(_inst)) instance_destroy(_inst);
    }

    var _ids_z = variable_struct_get_names(zonas);
    for (var i = 0; i < array_length(_ids_z); i++) {
        var _zona = zonas[$ _ids_z[i]];
        if (instance_exists(_zona)) instance_destroy(_zona);
    }

    // rede de segurança: nada de NPC ou zona "órfã" sobrando na room
    with (oNpc)      instance_destroy();
    with (objProximo) instance_destroy();

    instancias = {};
    zonas      = {};
}



function npc_posicionar(_mes) {

    npc_remover_atuais();
    var _ids = variable_struct_get_names(npcs);

    for (var i = 0; i < array_length(_ids); i++) {
        var _dado = npcs[$ _ids[i]];
        var _pos  = npc_posicao_no_mes(_dado, _mes);

        if (_pos == undefined) continue;

        // corpo do NPC
        var _inst = instance_create_layer(_pos.x, _pos.y, "Instances", oNpc);
        _inst.npc_id       = _dado.id;        // <- aqui o corpo recebe a alma????
        _inst.sprite_index = _dado.sprite;

        // zona onde o player aperta E para falar com ele
        var _zona = instance_create_layer(_pos.x, _pos.y, "Instances", objProximo);
        _zona.npc_id = _dado.id;

        instancias[$ _dado.id] = _inst;
        zonas[$ _dado.id]      = _zona;
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
