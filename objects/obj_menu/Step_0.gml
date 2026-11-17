
if (tela == "menu") {
    hover = -1;
    for (var i = 0; i < array_length(botoes); i++) {
        var b = botoes[i];
        if (point_in_rectangle(mouse_x, mouse_y, b.x1, b.y1, b.x2, b.y2)) hover = i;
    }

    if (hover != -1 && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transicao)) {
        if (hover == 0) {
            var t = instance_create_depth(0, 0, -10000, obj_transicao);
            t.velocidade   = velocidade_circulo;
            t.sala_destino = intro;
        } else if (hover == 1) {
            tela = "opcoes";
            arrastando = false;
        } else if (hover == 2) {
            game_end();
        }
    }
}
else if (tela == "opcoes") {
    hover_op = -1;
    for (var i = 0; i < array_length(botoes_opcoes); i++) {
        var b = botoes_opcoes[i];
        if (point_in_rectangle(mouse_x, mouse_y, b.x1, b.y1, b.x2, b.y2)) hover_op = i;
    }

    tempo_ajustar(keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left));
    tempo_ajustar(mouse_wheel_up() - mouse_wheel_down());
    if (keyboard_check_pressed(vk_escape)) tela = "menu";

    var _s = slider;
    var _no_slider = point_in_rectangle(mouse_x, mouse_y, _s.x1 - 24, _s.y - 28, _s.x2 + 24, _s.y + 28);
    if (mouse_check_button_pressed(mb_left) && _no_slider) arrastando = true;
    if (!mouse_check_button(mb_left)) arrastando = false;
    if (arrastando) {
        var _f = clamp((mouse_x - _s.x1) / (_s.x2 - _s.x1), 0, 1);
        var _v = tempo_min + round(_f * (tempo_max - tempo_min) / tempo_passo) * tempo_passo;
        global.tempo_fase_seg = clamp(_v, tempo_min, tempo_max);
    }
    slider_hover = _no_slider || arrastando;

    if (hover_op != -1 && !arrastando && mouse_check_button_pressed(mb_left)) {
        if (hover_op == 0) global.tempo_fase_seg = tempo_padrao;
        else tela = "menu";
    }
}