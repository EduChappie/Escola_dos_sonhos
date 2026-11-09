if (!instance_exists(obj_player)) exit;

layout_garantir();
mask_garantir();
if (!surface_exists(surf)) surf = surface_create(raio * 2, raio * 2);

// posição no canto superior direito
mm_cx = display_get_gui_width() - raio - margem;
mm_cy = raio + margem;

// 1) recorta o layout em volta do player e aplica a máscara redonda
surface_set_target(surf);
    draw_clear(c_black);
    draw_surface(layout_surf, raio - obj_player.x * escala, raio - obj_player.y * escala);

    gpu_set_blendmode_ext(bm_zero, bm_src_alpha);   // mantém só o que está dentro do círculo
    draw_surface(mask_surf, 0, 0);
    gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface_ext(surf, mm_cx - raio, mm_cy - raio, 1, 1, 0, c_white, 0.9);

// 2) borda do círculo
draw_set_color(c_white);
draw_circle(mm_cx, mm_cy, raio, true);
draw_circle(mm_cx, mm_cy, raio - 1, true);

// 3) NPCs que têm missão (amarelo)
var _ids = variable_struct_get_names(NPCManager.instancias);
for (var i = 0; i < array_length(_ids); i++) {
    var _inst = NPCManager.instancias[$ _ids[i]];
    if (!instance_exists(_inst)) continue;

    var _m = missionManager.missao_pendente_de(_ids[i]);
    if (_m != undefined && _m.etapa != "buscando") {
        mm_ponto(_inst.x, _inst.y, c_yellow, 4);
    }
}

// 4) pontos de busca das missões aceitas (vermelho pulsante)
var _ativas = missionManager.active_missions;
for (var i = 0; i < array_length(_ativas); i++) {
    var _a = _ativas[i];
    if (_a.status != "pendente" || _a.etapa != "buscando") continue;

    var _md = missionManager.mission_data_get(_a.mission_id);
    var _p  = _md.ponto_busca;
    mm_ponto(_p.x + _p.w / 2, _p.y + _p.h / 2, c_red, 4 + sin(current_time / 150));
}

// 5) player no centro
draw_set_color(c_black);
draw_circle(mm_cx, mm_cy, 5, false);
draw_set_color(c_aqua);
draw_circle(mm_cx, mm_cy, 4, false);

draw_set_color(c_white);