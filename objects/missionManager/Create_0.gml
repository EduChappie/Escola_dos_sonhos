
mission_catalog = mission_Data()
active_mission = [];
mission_history = [];


// função de achar missão por ID
function mission_data_get(_mission_id) {
    var _catalogo = obj_mission_manager.mission_catalog;
    for (var i = 0; i < array_length(_catalogo); i++) {
        if (_catalogo[i].id == _mission_id) return _catalogo[i];
    }
    return undefined;
}




// verificar se NPC tem missão pendente
// pra mostrar balão de fala, por exemplo
function missao_pendente_de(_npc_id) {
    var _ativas = obj_mission_manager.active_missions;
	
	
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].npc_id == _npc_id && _ativas[i].status == "pendente") {
            return _ativas[i];   // devolve a MissionInstance
        }
    }
    return undefined;
}










// sortear as missões para o próximo mês
function mission_sortear_para_mes(_mes) {
    var _catalogo = obj_mission_manager.mission_catalog;

    for (var i = 0; i < array_length(_catalogo); i++) {
        var _md = _catalogo[i];

        // filtro 1: mês certo
        if (_md.meses_disponiveis != undefined
        && !array_contains(_md.meses_disponiveis, _mes)) continue;

        // filtro 2: define o alvo (npc específico ou por tipo)
        var _npc_id_alvo;
        if (_md.npc_id_especifico != undefined) {
            _npc_id_alvo = _md.npc_id_especifico;
        } else {
            _npc_id_alvo = npc_sortear_por_tipo(_md.tipo_npc_alvo);
            if (_npc_id_alvo == undefined) continue;
        }

        // filtro 3: não duplicar missão idêntica já ativa nesse NPC
        if (mission_ja_ativa(_npc_id_alvo, _md.id)) continue;

        // cria a instância
        var _instancia = {
            instance_id: string(irandom(999999)) + "_" + _md.id,
            mission_id: _md.id,
            npc_id: _npc_id_alvo,
            status: "pendente",
            grau_atual: 0,
            mes_criacao: _mes,
            mes_ultima_interacao: _mes
        };

        array_push(obj_mission_manager.active_missions, _instancia);
    }
}













// verificar se uma missão já não está ativa, para a aleatoriedade
function mission_ja_ativa(_npc_id, _mission_id) {
    var _ativas = obj_mission_manager.active_missions;
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].npc_id == _npc_id
        && _ativas[i].mission_id == _mission_id
        && _ativas[i].status == "pendente") return true;
    }
    return false;
}






// função de resolve  missão com base na escolha do player
// não sei como mexer ainda, verificar depois
function mission_resolver(_instance_id, _indice_opcao) {
    var _ativas = obj_mission_manager.active_missions;

    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id != _instance_id) continue;

        var _instancia = _ativas[i];
        var _md = mission_data_get(_instancia.mission_id);
        var _opcao = _md.opcoes[_indice_opcao];

        if (_md.tipo_resolucao == "pergunta_com_certo_errado") {
            var _efeito = _opcao.correta ? _opcao.efeito_acerto : _opcao.efeito_erro;
            stats_aplicar_efeito(_efeito);
        } else {
            stats_aplicar_efeito(_opcao.efeito);
        }

        _instancia.status = "resolvida";
        array_push(obj_mission_manager.mission_history, _instancia);
        array_delete(_ativas, i, 1);
        return;
    }
}






// processar postergação de missão em passagem de mês
function mission_processar_fim_de_mes(_mes_atual) {
    var _ativas = obj_mission_manager.active_missions;

    // varre de trás pra frente porque vamos remover itens durante o loop
    for (var i = array_length(_ativas) - 1; i >= 0; i--) {
        var _instancia = _ativas[i];
        if (_instancia.status != "pendente") continue;

        var _md = mission_data_get(_instancia.mission_id);
        _instancia.grau_atual += 1;

        var _penalidade = _md.penalidade_por_grau[$ string(_instancia.grau_atual)];
        if (_penalidade != undefined) {
            stats_aplicar_efeito(_penalidade);
        }

        if (_instancia.grau_atual >= _md.grau_maximo) {
            _instancia.status = "expirada";
            array_push(obj_mission_manager.mission_history, _instancia);
            array_delete(_ativas, i, 1);
        }
    }

    mission_sortear_para_mes(_mes_atual + 1);
}



