function ui_Data() {
	return [
		{
			nome: "box_basic",
			x: 25,
			y: 25,
			largura: 500,
			altura: 160,
			sprite: box_basic,
		},
		{
			nome: "Dinheiro",
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
			value: "Mês: "+string(gameManager.meses[gameManager.mes_atual])
	
		},
		{
			nome: "felicidade_alunos",
			x: 200,
			y: 50,
			color: c_white,
			value: "Satisfação Alunos: "+string(gameManager.felicidade_alunos)
	
		},
		{
			nome: "felicidade_professor",
			x: 200,
			y: 75,
			color: c_white,
			value: "Satisfação Professores: "+string(gameManager.felicidade_professor)
	
		},
		
	]
}