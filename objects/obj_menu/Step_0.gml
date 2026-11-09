// Descobre se o mouse está sobre algum botão
hover = -1;
for (var i = 0; i < array_length(botoes); i++) {
    var b = botoes[i];
    if (point_in_rectangle(mouse_x, mouse_y, b.x1, b.y1, b.x2, b.y2)) {
        hover = i;
    }
}

// Clique
if (hover != -1 && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transicao)) {
    if (hover == 0) {
        // Cria a transição e passa as configurações
        var t = instance_create_depth(0, 0, -10000, obj_transicao);
        t.velocidade   = velocidade_circulo;
        t.sala_destino = Escola;
    } else if (hover == 1) {
        game_end();
    }
}