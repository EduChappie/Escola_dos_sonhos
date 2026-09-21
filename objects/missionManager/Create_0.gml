
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










// sortear as missões para o próximo mês
function mission_sortear_para_mes(_mes) {
    var _catalogo = mission_catalog;

    for (var i = 0; i < array_length(_catalogo); i++) {
        var _md = _catalogo[i];

        show_debug_message("--- avaliando missão: " + _md.id);

        // filtro 1: mês certo
        if (_md.meses_disponiveis != undefined
        && !array_contains(_md.meses_disponiveis, _mes)) {
            show_debug_message("  -> BARRADA no filtro de mês. meses_disponiveis=" + string(_md.meses_disponiveis) + " mes_atual=" + string(_mes));
            continue;
        }

        // filtro 2: define o alvo
        var _npc_id_alvo;
        if (_md.npc_id_especifico != undefined) {
            _npc_id_alvo = _md.npc_id_especifico;
            show_debug_message("  -> alvo específico: " + _npc_id_alvo);
        } else {
            _npc_id_alvo = NPCManager.npc_sortear_por_tipo(_md.tipo_npc_alvo);
            show_debug_message("  -> sorteado por tipo (" + _md.tipo_npc_alvo + "): " + string(_npc_id_alvo));
            if (_npc_id_alvo == undefined) {
                show_debug_message("  -> BARRADA: sorteio não achou ninguém");
                continue;
            }
        }

        // filtro 3
        if (mission_ja_ativa(_npc_id_alvo, _md.id)) {
            show_debug_message("  -> BARRADA: já ativa para esse NPC");
            continue;
        }

        show_debug_message("  -> CRIADA para " + _npc_id_alvo);

        var _instancia = {
            instance_id: string(irandom(999999)) + "_" + _md.id,
            mission_id: _md.id,
            npc_id: _npc_id_alvo,
            status: "pendente",
            etapa: "pedido",
            grau_atual: 0,
            mes_criacao: _mes,
            mes_ultima_interacao: _mes
        };

        array_push(active_missions, _instancia);
    }
}













// verificar se uma missão já não está ativa, para a aleatoriedade
function mission_ja_ativa(_npc_id, _mission_id) {
	
    var _ativas = active_missions;
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
    var _ativas = active_missions;
	show_debug_message("resolver chamado")

    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id != _instance_id) continue;

        var _instancia = _ativas[i];
        var _md = mission_data_get(_instancia.mission_id);
        var _opcao = _md.opcoes[_indice_opcao];

		
        if (_md.tipo_resolucao == "escolha_livre") {
            
			if (variable_struct_exists(_opcao, "correta")) {
				
				if (_opcao.correta == 1) { // ACERTOU!!
					show_debug_message("Resposta correta, será realizado alguns efeitos agora")
					// aí bota a execução de efeitos nos status
				
				} else { // ERROU!!
					show_debug_message("Resposta incorreta, perdeu status!")
					
				}
				
				
			} else { // OPÇÃO ALTERNATICA
				// se não tem a opção "correta" então deve ter efeito ou ação.
				show_debug_message(_opcao)
				
				if (variable_struct_exists(_opcao.efeito, "dinheiro")) {
				
					// faça ele perder o dinheiro aqui
					show_debug_message("Você perdeu");
					show_debug_message(_opcao.efeito.dinheiro);
				
				} else {
					
					dialogoManager_UI.fechar() // bem básico, funciona só pra opção ignorar
					dialogoManager_UI.opcao_selecionada = 0
					break;
				}// adicionar sobre os outros status depois, posso até levar pro gameManager
				
				
			}
			
        }

        _instancia.status = "resolvida";
        array_push(mission_history, _instancia);
        array_delete(_ativas, i, 1);
		dialogoManager_UI.opcao_selecionada = 0
        return;
    }
}






function mission_resolver_direto(_instance_id) {
    var _ativas = missionManager.active_missions;
    for (var i = 0; i < array_length(_ativas); i++) {
        if (_ativas[i].instance_id != _instance_id) continue;
        _ativas[i].status = "resolvida";
        array_push(missionManager.mission_history, _ativas[i]);
        array_delete(_ativas, i, 1);
        return;
    }
}







// processar postergação de missão em passagem de mês
function mission_processar_fim_de_mes(_mes_atual) {
    var _ativas = active_missions;

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
            array_push(mission_history, _instancia);
            array_delete(_ativas, i, 1);
        }
    }

    mission_sortear_para_mes(_mes_atual + 1);
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





function tratar_escolha_pedido(_opcs) {
}