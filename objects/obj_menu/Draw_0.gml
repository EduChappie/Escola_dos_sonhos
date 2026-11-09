draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = room_width / 2;

// --- Título com sublinhado de giz ---
//draw_set_font(Fredericka_titulo);
//draw_set_color(cor_giz);
//draw_text(cx, room_height * 0.25, titulo);
//draw_line_width(cx - 250, room_height * 0.25 + 60, cx + 250, room_height * 0.25 + 60, 3);


draw_set_font(Fredericka);
// --- Botões ---
for (var i = 0; i < array_length(botoes); i++) {
    var b     = botoes[i];
    var sobre = (hover == i);
    var cy    = (b.y1 + b.y2) / 2;

    // Preenchimento leve quando o mouse está em cima
    if (sobre) {
        draw_set_color(cor_hover);
        draw_roundrect_ext(b.x1, b.y1, b.x2, b.y2, 20, 20, false);
    }
	
	draw_set_color(cor_hover);
    draw_roundrect_ext(b.x1, b.y1, b.x2, b.y2, 20, 20, false);

    // Contorno duplo, parecido com traço de giz
    draw_set_color(sobre ? cor_giz_am : cor_giz);
    draw_roundrect_ext(b.x1,     b.y1,     b.x2,     b.y2,     20, 20, true);
    draw_roundrect_ext(b.x1 + 2, b.y1 + 2, b.x2 - 2, b.y2 - 2, 18, 18, true);

    // Texto
	
    draw_text((b.x1 + b.x2) / 2, cy, b.texto);

    // Setinhas aparecem só no botão selecionado
    if (sobre) {
        draw_text(b.x1 + 30, cy, ">");
        draw_text(b.x2 - 30, cy, "<");
    }
}

// Restaura o padrão
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);