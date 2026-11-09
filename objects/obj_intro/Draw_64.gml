var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// --- fundo: moldura e lousa ---
draw_set_alpha(1);
draw_set_color(cor_madeira);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_color(cor_quadro);
draw_rectangle(margem, margem, _gw - margem, _gh - margem, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(alpha);

// ================= HISTÓRIA =================
if (estado == 0) {
    draw_set_font(font_normal);
    draw_set_color(cor_giz);
    draw_text_ext(_cx, _gh / 2, historia, -1, _gw * 0.7);
}

// ================= PERGUNTAS =================
else if (estado == 1) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _perguntas = ["Qual é o seu nome?", "Qual será o nome da sua nova escola?"];
    var _textos    = [nome_diretor, nome_escola];

    for (var i = 0; i < 2; i++) {
        var _c   = campos[i];
        var _sel = (campo == i);

        // pergunta
        draw_set_font(font_normal);
        draw_set_color(cor_giz);
        draw_text(_cx, _c.y1 - 28, _perguntas[i]);

        // caixa de digitação
        if (_sel) {
            draw_set_color(cor_hover);
            draw_roundrect_ext(_c.x1, _c.y1, _c.x2, _c.y2, 14, 14, false);
        }
        draw_set_color(_sel ? cor_giz_am : cor_giz);
        draw_roundrect_ext(_c.x1,     _c.y1,     _c.x2,     _c.y2,     14, 14, true);
        draw_roundrect_ext(_c.x1 + 2, _c.y1 + 2, _c.x2 - 2, _c.y2 - 2, 12, 12, true);

        // texto digitado + cursor piscando
        var _txt = _textos[i];
        if (_sel && !iniciando && (current_time div 500) mod 2 == 0) _txt += "|";
        draw_set_color(cor_giz);
        draw_text((_c.x1 + _c.x2) / 2, (_c.y1 + _c.y2) / 2, _txt);
    }

    // botão continuar (só "acende" quando os dois nomes estão preenchidos)
    var _ok    = pode_continuar();
    var _sobre = _ok && point_in_rectangle(_mx, _my, botao.x1, botao.y1, botao.x2, botao.y2);

    if (_sobre) {
        draw_set_color(cor_hover);
        draw_roundrect_ext(botao.x1, botao.y1, botao.x2, botao.y2, 20, 20, false);
    }
    draw_set_alpha(alpha * (_ok ? 1 : 0.35));
    draw_set_color(_sobre ? cor_giz_am : cor_giz);
    draw_roundrect_ext(botao.x1,     botao.y1,     botao.x2,     botao.y2,     20, 20, true);
    draw_roundrect_ext(botao.x1 + 2, botao.y1 + 2, botao.x2 - 2, botao.y2 - 2, 18, 18, true);
    draw_text((botao.x1 + botao.x2) / 2, (botao.y1 + botao.y2) / 2, "Continuar");
}

// restaura o padrão
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);