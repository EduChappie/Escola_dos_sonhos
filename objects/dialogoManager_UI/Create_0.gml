estado = "fechado";       // "fechado" | "mostrando_texto" | "mostrando_opcoes"
missao_atual = undefined; // guarda a MissionInstance que está sendo exibida
opcao_selecionada = 0;
npc_da_conversa = noone;


// variável do balão
ballon = ballon_talking





function abrir(_missao, _npc_da_missao) {
    missao_atual = _missao;
	npc_da_conversa = _npc_da_missao
    var _md = missionManager.mission_data_get(_missao.mission_id);

    if (_md.tipo_missao == "dialogo") {
        estado = "mostrando_texto";
    }
    else if (_md.tipo_missao == "busca") {
        estado = "mostrando_texto_busca";
    }
}



function abrir_texto_simples(_texto, _npc_conversa) {
    missao_atual = undefined;
	npc_da_conversa = _npc_conversa
    texto_simples = _texto;
    estado = "texto_simples";
}



function avancar_para_opcoes() {
    estado = "mostrando_opcoes";
}



function fechar() {
    estado = "fechado";
    missao_atual = undefined;
}



function escolher_opcao(_indice) {
	show_debug_message("chamar resolver")
    missionManager.mission_resolver(missao_atual.instance_id, _indice);
    fechar();
}


function draw_caixa_base() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    var _largura = _gw * 0.6;      // 60% da largura da tela
    var _altura  = 210;            // altura fixa, enxuta
    var _x = (_gw - _largura) / 2; // centralizada
    var _y = _gh - _altura - 200;   // colada embaixo, com margem

    draw_sprite_stretched(spr_caixa_dialogo, 0, _x, _y, _largura, _altura);

    // devolve a área útil pro texto usar
    return { x: _x, y: _y, w: _largura, h: _altura };
}