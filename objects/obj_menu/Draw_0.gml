draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var cx = room_width / 2;

draw_set_font(Fredericka);

if (tela == "menu") {
    for (var i = 0; i < array_length(botoes); i++) desenhar_botao(botoes[i], hover == i);
}
else {
    draw_set_color(cor_giz);
    draw_text_transformed(cx, 192, "Opcoes", 1.3, 1.3, 0);
    draw_line_width(cx - 250, 252, cx + 250, 252, 3);
    draw_text_transformed(cx, 292, "Tempo de cada fase", 0.7, 0.7, 0);

    draw_set_color(cor_giz_am);
    draw_text_transformed(cx, 368, fmt_tempo(global.tempo_fase_seg), 1.8, 1.8, 0);

    var _s  = slider;
    var _f  = (global.tempo_fase_seg - tempo_min) / (tempo_max - tempo_min);
    var _kx = _s.x1 + _f * (_s.x2 - _s.x1);

    draw_set_color(cor_borda);
    draw_roundrect_ext(_s.x1, _s.y - 8, _s.x2, _s.y + 8, 16, 16, false);
    if (_kx > _s.x1 + 20) {
        draw_set_color(cor_giz_am);
        draw_roundrect_ext(_s.x1, _s.y - 8, _kx, _s.y + 8, 16, 16, false);
    }
    draw_set_color(cor_giz);
    draw_roundrect_ext(_s.x1, _s.y - 8, _s.x2, _s.y + 8, 16, 16, true);

    draw_set_font(Font_principal);
    for (var t = tempo_min; t <= tempo_max; t += tempo_passo) {
        var _tx = _s.x1 + (t - tempo_min) / (tempo_max - tempo_min) * (_s.x2 - _s.x1);
        var _maior = ((t mod 60) == 0);
        draw_set_color(cor_giz);
        draw_line_width(_tx, _s.y + 14, _tx, _s.y + (_maior ? 28 : 21), 2);
        if (_maior || t == tempo_min) draw_text(_tx, _s.y + 44, fmt_tempo(t));
    }
    draw_set_color(cor_giz);
    draw_text(cx, 545, "Padrão: " + fmt_tempo(tempo_padrao) + "   |   Arraste a barra ou use as setas  <  >");

    draw_set_color(cor_borda);
    draw_circle(_kx, _s.y, 20, false);
    draw_set_color(slider_hover ? cor_giz_am : cor_giz);
    draw_circle(_kx, _s.y, 16, false);

    draw_set_font(Fredericka);
    for (var i = 0; i < array_length(botoes_opcoes); i++) desenhar_botao(botoes_opcoes[i], hover_op == i);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);