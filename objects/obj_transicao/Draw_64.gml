var w = display_get_gui_width();
var h = display_get_gui_height();

// Recria a superfície se ela não existir
if (!surface_exists(surf)) {
    surf = surface_create(w, h);
}

surface_set_target(surf);
    draw_clear(c_black);                 // tudo preto

    gpu_set_blendmode(bm_subtract);      // o círculo "fura" o preto
    draw_set_color(c_white);
    draw_circle(w / 2, h / 2, raio, false);
    gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface(surf, 0, 0);                // desenha por cima de tudo
draw_set_color(c_white);