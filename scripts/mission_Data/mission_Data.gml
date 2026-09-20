function mission_Data(){
	return [
		{
            id: "gilson_reagente_sumido",
            titulo: "Reagente em falta",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_gilson",
            meses_disponiveis: [3, 4],
            peso_sorteio: 1.0,
            texto: "O professor de química precisa de reagentes...",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Comprar com verba própria", efeito: { dinheiro: -150 } },
                { texto: "Ignorar", efeito: {} }
            ],
            grau_maximo: 5,
            penalidade_por_grau: [
                {grau: 2, felicidade: -1 },
                {grau: 4, ensino: -3 },
                {grau: 5, evento_critico: "sala_interditada" }
			]
        },
	]
}