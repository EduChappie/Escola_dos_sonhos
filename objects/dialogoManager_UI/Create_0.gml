estado = "fechado";       // "fechado" | "mostrando_texto" | "mostrando_opcoes"
missao_atual = undefined; // guarda a MissionInstance que está sendo exibida
opcao_selecionada = 0;
npc_da_conversa = noone;

aviso = "";
aviso_timer = 0;



// variável do balão
ballon = ballon_talking


// ===== BALÃO "APERTE E" (fica na cabeça do player quando ele pode interagir) =====
// Para mexer na posição: balao_acao_dx / balao_acao_dy
//   dx = deslocamento horizontal em relação ao x do player (negativo = esquerda)
//   dy = deslocamento vertical   em relação ao y do player (negativo = para cima)
// O sprite ballon_action tem 16x16 e origem no canto superior esquerdo,
// por isso dx = -8 centraliza o balão no player.
balao_acao    = ballon_action
balao_acao_dx = -8
balao_acao_dy = -40





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
    var _resolveu = missionManager.mission_resolver(missao_atual.instance_id, _indice);

    // se não resolveu (ex.: dinheiro insuficiente), o diálogo continua aberto
    // e o aviso aparece na tela. "Ignorar" também devolve true e fecha normalmente.
    if (_resolveu) fechar();
}


function draw_caixa_base() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    var _largura = _gw * 0.6;      // 60% da largura da tela
    var _altura  = 210;            // altura fixa, enxuta
    var _x = (_gw - _largura) / 2; // centralizada
    var _y = _gh - _altura - 200;   // colada embaixo, com margem

    draw_sprite_stretched(spr_caixa_verde, 0, _x, _y, _largura, _altura);

    // devolve a área útil pro texto usar
    return { x: _x, y: _y, w: _largura, h: _altura };
}






// Só liga o aviso. Quem desenha é o Draw_64 (vermelho, no topo da tela).
// (Antes esta função tinha código de desenho copiado da draw_caixa_base,
//  que lia _gw/_gh inexistentes e travava o jogo ao faltar dinheiro.)
function mostrar_aviso(_texto) {
    aviso = _texto;
    aviso_timer = 120;   // ~2 segundos a 60 fps
}
