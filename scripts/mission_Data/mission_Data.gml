function mission_Data(){
	return [
	
		// missão 1
		{
            id: "gilson_formula_da_agua",
            titulo: "Formula Química da água",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined, //caso a missão não tenha, tipo específico, bote undefined
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Bom dia diretor... preciso de uma ajuda. Qual era a formula química da água mesmo?",
			
			
			tipo_missao: "dialogo",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",
			
			
            opcoes: [
                { texto: "Não sei, tome dinheiro e descubra! (- R$ 150,00)", efeito: { dinheiro: -150 } },
                
				{ texto: "H20", correta: true },
				{ texto: "HN03", correta: false },
				{ texto: "H3", correta: false },
				{ texto: "H2S04", correta: false },
				
				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "demitir o professor" }
			]
        },
		
		// missão 2
		{
            id: "gilson_lapis_a_proucura",
            titulo: "Formula A Proucura do Lapis",
            tipo_npc_alvo: "professor",
			
			
			
            npc_id_especifico: "prof_fernanda", //caso a missão não tenha, tipo específico, bote undefined
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
			
			
			opcoes_pedido: [
                { texto: "Não, compre você mesmo! (- R$ 350,00)", efeito: { dinheiro: -150 }, resolver_direto: true },
                
				{ texto: "Deixa isso comigo!", correta: true },
				
				{ texto: "Deixa pra próxima", efeito: { acao: "fechar" }},
            ],
			
			
			
			tipo_missao: "busca",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",
			

			
            texto_pedido: "Preciso de giz novo. Tem uma caixa no almoxarifado.",
			texto_aguardando: "Já foi buscar o giz?",
			texto_entrega: "Perfeito, obrigado!",
			
			ponto_busca: { sala: "almoxarifado", x: 71, y: 601, w: 50, h: 50 },
			
			efeito_entrega: { felicidade: +2, infraestrutra: +5 },
			
			
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "demitir o professor" }
			]
        },
		
	]
}

