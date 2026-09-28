/// scr_quest_ui.gml
/// No Draw GUI Event do obj_quest_ui, chame apenas: quest_ui_draw();

function quest_ui_draw() {
    if (global.quest_ui_mode == "none") return;

    var _q  = global.quest_data[global.quest_ui_index];
    var _px = display_get_gui_width()  / 2;
    var _py = display_get_gui_height() / 2;
    var _w  = 420;
    var _h  = 220;

    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(_px - _w/2, _py - _h/2, _px + _w/2, _py + _h/2, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);

    switch (global.quest_ui_mode) {
        case "dialog":   quest_ui_draw_dialog(_q, _px, _py, _w);   break;
        case "question": quest_ui_draw_question(_q, _px, _py, _w); break;
        case "result":   quest_ui_draw_result(_q, _px, _py);       break;
    }

    draw_set_halign(fa_left);
}

function quest_ui_draw_dialog(_q, _px, _py, _w) {
    draw_text(_px, _py - 80, _q.npc + " - " + _q.titulo);
    draw_text_ext(_px, _py - 40, _q.contexto, -1, _w - 40);
    draw_text(_px - 80, _py + 60, "[A] Aceitar missão");
    draw_text(_px + 80, _py + 60, "[B] Recusar / Adiar");

    if (keyboard_check_pressed(ord("A"))) {
        quest_accept(global.quest_ui_index);
    } else if (keyboard_check_pressed(ord("B"))) {
        quest_refuse(global.quest_ui_index);
    }
}

function quest_ui_draw_question(_q, _px, _py, _w) {
    draw_text_ext(_px, _py - 80, _q.pergunta, -1, _w - 40);

    for (var i = 0; i < array_length(_q.alternativas); i++) {
        draw_text(_px, _py - 20 + (i * 20), string(i + 1) + ") " + _q.alternativas[i]);

        if (keyboard_check_pressed(ord(string(i + 1)))) {
            quest_answer(global.quest_ui_index, i);
        }
    }
}

function quest_ui_draw_result(_q, _px, _py) {
    if (global.quest_ui_result == "acerto") {
        draw_set_color(c_lime);
        draw_text(_px, _py - 20, "Resposta correta!");
        draw_set_color(c_white);
        draw_text(_px, _py + 10, "+" + string(_q.recompensa_dinheiro) + " dinheiro, +" +
            string(_q.recompensa_reputacao) + " reputação");
    } else {
        draw_set_color(c_red);
        draw_text(_px, _py - 20, "Resposta errada!");
        draw_set_color(c_white);
        draw_text(_px, _py + 10, "-" + string(_q.penalidade_dinheiro) + " dinheiro (sem reputação)");
    }

    draw_text(_px, _py + 60, "[ESPAÇO] Fechar");

    if (keyboard_check_pressed(vk_space)) {
        quest_close_ui();
    }
}
