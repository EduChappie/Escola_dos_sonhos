raio   = 80;      // raio do círculo (em pixels da GUI)
margem = 20;      // distância da borda da tela
escala = 0.12;    // zoom do mapa (maior = mais perto)

cor_layout = make_color_rgb(150, 150, 150);   // cinza do layout
inverter   = false;  // false = paredes em cinza | true = chão em cinza

layout_surf = -1;
mask_surf   = -1;
surf        = -1;

mm_cx = 0;   // centro do círculo na GUI (calculado no Draw)
mm_cy = 0;

// desenha o layout inteiro da sala (roda só quando a superfície não existe)
function layout_garantir() {
    if (surface_exists(layout_surf)) return;

    // pega o tilemap da layer "paredes"
    var _layer = layer_get_id("paredes");
    var _tm    = layer_tilemap_get_id(_layer);

    if (_tm == -1) {
        show_debug_message("MINIMAPA: layer 'paredes' sem tilemap!");
        return;
    }

    layout_surf = surface_create(ceil(room_width * escala), ceil(room_height * escala));

    surface_set_target(layout_surf);
    draw_clear(inverter ? cor_layout : c_black);
    draw_set_color(inverter ? c_black : cor_layout);

    var _tw = tilemap_get_tile_width(_tm);
    var _th = tilemap_get_tile_height(_tm);
    var _ox = tilemap_get_x(_tm);
    var _oy = tilemap_get_y(_tm);

    for (var cy = 0; cy < tilemap_get_height(_tm); cy++) {
        for (var cx = 0; cx < tilemap_get_width(_tm); cx++) {
            if (tilemap_get(_tm, cx, cy) == 0) continue;   // tile vazio

            var _x = (_ox + cx * _tw) * escala;
            var _y = (_oy + cy * _th) * escala;
            // o ceil evita frestas entre os tiles em escala pequena
            draw_rectangle(_x, _y, _x + ceil(_tw * escala), _y + ceil(_th * escala), false);
        }
    }

    surface_reset_target();
    draw_set_color(c_white);
}





// máscara: círculo opaco, resto transparente
function mask_garantir() {
    if (surface_exists(mask_surf)) return;
    mask_surf = surface_create(raio * 2, raio * 2);
    surface_set_target(mask_surf);
    draw_clear_alpha(c_black, 0);
    draw_set_color(c_white);
    draw_circle(raio, raio, raio, false);
    surface_reset_target();
}

// desenha um ponto relativo ao player; se estiver fora do círculo, gruda na borda
function mm_ponto(_wx, _wy, _cor, _tam) {
    var _dx = (_wx - obj_player.x) * escala;
    var _dy = (_wy - obj_player.y) * escala;
    var _dist = point_distance(0, 0, _dx, _dy);
    var _lim  = raio - 4;
    if (_dist > _lim) {
        _dx *= _lim / _dist;
        _dy *= _lim / _dist;
    }
    draw_set_color(c_black);
    draw_circle(mm_cx + _dx, mm_cy + _dy, _tam + 1, false);   // contorno
    draw_set_color(_cor);
    draw_circle(mm_cx + _dx, mm_cy + _dy, _tam, false);
}