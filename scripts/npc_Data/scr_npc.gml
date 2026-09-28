/// scr_npc.gml
/// Funções reais para os objetos interagíveis do mundo.
/// Cada obj_npc_* só precisa chamar estas funções nos seus eventos.

// ---------------------------------------------------------------
// obj_npc_zelador
// ---------------------------------------------------------------
function npc_zelador_create() {
    quest_index = 0; // global.quest_data[0] -> Missão 1
}

function npc_zelador_step() {
    npc_check_interaction(quest_index);
}

// ---------------------------------------------------------------
// obj_npc_professor
// ---------------------------------------------------------------
function npc_professor_create() {
    quest_index = 1; // global.quest_data[1] -> Missão 2
}

function npc_professor_step() {
    npc_check_interaction(quest_index);
}

// ---------------------------------------------------------------
// obj_mesa_quebrada
// ---------------------------------------------------------------
function mesa_quebrada_create() {
    quest_index = 2; // global.quest_data[2] -> Missão 3
    mesa_atualizar_sprite();
}

function mesa_quebrada_step() {
    npc_check_interaction(quest_index);
    mesa_atualizar_sprite();
}

function mesa_atualizar_sprite() {
    if (global.mesa_sala1_quebrada) {
        if (sprite_index != spr_mesa_quebrada) sprite_index = spr_mesa_quebrada;
    } else {
        if (sprite_index != spr_mesa_normal) sprite_index = spr_mesa_normal;
    }
}

// ---------------------------------------------------------------
// Função genérica de interação, usada por todos os NPCs acima.
// Troque a condição de distância/tecla pelo seu sistema de input real.
// ---------------------------------------------------------------
function npc_check_interaction(_quest_index) {
    if (!instance_exists(obj_player)) return;

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);

    if (_dist < 32 && keyboard_check_pressed(vk_space)) {
        quest_open_dialog(_quest_index);
    }
}
