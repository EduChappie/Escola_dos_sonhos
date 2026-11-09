
function mission_Data() {
    return [

        // Missão 1
        {
            id: "gilson_formula_da_agua",
            titulo: "Fórmula Química da Água",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Bom dia, diretor! Preciso de uma ajuda. Qual é mesmo a fórmula química da água?",

            tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
                { texto: "Não sei. Tome o dinheiro e descubra! (- R$ 150,00)", efeito: { dinheiro: -150 } },

                { texto: "H2O", correta: true, efeito: { dinheiro: +150 } },
                { texto: "HNO3", correta: false, efeito: { felicidade: -10 } },
                { texto: "H3", correta: false, efeito: { felicidade: -10 } },
                { texto: "H2SO4", correta: false, efeito: { felicidade: -10 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade: -20 },
                { grau: 2, dinheiro: -400 },
                { grau: 3, evento_critico: "demitir o professor" }
            ]
        },

        // Missão 2
        {
            id: "gilson_giz_a_proucura",
            titulo: "À Procura de Giz",
            tipo_npc_alvo: "professor",

            npc_id_especifico: "prof_fernanda",
            meses_disponiveis: [0],
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Não. Compre você mesmo! (- R$ 350,00)", efeito: { dinheiro: -350 }, resolver_direto: true },

                { texto: "Deixe isso comigo!", correta: true, efeito: { felicidade: +2, infraestrutura: +5 } },

                { texto: "Deixe para a próxima.", efeito: { acao: "fechar" } },
            ],

            tipo_missao: "busca",
            tipo_resolucao: "escolha_livre",

            texto_pedido: "Preciso de giz novo. Há uma caixa no almoxarifado. Você poderia buscá-la para mim?",
            texto_aguardando: "Já foi buscar o giz?",
            texto_entrega: "Perfeito! Muito obrigado pela ajuda!",

            ponto_busca: { sala: "almoxarifado", x: 71, y: 601, w: 50, h: 50 },

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade: -1 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "demitir o professor" }
            ]
        },

        // Missão 3 - A Limpeza e Manutenção (Zelador)
        {
            id: "zelador_limpeza_patio",
            titulo: "A Limpeza e Manutenção",
            tipo_npc_alvo: "zelador",
            npc_id_especifico: undefined,
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Diretor, há muito lixo reciclável acumulado no pátio, e preciso de ajuda para organizar o descarte correto. Qual destes materiais deve ser colocado na lixeira AZUL?",

            tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
                { texto: "Não sei. Contrate alguém para resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "Folha de papel usada", correta: true, efeito: { dinheiro: +80 } },
                { texto: "Restos de comida", correta: false, efeito: { dinheiro: -120 } },
                { texto: "Pilha usada", correta: false, efeito: { dinheiro: -120 } },
                { texto: "Vidro quebrado", correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, satisfacao_alunos: -5 },
                { grau: 2, satisfacao_professores: -5 },
                { grau: 3, infraestrutura: -5 }
            ]
        },

        // Missão 4 - O Material Didático de Matemática (Professor)
        {
            id: "professor_material_matematica",
            titulo: "O Material Didático de Matemática",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Diretor, preciso de novos jogos pedagógicos para a aula, mas o orçamento da disciplina está apertado. Se uma turma tem 32 alunos e serão formados grupos de 4, quantos grupos serão criados?",

            tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
                { texto: "Não sei. Tome o dinheiro e resolva você mesmo! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "8", correta: true, efeito: { dinheiro: +80 } },
                { texto: "6", correta: false, efeito: { dinheiro: -120 } },
                { texto: "7", correta: false, efeito: { dinheiro: -120 } },
                { texto: "9", correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, satisfacao_professores: -3 },
                { grau: 2, desempenho_escolar: -3 },
                { grau: 3, desempenho_escolar: -5 }
            ]
        },

        // Missão 5 - A Carteira Quebrada na Sala 1 (Estrutura)
        {
            id: "estrutura_carteira_quebrada_sala1",
            titulo: "A Carteira Quebrada na Sala 1",
            tipo_npc_alvo: "estrutura",
            npc_id_especifico: undefined,
            meses_disponiveis: [0],
            peso_sorteio: 1.0,
            texto: "Uma carteira quebrada na sala de aula impede que um aluno se sente adequadamente. Qual é a maneira correta de lidar com um móvel de madeira danificado de forma sustentável?",

            tipo_missao: "dialogo",
            tipo_resolucao: "escolha_livre",

            opcoes: [
                { texto: "Não sei. Contrate alguém para resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "Restaurar ou reparar a peça danificada", correta: true, efeito: { dinheiro: +80 } },
                { texto: "Queimar no pátio", correta: false, efeito: { dinheiro: -120 } },
                { texto: "Jogar no lixo comum", correta: false, efeito: { dinheiro: -120 } },
                { texto: "Deixar do jeito que está", correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],
            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, satisfacao_alunos: -5 },
                { grau: 2, infraestrutura: -5 },
                { grau: 3, infraestrutura: -8, evento_critico: "mesa permanece visivelmente quebrada" }
            ]
        },

    ];
}
