function ui_Data() {
	return [
		{
			nome: "box_basic",
			x: 25,
			y: 25,
			sprite: box_basic,
		},
		{
			nome: "money",
			x: 50,
			y: 50,
			color: c_white,
			value: "$ "+string(gameManager.moeda)
		},
		{
			nome: "meses",
			x: 50,
			y: 100,
			color: c_white,
			value: "Mes: "+string(gameManager.meses[gameManager.mes_atual])
	
		},
		{
			nome: "felicidade",
			x: 150,
			y: 50,
			color: c_white,
			value: "Happy: "+string(gameManager.felicidade)
	
		},
		
	]
}