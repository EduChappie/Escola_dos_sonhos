if (estado == "fechado") {
    // não desenha nada
}



else if (estado == "texto_simples") {
    //draw_caixa_base();
    draw_text(120, 420, texto_simples);
    draw_text(120, 460, "[Espaço para fechar]");
}



else if (estado == "mostrando_texto_busca") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    //draw_caixa_base();

    if (missao_atual.etapa == "pedido") {
        draw_text(120, 420, _md.texto_pedido);
    }
    else if (missao_atual.etapa == "buscando") {
        draw_text(120, 420, _md.texto_aguardando);
    }
    else if (missao_atual.etapa == "pronta_para_entregar") {
        draw_text(120, 420, _md.texto_entrega);
    }

    draw_text(120, 460, "[Espaço para continuar]");
}



else if (estado == "mostrando_texto") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);

    //draw_caixa_base();
    draw_text(120, 420, _md.texto);
    draw_text(120, 460, "[Espaço para continuar]");
}





else if (estado == "mostrando_opcoes") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);

    //draw_caixa_base();

    for (var i = 0; i < array_length(_md.opcoes); i++) {
        var _y = 400 + (i * 30);
        var _cor = (i == opcao_selecionada) ? c_yellow : c_white;

        draw_set_color(_cor);
        draw_text(140, _y, _md.opcoes[i].texto);
    }
    draw_set_color(c_white);
}



else if (estado == "mostrando_opcoes_busca") {
    var _md = missionManager.mission_data_get(missao_atual.mission_id);
    //draw_caixa_base();

    for (var i = 0; i < array_length(_md.opcoes_pedido); i++) {
        var _y = 400 + (i * 30);
        var _cor = (i == opcao_selecionada) ? c_yellow : c_white;
        draw_set_color(_cor);
        draw_text(140, _y, _md.opcoes_pedido[i].texto);
    }
    draw_set_color(c_white);
}