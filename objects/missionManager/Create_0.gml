
missoes_por_mes = 4;   // máximo de missões novas por mês (ajuste à vontade)
modo_teste = true;     // true = ignora meses_disponiveis das missões
missoes_vistas = [];
proximo_id = 0;        // contador para IDs únicos



mission_catalog = mission_Data();
active_missions = [];
mission_history = [];

// consequências marcadas para meses futuros (ver mission_registrar_resultado)
consequencias_agendadas = [];





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



// ===== CONSEQUÊNCIAS =====

// Chamada sempre que uma missão termina (acertou / errou / pagou / expirou).
// Guarda o resultado na instância e agenda as consequências definidas
// em "consequencias" dentro do mission_Data.
function mission_registrar_resultado(_instancia, _resultado) {
    _instancia.resultado = _resultado;
    _instancia.mes_resolucao = gameManager.mes_atual;

    var _md = mission_data_get(_instancia.mission_id);
    var _lista = _md[$ "consequencias"];
    if (_lista == undefined) return;

    for (var i = 0; i < array_length(_lista); i++) {
        var _c = _lista[i];
        if (_c.quando != _resultado) continue;

        var _meses = max(1, _c[$ "apos_meses"] ?? 1);

        array_push(consequencias_agendadas, {
            mes_alvo:       gameManager.mes_atual + _meses,
            mission_id:     _md.id,
            npc_id:         _instancia.npc_id,
            resultado:      _resultado,
            efeito:         _c[$ "efeito"],
            evento_critico: _c[$ "evento_critico"],
            flag:           _c[$ "flag"],
            texto:          _c[$ "texto"]
        });

        show_debug_message("Consequência agendada: " + _md.id + " (" + _resultado + ") -> mês " + string(gameManager.mes_atual + _meses));
    }
}


// Chamada pelo gameManager.novoMes(), já com o mês novo.
// Aplica tudo que estava agendado para este mês (ou antes).
function mission_aplicar_consequencias(_mes) {
    gameManager.noticias_do_mes = [];
    var _restantes = [];

    for (var i = 0; i < array_length(consequencias_agendadas); i++) {
        var _c = consequencias_agendadas[i];

        if (_c.mes_alvo > _mes) {          // ainda não chegou a hora
            array_push(_restantes, _c);
            continue;
        }

        gameManager.aplicar_efeito(_c.efeito);
        if (_c.evento_critico != undefined) gameManager.evento_critico_executar(_c.evento_critico);
        if (_c.flag != undefined)           gameManager.flag_set(_c.flag);
        if (_c.texto != undefined) {
            array_push(gameManager.noticias_do_mes, _c.texto);
            show_debug_message("NOTÍCIA: " + _c.texto);
        }
    }

    consequencias_agendadas = _restantes;
}



function mission_resolver_direto(_instance_id) {
	show_debug_message("Resolvendo direto")
	show_debug_message(_instance_id)
	show_debug_message("==================")
    var _ativas = missionManager.active_missions;
	
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id != _instance_id) continue;

        var _instancia = _ativas[i];

        // veio da entrega do item = acertou | veio direto do pedido = pagou
        var _resultado = (_instancia.etapa == "pronta_para_entregar") ? "acertou" : "pagou";

        _instancia.status = "resolvida";
        mission_registrar_resultado(_instancia, _resultado);
        array_push(missionManager.mission_history, _instancia);
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
    // missão dormente (aguardando NPC ou ajustes)
    if (_md[$ "ativa"] != undefined && !_md.ativa) return false;

    // flags: exige ou bloqueia conforme o que já aconteceu no jogo
    var _req = _md[$ "requer_flag"];
    if (_req != undefined && !gameManager.flag_tem(_req)) return false;
    var _blq = _md[$ "bloqueada_por_flag"];
    if (_blq != undefined && gameManager.flag_tem(_blq)) return false;

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

// roda uma vez: avisa de problemas no catálogo de missões
function mission_validar_catalogo() {
    var _resultados_validos = ["acertou", "errou", "pagou", "expirou"];

    for (var i = 0; i < array_length(mission_catalog); i++) {
        var _md = mission_catalog[i];

        // dormente: só informa quem ela está esperando
        if (_md[$ "ativa"] != undefined && !_md.ativa) {
            show_debug_message("(dormente) '" + _md.id + "' aguarda NPC: " + string(_md.npc_id_especifico));
            continue;
        }

        if (_md.npc_id_especifico != undefined
        && NPCManager.npc_get(_md.npc_id_especifico) == undefined) {
            show_debug_message("AVISO: missão '" + _md.id + "' aponta para NPC inexistente: " + _md.npc_id_especifico);
        }

        if (_md.tipo_missao == "busca") {
            var _pb = _md[$ "ponto_busca"];
            if (_pb == undefined || (_pb.x == 0 && _pb.y == 0)) {
                show_debug_message("AVISO: missão '" + _md.id + "' está sem ponto_busca válido");
            }
        }

        var _cons = _md[$ "consequencias"];
        if (_cons != undefined) {
            for (var j = 0; j < array_length(_cons); j++) {
                if (!array_contains(_resultados_validos, _cons[j].quando)) {
                    show_debug_message("AVISO: missão '" + _md.id + "' tem consequência com 'quando' inválido: " + string(_cons[j].quando));
                }
            }
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

        // descobre o resultado (usado nas consequências dos meses seguintes)
        var _resultado = "pagou";
        if (variable_struct_exists(_opcao, "correta")) {
            _resultado = _opcao.correta ? "acertou" : "errou";
        }

        statusManager_UI.reset_values();
        _instancia.status = "resolvida";
        mission_registrar_resultado(_instancia, _resultado);
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
            mission_registrar_resultado(_instancia, "expirou");
            array_push(mission_history, _instancia);
            array_delete(active_missions, i, 1);
        }
    }
    statusManager_UI.reset_values();
}
