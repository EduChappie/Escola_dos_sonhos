var _hor = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _ver = keyboard_check(ord("S")) - keyboard_check(ord("W"));


// Corrigir velocidade diagonal
var _distancia = point_distance(0, 0, _hor, _ver);

if (_distancia > 0) {
    _hor /= _distancia;
    _ver /= _distancia;
}

// Movimentação
move_and_collide(
    _hor * move_speed,
    _ver * move_speed,
    [tilemap]
);
// TESTE: arredondar a posição do personagem
if (_hor != 0 || _ver != 0) {
    x = round(x);
    y = round(y);
}
// para movimentação do player
if (_hor != 0 or _ver != 0) {

	if (_ver > 0) { 
		sprite_index=sPlayer_front_walk // baixo
		direction = 3
		
	} else if (_ver < 0) {
		sprite_index=sPlayer_down_walk // cima
		direction = 2
		
	} else if (_hor	> 0) {
		sprite_index=sPlayer_side_walk // esquerda
		image_xscale=-1
		direction = 0
		
	} else if (_hor	< 0) {
		sprite_index=sPlayer_side_walk // direita
		image_xscale=1
		direction = 1
	}


} else {
	switch(direction) {
		case 0: // esquerda
		sprite_index=sPlayer_side_idle
		image_xscale=-1
		break;
		
		case 1: // direita
		sprite_index=sPlayer_side_idle
		image_xscale=1
		break;
		
		case 2: // cima
		sprite_index=sPlayer_down_idle
		break;
		
		case 3: // baixo
		sprite_index=sPlayer_front_idle
		break;
		
	}

}
// repetindo... os sprite tendem a mudar, não temos os corretos tende a mudar


var id_npc_na_zona = instance_place(x, y, objProximo);


if (id_npc_na_zona != noone) {
	//show_debug_message(id_npc_na_zona.npc_id);
	npc_proximo = NPCManager.npc_get(id_npc_na_zona.npc_id);

}
else {
    npc_proximo = noone;
	
}
