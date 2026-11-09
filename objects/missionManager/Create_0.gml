
missoes_por_mes = 4;   // máximo de missões novas por mês (ajuste à vontade)
modo_teste = true;
missoes_vistas = [];
proximo_id = 0;        // contador para IDs únicos



mission_catalog = mission_Data();
active_missions = [];
mission_history = [];





// função de achar missão por ID
function mission_data_get(_mission_id) {
    var _catalogo = mission_catalog;
    for (var i = 0; i < array_length(_catalogo); i++) {
        if (_catalogo[i].id == _mission_id) return _catalogo[i];
    }
    return undefined;
}



// verificar se NPC tem missão pendente
// pra mostrar balão de fala, por exemplo
function missao_pendente_de(_npc_id) {
    var _ativas = active_missions;
	
	
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].npc_id == _npc_id && _ativas[i].status == "pendente") {
            return _ativas[i];   // devolve a MissionInstance
        }
    }
    return undefined;
}



function mission_resolver_direto(_instance_id) {
	show_debug_message("Resolvendo direto")
	show_debug_message(_instance_id)
	show_debug_message("==================")
    var _ativas = missionManager.active_missions;
	
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id != _instance_id) continue;
        _ativas[i].status = "resolvida";
        array_push(missionManager.mission_history, _ativas[i]);
        array_delete(_ativas, i, 1);
        return;
    }
}



function mission_avancar_etapa(_instance_id, _nova_etapa) {
    var _ativas = missionManager.active_missions;
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id == _instance_id) {
            _ativas[i].etapa = _nova_etapa;
            return;
        }
    }
}



function mission_verificar_pontos_busca() {
    var _ativas = active_missions;

    for (var i = 0; i < array_length(_ativas); i++) {
        var _instancia = _ativas[i];
        if (_instancia.status != "pendente" || _instancia.etapa != "buscando") continue;

        var _md = mission_data_get(_instancia.mission_id);
        if (_md.tipo_missao != "busca") continue;

        if (player_esta_no_ponto(_md.ponto_busca)) {
            return _instancia;   // devolve a missão que o player pode coletar aqui
        }
    }

    return undefined;
}


// ===== CONSULTAS =====

// o NPC já tem alguma missão pendente? (regra: 1 missão por NPC)
function npc_tem_missao(_npc_id) {
    for (var i = 0; i < array_length(active_missions); i++) {
        if (active_missions[i].npc_id == _npc_id
        && active_missions[i].status == "pendente") return true;
    }
    return false;
}




// a missão já está ativa ou já foi feita? (evita repetir)
function mission_id_em_uso(_mission_id) {
    for (var i = 0; i < array_length(active_missions); i++) {
        if (active_missions[i].mission_id == _mission_id) return true;
    }
    for (var i = 0; i < array_length(mission_history); i++) {
        if (mission_history[i].mission_id == _mission_id) return true;
    }
    return false;
}






// ===== SORTEIO =====


// sorteio ponderado por peso_sorteio (devolve o índice sorteado)
function mission_sortear_indice(_lista) {
    var _total = 0;
    for (var i = 0; i < array_length(_lista); i++) {
        _total += _lista[i][$ "peso_sorteio"] ?? 1;
    }
    var _r = random(_total);
    var _acc = 0;
    for (var i = 0; i < array_length(_lista); i++) {
        _acc += _lista[i][$ "peso_sorteio"] ?? 1;
        if (_r < _acc) return i;
    }
    return array_length(_lista) - 1;
}

// a missão serve para esse NPC?
function mission_compativel(_md, _dado, _mes) {
    // filtro de mês (ignorado no modo teste)
    if (!modo_teste
    && _md.meses_disponiveis != undefined
    && !array_contains(_md.meses_disponiveis, _mes)) return false;

    // já está ativa em outro NPC
    if (mission_id_em_uso(_md.id)) return false;

    // missão com NPC fixo: só serve para ele
    if (_md.npc_id_especifico != undefined) return (_md.npc_id_especifico == _dado.id);

    // missão por tipo
    return (_md.tipo_npc_alvo == "qualquer" || _md.tipo_npc_alvo == _dado.tipo);
}

function mission_sortear_para_mes(_mes) {

    // 1) NPCs que estão na cena neste mês e ainda sem missão
    var _livres = [];
    var _ids = variable_struct_get_names(NPCManager.npcs);
    for (var i = 0; i < array_length(_ids); i++) {
        var _dado = NPCManager.npcs[$ _ids[i]];
        if (NPCManager.npc_posicao_no_mes(_dado, _mes) == undefined) continue;  // não está na cena
        if (npc_tem_missao(_dado.id)) continue;                                  // já tem missão
        array_push(_livres, _dado);
    }

    // 2) embaralha, para cada mês começar por NPCs diferentes
    for (var i = array_length(_livres) - 1; i > 0; i--) {
        var _j = irandom(i);
        var _tmp = _livres[i];
        _livres[i] = _livres[_j];
        _livres[_j] = _tmp;
    }

    // 3) para cada NPC, sorteia uma missão compatível
    var _criadas = 0;
    for (var n = 0; n < array_length(_livres); n++) {
        if (_criadas >= missoes_por_mes) break;
        var _dado = _livres[n];

        // missões compatíveis com ele
        var _compat = [];
        for (var i = 0; i < array_length(mission_catalog); i++) {
            if (mission_compativel(mission_catalog[i], _dado, _mes)) {
                array_push(_compat, mission_catalog[i]);
            }
        }
        if (array_length(_compat) == 0) {
            show_debug_message("  " + _dado.id + " (" + string(_dado.tipo) + "): nenhuma missão compatível");
            continue;
        }

        // prioriza as que ainda não apareceram nesta partida
        var _novas = [];
        for (var i = 0; i < array_length(_compat); i++) {
            if (!array_contains(missoes_vistas, _compat[i].id)) array_push(_novas, _compat[i]);
        }
        if (array_length(_novas) == 0) _novas = _compat;

        var _md = _novas[mission_sortear_indice(_novas)];

        proximo_id += 1;
        array_push(active_missions, {
            instance_id: string(proximo_id) + "_" + _md.id,
            mission_id: _md.id,
            npc_id: _dado.id,
            status: "pendente",
            etapa: "pedido",
            opc: noone,
            grau_atual: 0,
            mes_criacao: _mes,
            mes_ultima_interacao: _mes
        });
        array_push(missoes_vistas, _md.id);
        _criadas += 1;

        show_debug_message("Missão " + _md.id + " -> " + _dado.id);
    }
}

// roda uma vez: avisa quais missões apontam para NPC que não existe
function mission_validar_catalogo() {
    for (var i = 0; i < array_length(mission_catalog); i++) {
        var _md = mission_catalog[i];
        if (_md.npc_id_especifico != undefined
        && NPCManager.npc_get(_md.npc_id_especifico) == undefined) {
            show_debug_message("AVISO: missão '" + _md.id + "' aponta para NPC inexistente: " + _md.npc_id_especifico);
        }
    }
}





// ===== RESOLUÇÃO (DIÁLOGO) =====

function mission_resolver(_instance_id, _indice_opcao) {
    for (var i = 0; i < array_length(active_missions); i++) {
        if (active_missions[i].instance_id != _instance_id) continue;

        var _instancia = active_missions[i];
        var _md = mission_data_get(_instancia.mission_id);
        var _opcao = _md.opcoes[_indice_opcao];
        var _efeito = _opcao[$ "efeito"];

        // opção "Ignorar": só fecha, a missão continua pendente
        if (_efeito != undefined && variable_struct_exists(_efeito, "acao") && _efeito.acao == "fechar") {
            dialogoManager_UI.opcao_selecionada = 0;
            return true;   // o diálogo fecha, a missão continua pendente
        }

        // opção de "pagar para resolver": precisa ter o dinheiro
        if (!variable_struct_exists(_opcao, "correta") && !gameManager.pode_pagar(_efeito)) {
            dialogoManager_UI.mostrar_aviso("Dinheiro insuficiente!");
            return false;   // nada muda, diálogo continua aberto
        }

        // acertou, errou ou opção paga: aplica o efeito
        gameManager.aplicar_efeito(_efeito);

        statusManager_UI.reset_values();
        _instancia.status = "resolvida";
        array_push(mission_history, _instancia);
        array_delete(active_missions, i, 1);
        dialogoManager_UI.opcao_selecionada = 0;
        return true;
    }
    return false;
}






// ===== RESOLUÇÃO (BUSCA) =====

function tratar_escolha_pedido(_opcs) {
    if (_opcs == undefined) return;
    gameManager.aplicar_efeito(_opcs[$ "efeito"]);
    statusManager_UI.reset_values();
}










// ===== FIM DE MÊS =====

// acha a penalidade de um grau dentro do array
function mission_penalidade_do_grau(_md, _grau) {
    for (var j = 0; j < array_length(_md.penalidade_por_grau); j++) {
        if (_md.penalidade_por_grau[j].grau == _grau) return _md.penalidade_por_grau[j];
    }
    return undefined;
}












// agora só aplica penalidades. Quem sorteia o próximo mês é o gameManager.reset()
function mission_processar_fim_de_mes() {
    // de trás pra frente, porque removemos itens durante o loop
    for (var i = array_length(active_missions) - 1; i >= 0; i--) {
        var _instancia = active_missions[i];
        if (_instancia.status != "pendente") continue;

        var _md = mission_data_get(_instancia.mission_id);
        _instancia.grau_atual += 1;

        gameManager.aplicar_efeito(mission_penalidade_do_grau(_md, _instancia.grau_atual));

        if (_instancia.grau_atual >= _md.grau_maximo) {
            _instancia.status = "expirada";
            array_push(mission_history, _instancia);
            array_delete(active_missions, i, 1);
        }
    }
    statusManager_UI.reset_values();
}


