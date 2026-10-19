if (estado == "fechado") {
    // não desenha nada
}



else if (estado == "texto_simples") {
	
	var _c = draw_caixa_base();
	var _pad = 32;
	
	draw_set_colour(c_white)
	
    draw_text_ext(_c.x + _pad, _c.y + _pad, texto_simples, 20, _c.w - _pad * 2);
	
	draw_set_halign(fa_right);
    draw_text(_c.x + _c.w - _pad, _c.y + _c.h - 44, "[Espaço para continuar]");
    draw_set_halign(fa_left);
}



else if (estado == "mostrando_texto_busca") {
    
	
	var _md = missionManager.mission_data_get(missao_atual.mission_id);
	var _c = draw_caixa_base();
	var _pad = 32;
	
	draw_set_colour(c_white)
	
	
    if (missao_atual.etapa == "pedido") {
		draw_text_ext(_c.x + _pad, _c.y + _pad, _md.texto_pedido, 20, _c.w - _pad * 2);
    }
    else if (missao_atual.etapa == "buscando") {
        draw_text_ext(_c.x + _pad, _c.y + _pad, _md.texto_aguardando, 20, _c.w - _pad * 2);
    }
    else if (missao_atual.etapa == "pronta_para_entregar") {
        draw_text_ext(_c.x + _pad, _c.y + _pad, _md.texto_entrega, 20, _c.w - _pad * 2);
    }

    draw_set_halign(fa_right);
    draw_text(_c.x + _c.w - _pad, _c.y + _c.h - 44, "[Espaço para continuar]");
    draw_set_halign(fa_left);
}



else if (estado == "mostrando_texto") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    var _c = draw_caixa_base();
	var _pad = 32
	
	draw_set_colour(c_white)
	
    draw_text_ext(_c.x + _pad, _c.y + _pad, _md.texto, 20, _c.w - _pad * 2);
    
	
	draw_set_halign(fa_right);
    draw_text(_c.x + _c.w - _pad, _c.y + _c.h - 44, "[Espaço para continuar]");
    draw_set_halign(fa_left);
}





else if (estado == "mostrando_opcoes") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
	var _c = draw_caixa_base();
	var _pad = 32;
	
	draw_set_colour(c_white);

    for (var i = 0; i < array_length(_md.opcoes); i++) {
        var _y = _c.y + _pad + (i * 24);
        var _selecionada = (i == opcao_selecionada);

        draw_set_color(_selecionada ? c_yellow : c_white);
        var _prefixo = _selecionada ? "> " : "  ";
        draw_text(_c.x + _pad, _y, _prefixo + _md.opcoes[i].texto);
    }
    draw_set_color(c_white);
}



else if (estado == "mostrando_opcoes_busca") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    var _c = draw_caixa_base();
	var _pad = 32;

    for (var i = 0; i < array_length(_md.opcoes_pedido); i++) {
        var _y = _c.y + _pad + (i * 24);
        var _selecionada = (i == opcao_selecionada);

        draw_set_color(_selecionada ? c_yellow : c_white);
        var _prefixo = _selecionada ? "> " : "  ";
        draw_text(_c.x + _pad, _y, _prefixo + _md.opcoes_pedido[i].texto);
    }
    draw_set_color(c_white);
}