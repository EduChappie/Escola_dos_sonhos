var _fps = game_get_speed(gamespeed_fps);

// ================= ESTADO 0: HISTÓRIA =================
if (estado == 0) {
    timer++;
    var _t = timer / _fps;   // tempo em segundos

    if (_t < tempo_fade) {
        alpha = _t / tempo_fade;                          // aparece
    } else if (_t > tempo_historia - tempo_fade) {
        alpha = (tempo_historia - _t) / tempo_fade;       // some
    } else {
        alpha = 1;
    }

    if (_t >= tempo_historia) {
        estado = 1;
        alpha  = 0;
        selecionar_campo(0);
    }
}

// ================= ESTADO 1: PERGUNTAS =================
else if (estado == 1) {
    alpha = min(1, alpha + 0.03);   // fade in da tela de perguntas

    if (!iniciando) {
        // mouse (em coordenadas da GUI)
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);

        if (mouse_check_button_pressed(mb_left)) {
            for (var i = 0; i < 2; i++) {
                var _c = campos[i];
                if (point_in_rectangle(_mx, _my, _c.x1, _c.y1, _c.x2, _c.y2)) selecionar_campo(i);
            }
            if (point_in_rectangle(_mx, _my, botao.x1, botao.y1, botao.x2, botao.y2)) continuar();
        }

        // teclado: Tab alterna entre os campos
        if (keyboard_check_pressed(vk_tab)) selecionar_campo(1 - campo);

        // texto digitado
        keyboard_string = string_copy(keyboard_string, 1, max_chars);
        if (campo == 0) nome_diretor = keyboard_string;
        else            nome_escola  = keyboard_string;

        // Enter: vai para o próximo campo e, no último, continua
        if (keyboard_check_pressed(vk_enter)) {
            if (campo == 0) selecionar_campo(1);
            else            continuar();
        }
    }
}