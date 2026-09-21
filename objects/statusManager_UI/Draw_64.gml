

for (i = 0; i < array_length(ui); i++) {
	item = ui[i]
	
	// verificar se tem sprites
	if (variable_struct_exists(item, "sprite")) {
		//ÁREA SPRITE EXISTE
		
		draw_sprite(
			item.sprite,
			0,
			item.x,
			item.y
		)
		
	} else {
		//ÁREA SPRITE não EXISTE
		draw_set_colour(item.color);
		draw_text(item.x, item.y, item.value)
	}
	
}





//exibir as missões ativas no HUD (futuramente)