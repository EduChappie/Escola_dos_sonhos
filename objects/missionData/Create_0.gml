mission = [
	{
		id: "prof_quimica_reagente",
	
		titulo: "Reagente em falta",
	
		tipo_npc_alvo: "professor", // "professor" | "aluno" | "zelador" | "qualquer"
	
		npc_id_especifico: null, // se a missão é só de UM npc específico, ou null
	
		meses_disponiveis: [3, 4], // null = pode aparecer em qualquer mês
	
		peso_sorteio: 1.0, // pra controlar raridade
	
		texto: "O professor de química precisa de reagentes...",
	
		tipo_resolucao: "escolha_livre", // "escolha_livre" | "pergunta_com_certo_errado"
	
		opcoes: [
			{ texto: "Comprar com verba própria", efeito: { dinheiro: -150 } },
			{ texto: "Pedir doação (perde 1 min de gameplay)", efeito: { tempo_parado: 60 } },
			{ 
				texto: "Responder à pergunta de química",
				correta: true,
				efeito_acerto: { dinheiro: +100, ensino: +2 },
				efeito_erro: { ensino: -1 } 
			},
			{ texto: "Ignorar", efeito: {} } // ignorar sempre existe implicitamente, ver 3.2
		],
	
		grau_maximo: 5,
	
		penalidade_por_grau: { // o que acontece a cada mês sem resolver
			"2": { felicidade: -1 },
			"4": { ensino: -3, muda_sprite_sala: "spr_sala_escura" },
			"5": { evento_critico: "sala_interditada" }
		}
	},
	
]