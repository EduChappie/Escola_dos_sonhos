




// código para selecionar opção em dia
if (estado == "texto_simples" && keyboard_check_pressed(vk_space)) {
    fechar();
}

else if (estado == "mostrando_texto" && keyboard_check_pressed(vk_space)) {
    avancar_para_opcoes();
}

// ================ mostrando_opcoes
else if (estado == "mostrando_opcoes") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    var _total_opcoes = array_length(_md.opcoes);

    if (keyboard_check_pressed(vk_down)) {
        opcao_selecionada = (opcao_selecionada + 1) mod _total_opcoes;
    }
    if (keyboard_check_pressed(vk_up)) {
        opcao_selecionada = (opcao_selecionada - 1 + _total_opcoes) mod _total_opcoes;
    }
    if (keyboard_check_pressed(vk_enter)) {
		show_debug_message(opcao_selecionada)
        escolher_opcao(opcao_selecionada);
    }
}

// =================mostrando_opcoes_busca
else if (estado == "mostrando_opcoes_busca") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    var _total = array_length(_md.opcoes_pedido);

	// escolha das opções
    if (keyboard_check_pressed(vk_down)) opcao_selecionada = (opcao_selecionada + 1) mod _total;
    if (keyboard_check_pressed(vk_up))   opcao_selecionada = (opcao_selecionada - 1 + _total) mod _total;


	// tratamento após escolhas - ta errado, isso aqui é no mission manager
    if (keyboard_check_pressed(vk_enter)) {
		show_debug_message(opcao_selecionada)
        var _opcao = _md.opcoes_pedido[opcao_selecionada];

		show_debug_message("==================")
		show_debug_message(_opcao)
		show_debug_message("==================")
		// aqui ele ta comprando a opção
        if (variable_struct_exists(_opcao, "resolver_direto") && _opcao.resolver_direto==1) {
            //stats_aplicar_efeito(_opcao.efeito);
			show_debug_message("======sdfsd=======")
            missionManager.mission_resolver_direto(missao_atual.instance_id);
            fechar();
        }
        else if (variable_struct_exists(_opcao, "correta") && _opcao.correta==1) {
			show_debug_message("======aaaaaaaaaaaaa=======")
			missionManager.mission_avancar_etapa(missao_atual.instance_id, "buscando")
            estado = "mostrando_texto_busca";
			fechar()
			
        }
        else {
            fechar();   // "deixa pra próxima" -> só fecha, sem mudar nada
        }

        opcao_selecionada = 0;
    }
}




// se ele ficar muito longe, tem que sumir a tela
if (estado != "fechado" && npc_da_conversa != noone) {
    var _distancia = point_distance(obj_player.x, obj_player.y, npc_da_conversa.x, npc_da_conversa.y);

    if (_distancia > 50) {   // ajuste de alcance pra conversa
        fechar();
    }
}


// só fechar em missão de busca
if (estado == "mostrando_texto_busca" && keyboard_check_pressed(vk_space)) {
    if (missao_atual.etapa == "pedido") {
        estado = "mostrando_opcoes_busca"
    }
    else if (missao_atual.etapa == "buscando") {
        fechar();   // só fecha, continua esperando ele ir buscar
    }
    else if (missao_atual.etapa == "pronta_para_entregar") {
        //stats_aplicar_efeito(_md.efeito_entrega);
		missionManager.mission_resolver_direto(missao_atual.instance_id);
		fechar()
        
    }
}




