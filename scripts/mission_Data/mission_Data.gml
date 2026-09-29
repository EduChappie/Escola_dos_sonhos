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
			
			ponto_busca: { sala: "almoxarifado", x: 71, y: 601, w: 153, h: 649 },
			
			efeito_entrega: { felicidade: +2, infraestrutra: +5 },
			
			
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "demitir o professor" }
			]
        },
		// missão 3 - A Limpeza e Manutenção (Zelador)
		{
            id: "zelador_limpeza_patio",
            titulo: "A Limpeza e Manutenção",
            tipo_npc_alvo: "zelador",
            npc_id_especifico: undefined, //caso a missão não tenha, tipo específico, bote undefined
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Diretor, acumulou muito lixo reciclável no pátio e preciso de ajuda para organizar o descarte correto. Qual desses materiais vai na lixeira AZUL de reciclagem?",


			tipo_missao: "dialogo",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",


            opcoes: [
                { texto: "Não sei, contrate alguém pra resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

				{ texto: "Folha de papel usada", correta: true },
				{ texto: "Restos de comida", correta: false },
				{ texto: "Pilha usada", correta: false },
				{ texto: "Vidro quebrado", correta: false },

				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, satisfacao_alunos: -5 },
                {grau: 2, satisfacao_professores: -5 },
                {grau: 3, infraestrutura: -5 }
			]
        },

		// missão 4 - O Material Didático de Matemática (Professor)
		{
            id: "professor_material_matematica",
            titulo: "O Material Didático de Matemática",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined, //caso a missão não tenha, tipo específico, bote undefined
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Diretor, preciso de novos jogos pedagógicos para a aula, mas o orçamento da matéria está curto. Se uma turma tem 32 alunos e serão formados grupos de 4, quantos grupos serão criados?",


			tipo_missao: "dialogo",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",


            opcoes: [
                { texto: "Não sei, tome dinheiro e resolva você mesmo! (- R$ 80,00)", efeito: { dinheiro: -80 } },

				{ texto: "8", correta: true },
				{ texto: "6", correta: false },
				{ texto: "7", correta: false },
				{ texto: "9", correta: false },

				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, satisfacao_professores: -3 },
                {grau: 2, desempenho_escolar: -3 },
                {grau: 3, desempenho_escolar: -5 }
			]
        },

		// missão 5 - A Carteira Quebrada na Sala 1 (Estrutura)
		{
            id: "estrutura_carteira_quebrada_sala1",
            titulo: "A Carteira Quebrada na Sala 1",
            tipo_npc_alvo: "estrutura",
            npc_id_especifico: undefined, //caso a missão não tenha, tipo específico, bote undefined
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Uma mesa quebrada na sala principal impede um aluno de sentar adequadamente. Qual é a forma correta de lidar com um móvel de madeira quebrado de forma sustentável?",


			tipo_missao: "dialogo",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",


            opcoes: [
                { texto: "Não sei, contrate alguém pra resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

				{ texto: "Restaurar/reparar a peça danificada", correta: true },
				{ texto: "Queimar no pátio", correta: false },
				{ texto: "Jogar no lixo comum", correta: false },
				{ texto: "Deixar do jeito que está", correta: false },

				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, satisfacao_alunos: -5 },
                {grau: 2, infraestrutura: -5 },
                {grau: 3, infraestrutura: -8, evento_critico: "mesa permanece visivelmente quebrada" }
			]
        },

	]
}

	
