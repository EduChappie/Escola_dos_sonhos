gpu_set_texfilter(false);

move_speed = 3
direction = 3
npc_proximo = noone;

// 0 = esquerda
// 1 = direita
// 2 = cima
// 3 = baixo


//npc_proximo = noone
//i = 0

tilemap = layer_tilemap_get_id("paredes")
block = layer_tilemap_get_id("collisionBlock")
block4 = layer_tilemap_get_id("collisionBlock_4x4")


function resetPosition() {
	x = 682
	y = 927
}