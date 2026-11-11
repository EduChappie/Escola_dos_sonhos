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
                
				{ texto: "H20", correta: true, efeito: { dinheiro: +150} },
				{ texto: "HN03", correta: false, efeito: { felicidade: -10} },
				{ texto: "H3", correta: false, efeito: { felicidade: -10} },
				{ texto: "H2S04", correta: false, efeito: { felicidade: -10} },
				
				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -20 },
                {grau: 2, dinheiro: -400 },
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
                { texto: "Não, compre você mesmo! (- R$ 350,00)", efeito: { dinheiro: -350 }, resolver_direto: true },
                
				{ texto: "Deixa isso comigo!", correta: true, efeito: { felicidade: +2, infraestrutra: +5 } },
				
				{ texto: "Deixa pra próxima", efeito: { acao: "fechar" }},
            ],
			
			
			
			tipo_missao: "busca",   // "dialogo" / "busca"
            tipo_resolucao: "escolha_livre",
			

			
            texto_pedido: "Preciso de giz novo. Tem uma caixa no almoxarifado.",
			texto_aguardando: "Já foi buscar o giz?",
			texto_entrega: "Perfeito, obrigado!",
			
			ponto_busca: { sala: "diretoria", x: 306, y: 754, w: 50, h: 50 },
			
			
			
			
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

				{ texto: "Folha de papel usada", correta: true,  efeito: {dinheiro: +80} },
				{ texto: "Restos de comida", correta: false,     efeito: {dinheiro: -120} },
				{ texto: "Pilha usada", correta: false,          efeito: {dinheiro: -120} },
				{ texto: "Vidro quebrado", correta: false,       efeito: {dinheiro: -120} },

				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -5 },
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

				{ texto: "8", correta: true,  efeito: {dinheiro: +80}  },
				{ texto: "6", correta: false, efeito: {dinheiro: -120} },
				{ texto: "7", correta: false, efeito: {dinheiro: -120}  },
				{ texto: "9", correta: false, efeito: {dinheiro: -120}  },

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

				{ texto: "Restaurar/reparar a peça danificada", correta: true,  efeito: {dinheiro: +80}  },
				{ texto: "Queimar no pátio", correta: false, efeito: {dinheiro: -120}  },
				{ texto: "Jogar no lixo comum", correta: false, efeito: {dinheiro: -120}  },
				{ texto: "Deixar do jeito que está", correta: false, efeito: {dinheiro: -120}  },

				{ texto: "Ignorar", efeito: { acao: "fechar" }},
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -5 },
                {grau: 2, infraestrutura: -5 },
                {grau: 3, infraestrutura: -8, evento_critico: "mesa permanece visivelmente quebrada" }
			]
        },
		
				// ================= MISSÕES DE BUSCA =================

		// missão 6 - O material de limpeza (Zelador)
		{
            id: "zelador_material_limpeza",
            titulo: "O material de limpeza",
            tipo_npc_alvo: "zelador",
            npc_id_especifico: undefined,
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

			opcoes_pedido: [
				{ texto: "Pode deixar, vou buscar!", correta: true, efeito: { felicidade: +2, infraestrutura: +5 } },
				{ texto: "Estou ocupado agora.", efeito: { acao: "fechar" }},
            ],

			tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Bom dia! Estou precisando de alguns produtos de limpeza. Você poderia buscar uma caixa de materiais no depósito?",
			texto_aguardando: "Já conseguiu encontrar os materiais?",
			texto_entrega: "Muito obrigado! Agora consigo terminar a limpeza.",

			ponto_busca: { sala: "deposito", x: 71, y: 601, w: 50, h: 50 },

            grau_maximo: 1, // quanto tempo até expirar
            penalidade_por_grau: [
                {grau: 1, felicidade: -5, infraestrutura: -5,  },
                
			]
        },

		// missão 7 - Livros desaparecidos (Bibliotecária)
		{
            id: "bibliotecaria_livros_desaparecidos",
            titulo: "Livros desaparecidos",
            tipo_npc_alvo: "bibliotecaria",
            npc_id_especifico: "bibliotecaria",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

			opcoes_pedido: [
				{ texto: "Claro, vou buscar!", correta: true, efeito: { felicidade: +2, ensino: +3 } },
				{ texto: "Peça para outra pessoa.", efeito: { acao: "fechar" }},
            ],

			tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Olá! Alguns livros precisam ser devolvidos à biblioteca. Encontrei uma caixa deles na sala dos professores. Poderia buscá-la?",
			texto_aguardando: "Conseguiu encontrar os livros?",
			texto_entrega: "Excelente! Agora podemos organizar tudo novamente.",

			ponto_busca: { sala: "sala_professores", x: 306, y:754, w: 50, h: 50 }, // AJUSTAR x e y

            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, ensino: -2 },
                {grau: 3, evento_critico: "perder livros da biblioteca" }
			]
        },

		// missão 8 - O problema da cantina (Merendeira)
		{
            id: "merendeira_bandejas",
            titulo: "O problema da cantina",
            tipo_npc_alvo: "merendeira",
            npc_id_especifico: "merendeira",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

			opcoes_pedido: [
				{ texto: "Pode deixar comigo!", correta: true, efeito: { felicidade: +3, infraestrutura: +2 } },
				{ texto: "Não posso ajudar agora.", efeito: { acao: "fechar" }},
            ],

			tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Estou precisando de algumas bandejas extras para o intervalo. Existe uma caixa guardada no almoxarifado. Você poderia trazer?",
			texto_aguardando: "Já encontrou as bandejas?",
			texto_entrega: "Muito obrigada! Agora podemos atender todos os alunos.",

			ponto_busca: { sala: "almoxarifado", x: 71, y: 601, w: 50, h: 50 }, // mesmo ponto da missão do giz

            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, felicidade: -3 },
                {grau: 3, evento_critico: "reduzir a qualidade da cantina" }
			]
        },

		// missão 9 - Bolas para a educação física (Professor)
		{
            id: "professor_bolas_esportivas",
            titulo: "Bolas para a educação física",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_educacao_fisica",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

			opcoes_pedido: [
				{ texto: "Vou procurar agora!", correta: true, efeito: { felicidade: +3, infraestrutura: +2 } },
				{ texto: "Não estou disponível.", efeito: { acao: "fechar" }},
            ],

			tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Bom dia! Temos uma aula prática hoje, mas não estou encontrando as bolas esportivas. Acho que estão guardadas na sala de materiais.",
			texto_aguardando: "Conseguiu encontrar as bolas?",
			texto_entrega: "Ótimo! Agora podemos começar nossa aula.",

			ponto_busca: { sala: "sala_materiais", x: 0, y: 0, w: 50, h: 50 }, // AJUSTAR x e y

            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, felicidade: -3 },
                {grau: 3, evento_critico: "cancelar a aula prática" }
			]
        },

		// missão 10 - Equipamentos da informática (Técnico)
		{
            id: "tecnico_cabo_hdmi",
            titulo: "Equipamentos da informática",
            tipo_npc_alvo: "tecnico_informatica",
            npc_id_especifico: "tecnico_informatica",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

			opcoes_pedido: [
				{ texto: "Pode deixar, vou buscar!", correta: true, efeito: { felicidade: +2, infraestrutura: +5 } },
				{ texto: "Não tenho tempo.", efeito: { acao: "fechar" }},
            ],

			tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Estou preparando os computadores para uma apresentação, mas está faltando um cabo HDMI. Existe um guardado na secretaria. Você poderia buscá-lo?",
			texto_aguardando: "Já encontrou o cabo?",
			texto_entrega: "Perfeito! Agora podemos utilizar os equipamentos.",

			ponto_busca: { sala: "secretaria", x: 0, y: 0, w: 50, h: 50 }, // AJUSTAR x e y

            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -1 },
                {grau: 2, infraestrutura: -3 },
                {grau: 3, evento_critico: "cancelar a apresentação" }
			]
        },

		// ================= QUESTÕES (DIÁLOGO) =================

		// missão 11 - O desafio de Pitágoras (Matemática)
		{
            id: "prof_matematica_pitagoras",
            titulo: "O desafio de Pitágoras",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_matematica",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Bom dia! Estou preparando uma atividade de matemática. Você se lembra de como funciona o Teorema de Pitágoras? Em um triângulo retângulo, qual é a fórmula correta?",

			tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
				{ texto: "a² + b² = c²", correta: true,  efeito: { felicidade: +5, ensino: +5 } },
				{ texto: "a + b = c²",    correta: false, efeito: { } },
				{ texto: "a² - b² = c²",  correta: false, efeito: { } },
				{ texto: "a × b = c²",    correta: false, efeito: { } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -2 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "advertir o professor" }
			]
        },

		// missão 12 - Conhecendo os elementos (Química)
		{
            id: "prof_quimica_tabela_periodica",
            titulo: "Conhecendo os elementos",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_quimica",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Estou revisando alguns conteúdos com a turma. Você sabe qual é o símbolo químico do elemento Oxigênio?",

			tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
				{ texto: "O",  correta: true,  efeito: { felicidade: +5, ensino: +5 } },
				{ texto: "Ox", correta: false, efeito: { } },
				{ texto: "Og", correta: false, efeito: { } },
				{ texto: "H",  correta: false, efeito: { } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -2 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "prejudicar o desempenho da turma" }
			]
        },

		// missão 13 - Um pouco de história (História)
		{
            id: "prof_historia_segunda_guerra",
            titulo: "Um pouco de história",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_historia",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Estamos estudando os grandes acontecimentos do século XX. Você sabe em qual ano terminou a Segunda Guerra Mundial?",

			tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
				{ texto: "1945", correta: true,  efeito: { felicidade: +5, ensino: +5 } },
				{ texto: "1939", correta: false, efeito: { } },
				{ texto: "1918", correta: false, efeito: { } },
				{ texto: "1950", correta: false, efeito: { } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -2 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "prejudicar a aula de história" }
			]
        },

		// missão 14 - O mundo conectado (Geografia)
		{
            id: "prof_geografia_globalizacao",
            titulo: "O mundo conectado",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_geografia",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Tenho uma pergunta sobre o conteúdo da nossa última aula. O que significa globalização?",

			tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
				{ texto: "A integração econômica, cultural e social entre diferentes países.", correta: true,  efeito: { felicidade: +5, ensino: +5 } },
				{ texto: "O isolamento completo dos países.",          correta: false, efeito: { } },
				{ texto: "A diminuição da comunicação mundial.",       correta: false, efeito: { } },
				{ texto: "A proibição do comércio internacional.",     correta: false, efeito: { } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -2 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "prejudicar o desempenho da turma" }
			]
        },

		// missão 15 - Interpretando as palavras (Português)
		{
            id: "prof_portugues_metafora",
            titulo: "Interpretando as palavras",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_portugues",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Estamos estudando figuras de linguagem. Você sabe qual figura aparece na frase: 'Aquele menino é uma fera nos esportes'?",

			tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
				{ texto: "Metáfora",       correta: true,  efeito: { felicidade: +5, ensino: +5 } },
				{ texto: "Hipérbole",      correta: false, efeito: { } },
				{ texto: "Ironia",         correta: false, efeito: { } },
				{ texto: "Personificação", correta: false, efeito: { } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                {grau: 1, felicidade: -2 },
                {grau: 2, ensino: -3 },
                {grau: 3, evento_critico: "prejudicar a aula de português" }
			]
        },

	]
}

	
