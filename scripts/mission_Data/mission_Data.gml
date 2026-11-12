// =====================================================================
//  mission_Data.gml  -  CATÁLOGO DE MISSÕES
//
//  ------------------  OS 4 PARÂMETROS DO JOGO  ------------------
//  Todo "efeito" de missão mexe nestes parâmetros (0 a 100, começam em 50):
//
//    felicidade              -> felicidade dos ALUNOS e dos PROFESSORES (os dois)
//    felicidade_alunos       -> só a felicidade dos alunos
//    felicidade_professores  -> só a felicidade dos professores
//    ensino                  -> nível de ensino da escola
//    infraestrutura          -> estado físico da escola
//    dinheiro                -> R$ (começa em 200, +200 por mês)
//
//  REGRA DE OURO: se a situação envolve só professores, use
//  felicidade_professores; se envolve só alunos, felicidade_alunos; se é
//  algo que a escola inteira sente (limpeza, funcionários), use felicidade.
//  (Aliases antigos ainda funcionam: satisfacao_professores e desempenho_escolar.)
//
//  ----------------------------  MOLDE  ------------------------------
//  Copie um dos blocos abaixo (diálogo OU busca) e preencha.
//
//  CAMPOS COMUNS
//    id                    nome interno único, minúsculo, sem espaço
//    titulo                nome que aparece pro jogador
//    ativa                 true = pode ser sorteada | false = dormente (aguarda NPC)
//    tipo_missao           "dialogo" (pergunta) ou "busca" (ir buscar um item)
//    tipo_npc_alvo         "professor" / "zelador" / "aluno" / ... ("qualquer" serve)
//    npc_id_especifico     id de um NPC (ex.: "prof_quimica") ou undefined
//    meses_disponiveis     lista de meses, 0 = Janeiro ... 11 = Dezembro
//    peso_sorteio          1.0 normal; maior = aparece mais
//    requer_flag           (opcional) só aparece se essa flag já foi ativada
//    bloqueada_por_flag    (opcional) não aparece se essa flag estiver ativa
//    grau_maximo           quantos meses ignorada até expirar (normalmente 3)
//    penalidade_por_grau   o que acontece a cada fim de mês ignorada
//    consequencias         o que acontece NOS MESES SEGUINTES (ver abaixo)
//
//  CAMPOS DO DIÁLOGO
//    texto                 a pergunta do NPC
//    opcoes                lista de respostas:
//         correta: true   -> resultado "acertou"
//         correta: false  -> resultado "errou"
//         sem "correta"   -> resultado "pagou" (pagou pra resolver)
//         efeito: { acao: "fechar" } -> "Ignorar" (missão continua pendente)
//
//  CAMPOS DA BUSCA
//    opcoes_pedido         aceitar (correta: true), recusar (acao: "fechar") ou
//                          pagar (resolver_direto: true -> resultado "pagou")
//    texto_pedido / texto_aguardando / texto_coleta / texto_entrega
//    ponto_busca           busca_ponto("nome")  (nomes em npc_Data.gml)
//
//  CONSEQUÊNCIAS  (cada linha vale para UM resultado)
//    quando       "acertou" | "errou" | "pagou" | "expirou"
//    apos_meses   1 = no mês seguinte, 2 = daqui a dois meses ... (mínimo 1)
//    efeito       { dinheiro, felicidade, felicidade_alunos,
//                   felicidade_professores, infraestrutura, ensino }  (pode ser { })
//    evento_critico   (opcional) texto do evento
//    flag         (opcional) marca que o jogo guarda e que outras missões
//                 podem exigir (requer_flag) ou evitar (bloqueada_por_flag)
//    texto        (opcional) notícia que aparece na virada do mês
//  Resultado sem linha de consequência = sem consequência.
// =====================================================================

function mission_Data() {
    var _todos = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];   // todos os meses

    return [

        // =============================================================
        //  MISSÕES ATIVAS (NPCs já existem no jogo)
        // =============================================================

        // ---- 1. Fórmula Química da Água (DIÁLOGO / professor) --------
        // Quem sente o resultado: o professor que perguntou -> felicidade_professores
        {
            id: "gilson_formula_da_agua",
            titulo: "Fórmula Química da Água",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Bom dia diretor... preciso de uma ajuda. Qual era a fórmula química da água mesmo?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Não sei, tome dinheiro e descubra! (- R$ 150,00)", efeito: { dinheiro: -150 } },

                { texto: "H2O",   correta: true,  efeito: { dinheiro: +150 } },
                { texto: "HNO3",  correta: false, efeito: { felicidade_professores: -10 } },
                { texto: "H3",    correta: false, efeito: { felicidade_professores: -10 } },
                { texto: "H2SO4", correta: false, efeito: { felicidade_professores: -10 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -20 },
                { grau: 2, dinheiro: -400 },
                { grau: 3, evento_critico: "demitir o professor" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { felicidade_professores: +2 }, flag: "professores_respeitam_diretor",
                  texto: "Os professores comentaram que o diretor sabe do que fala." },
                { quando: "errou",   apos_meses: 1, efeito: { felicidade_professores: -2 },
                  texto: "Correu pela escola que o diretor errou uma pergunta básica." },
                { quando: "pagou",   apos_meses: 2, efeito: { dinheiro: -50 },
                  texto: "Outros professores passaram a pedir verba para resolver dúvidas simples." },
                { quando: "expirou", apos_meses: 1, efeito: { felicidade_professores: -3 },
                  texto: "O professor se sentiu ignorado e comentou isso com os colegas." },
            ]
        },

        // ---- 2. À Procura de Giz (BUSCA / professor) -----------------
        // Giz ajuda o professor -> felicidade_professores
        {
            id: "gilson_giz_a_proucura",
            titulo: "À Procura de Giz",
            ativa: true,
            tipo_missao: "busca",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,   // era "prof_fernanda" (NPC que não existe)
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Não. Compre você mesmo! (- R$ 350,00)", efeito: { dinheiro: -350 }, resolver_direto: true },
                { texto: "Deixe isso comigo!", correta: true, efeito: { felicidade_professores: +2, infraestrutura: +5 } },
                { texto: "Deixe para a próxima.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Preciso de giz novo. Há uma caixa no almoxarifado. Você poderia buscá-la para mim?",
            texto_aguardando: "Já foi buscar o giz?",
            texto_coleta: "Você pegou a caixa de giz! Volte para entregar.",
            texto_entrega: "Perfeito! Muito obrigado pela ajuda!",
            ponto_busca: busca_ponto("almoxarifado"),
            tipo_resolucao: "escolha_livre",

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -1 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "demitir o professor" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +2 },
                  texto: "Com giz novo, as aulas fluíram melhor." },
                { quando: "pagou",   apos_meses: 1, efeito: { infraestrutura: -2 },
                  texto: "O giz comprado às pressas era de má qualidade." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "Sem giz, as aulas ficaram prejudicadas." },
            ]
        },

        // ---- 3. A Limpeza e Manutenção (DIÁLOGO / zelador) -----------
        // Escola suja incomoda todo mundo -> felicidade (alunos e professores)
        {
            id: "zelador_limpeza_patio",
            titulo: "A Limpeza e Manutenção",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "zelador",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Diretor, há muito lixo reciclável acumulado no pátio, e preciso de ajuda para organizar o descarte correto. Qual destes materiais deve ser colocado na lixeira AZUL?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Não sei. Contrate alguém para resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "Folha de papel usada", correta: true,  efeito: { dinheiro: +80 } },
                { texto: "Restos de comida",     correta: false, efeito: { dinheiro: -120 } },
                { texto: "Pilha usada",          correta: false, efeito: { dinheiro: -120 } },
                { texto: "Vidro quebrado",       correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade: -5 },
                { grau: 2, felicidade_professores: -5 },
                { grau: 3, infraestrutura: -5 }
            ],
            consequencias: [
                // acertar, errar ou pagar fazem o zelador voltar a pedir ajuda no mês seguinte
                // (ativa a flag que libera "O material de limpeza"). Ignorar tudo não libera.
                { quando: "acertou", apos_meses: 1, efeito: { infraestrutura: +2, felicidade: +2 }, flag: "zelador_pediu_material",
                  texto: "O descarte correto deixou a escola mais limpa e agradável." },
                { quando: "errou",   apos_meses: 1, efeito: { infraestrutura: -2 }, flag: "zelador_pediu_material",
                  texto: "O descarte errado deixou mau cheiro e sujeira." },
                { quando: "pagou",   apos_meses: 1, efeito: { dinheiro: -40 }, flag: "zelador_pediu_material",
                  texto: "Contratar ajuda resolveu, mas o orçamento sentiu." },
                { quando: "expirou", apos_meses: 1, efeito: { infraestrutura: -3, felicidade: -2 },
                  texto: "O lixo acumulado incomodou todo mundo." },
            ]
        },

        // ---- 4. O Material Didático de Matemática (DIÁLOGO / professor)
        // Orçamento da matéria do professor -> felicidade_professores
        {
            id: "professor_material_matematica",
            titulo: "O Material Didático de Matemática",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Diretor, preciso de novos jogos pedagógicos para a aula, mas o orçamento da disciplina está apertado. Se uma turma tem 32 alunos e serão formados grupos de 4, quantos grupos serão criados?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Não sei. Tome o dinheiro e resolva você mesmo! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "8", correta: true,  efeito: { dinheiro: +80 } },
                { texto: "6", correta: false, efeito: { dinheiro: -120 } },
                { texto: "7", correta: false, efeito: { dinheiro: -120 } },
                { texto: "9", correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -3 },
                { grau: 2, ensino: -3 },
                { grau: 3, ensino: -5 }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 2, efeito: { ensino: +3 },
                  texto: "Os jogos pedagógicos melhoraram o rendimento da turma." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "Os grupos foram montados errado e a atividade virou bagunça." },
                { quando: "pagou",   apos_meses: 2, efeito: { ensino: +1 },
                  texto: "O professor comprou os jogos, mas sem muito planejamento." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "Sem os jogos, a aula de matemática ficou fraca." },
            ]
        },

        // ---- 5. A Carteira Quebrada na Sala 1 (DIÁLOGO / aluno Michael)
        // Quem sofre é o aluno -> felicidade_alunos
        {
            id: "estrutura_carteira_quebrada_sala1",
            titulo: "A Carteira Quebrada na Sala 1",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "aluno",                 // era "estrutura" (nenhum NPC tinha esse tipo)
            npc_id_especifico: "aluno_michael",     // Michael fica na Sala 1 em janeiro
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Uma carteira quebrada na sala de aula impede que um aluno se sente adequadamente. Qual é a maneira correta de lidar com um móvel de madeira danificado de forma sustentável?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Não sei. Contrate alguém para resolver! (- R$ 80,00)", efeito: { dinheiro: -80 } },

                { texto: "Restaurar ou reparar a peça danificada", correta: true,  efeito: { dinheiro: +80 } },
                { texto: "Queimar no pátio",                       correta: false, efeito: { dinheiro: -60 } },
                { texto: "Jogar no lixo comum",                    correta: false, efeito: { dinheiro: -120 } },
                { texto: "Deixar do jeito que está",               correta: false, efeito: { dinheiro: -120 } },

                { texto: "Ignorar", efeito: { acao: "fechar" } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_alunos: -5 },
                { grau: 2, infraestrutura: -5 },
                { grau: 3, infraestrutura: -8, evento_critico: "mesa permanece visivelmente quebrada" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 2, efeito: { infraestrutura: +2, felicidade_alunos: +2 },
                  texto: "A carteira foi reaproveitada e os alunos notaram o cuidado com a escola." },
                { quando: "errou",   apos_meses: 1, efeito: { infraestrutura: -5, felicidade_alunos: -5 },
                  texto: "A solução errada piorou o estado da sala." },
                { quando: "pagou",   apos_meses: 1, efeito: { infraestrutura: +1 },
                  texto: "A carteira foi trocada, mas a velha foi para o lixo." },
                { quando: "expirou", apos_meses: 1, efeito: { infraestrutura: -4, felicidade_alunos: -3 },
                  texto: "A carteira continua quebrada e os alunos reclamam." },
            ]
        },

        // ---- 6. O Material de Limpeza (BUSCA / zelador) --------------
        // Limpeza em dia agrada a escola toda -> felicidade
        // Prazo curto (grau_maximo: 1): expira já no fim do mês em que aparece.
        {
            id: "zelador_material_limpeza",
            titulo: "O Material de Limpeza",
            ativa: true,
            tipo_missao: "busca",
            tipo_npc_alvo: "zelador",
            npc_id_especifico: undefined,
            meses_disponiveis: [1, 3],
            peso_sorteio: 1.0,
            requer_flag: "zelador_pediu_material",   // só aparece depois de "A Limpeza e Manutenção"

            opcoes_pedido: [
                { texto: "Pode deixar, vou buscar!", correta: true, efeito: { felicidade: +2, infraestrutura: +5 } },
                { texto: "Estou ocupado agora.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Bom dia! Estou precisando de alguns produtos de limpeza. Você poderia buscar uma caixa de materiais no depósito?",
            texto_aguardando: "Já conseguiu encontrar os materiais?",
            texto_coleta: "Você pegou a caixa de materiais de limpeza! Volte para entregar.",
            texto_entrega: "Muito obrigado! Agora consigo terminar a limpeza.",
            ponto_busca: busca_ponto("almoxarifado"),   // o "depósito" é o almoxarifado
            tipo_resolucao: "escolha_livre",

            grau_maximo: 1,   // quanto tempo (em meses) até expirar
            penalidade_por_grau: [
                { grau: 1, felicidade: -5, infraestrutura: -5 },
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { infraestrutura: +3 },
                  texto: "Com os materiais certos, a limpeza ficou em dia." },
                { quando: "expirou", apos_meses: 1, efeito: { infraestrutura: -3 },
                  texto: "Sem materiais, a limpeza ficou atrasada." },
            ]
        },

        // ---- 7. Conhecendo os Elementos (DIÁLOGO / Gilson) -----------
        // Professor apoiado pelo diretor -> felicidade_professores
        {
            id: "prof_quimica_tabela_periodica",
            titulo: "Conhecendo os Elementos",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_quimica",
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Estou revisando alguns conteúdos com a turma. Você sabe qual é o símbolo químico do elemento Oxigênio?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "O",  correta: true,  efeito: { felicidade_professores: +5, ensino: +5 } },
                { texto: "Ox", correta: false, efeito: { } },
                { texto: "Og", correta: false, efeito: { } },
                { texto: "H",  correta: false, efeito: { } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -2 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "prejudicar o desempenho da turma" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +3 }, flag: "turma_quimica_motivada",
                  texto: "A turma de Química ficou motivada com a revisão." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "A revisão saiu confusa e a turma ficou perdida." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "Sem a revisão, a turma de Química ficou para trás." },
            ]
        },

        // ---- 8. Um Pouco de História (DIÁLOGO / Joaquim) -------------
        {
            id: "prof_historia_segunda_guerra",
            titulo: "Um Pouco de História",
            ativa: true,
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_historia",
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Estamos estudando os grandes acontecimentos do século XX. Você sabe em qual ano terminou a Segunda Guerra Mundial?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "1945", correta: true,  efeito: { felicidade_professores: +5, ensino: +5 } },
                { texto: "1939", correta: false, efeito: { } },
                { texto: "1918", correta: false, efeito: { } },
                { texto: "1950", correta: false, efeito: { } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -2 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "prejudicar a aula de história" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +3 }, flag: "turma_historia_motivada",
                  texto: "A turma de História ficou animada com a aula." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "A aula de História saiu com datas erradas." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "Sem apoio, a aula de História perdeu o ritmo." },
            ]
        },


        // =============================================================
        //  MISSÕES DORMENTES (ativa: false)
        //  Estão prontas, mas o NPC delas ainda não existe em npc_Data.
        //  Quando o NPC for criado com o id indicado, é só trocar para
        //  ativa: true.
        // =============================================================

        // ---- 9. Livros Desaparecidos (BUSCA / bibliotecária) ---------
        // Funcionária da escola: biblioteca serve a todos -> felicidade
        {
            id: "bibliotecaria_livros_desaparecidos",
            titulo: "Livros Desaparecidos",
            ativa: true,   // aguarda o NPC "bibliotecaria"
            tipo_missao: "busca",
            tipo_npc_alvo: "bibliotecaria",
            npc_id_especifico: "aluno_cammy", // personagem provisório
            meses_disponiveis: [3],
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Claro, vou buscar!", correta: true, efeito: { felicidade: +2, ensino: +3 } },
                { texto: "Peça para outra pessoa.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Olá! Alguns livros precisam ser devolvidos à biblioteca. Encontrei uma caixa deles na sala dos professores. Poderia buscá-la?",
            texto_aguardando: "Conseguiu encontrar os livros?",
            texto_coleta: "Você pegou a caixa de livros! Volte para entregar.",
            texto_entrega: "Excelente! Agora podemos organizar tudo novamente.",
            ponto_busca: busca_ponto("diretoria"),   // REVISAR: não existe "sala dos professores"
            tipo_resolucao: "escolha_livre",

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade: -1 },
                { grau: 2, ensino: -2 },
                { grau: 3, evento_critico: "perder livros da biblioteca" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +2 },
                  texto: "A biblioteca voltou a funcionar com o acervo completo." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -2 },
                  texto: "Os livros sumidos fazem falta nas pesquisas dos alunos." },
            ]
        },

        // ---- 10. O Problema da Cantina (BUSCA / merendeira) ----------
        // Cantina e intervalo: quem sente são os alunos -> felicidade_alunos
        {
            id: "merendeira_bandejas",
            titulo: "O Problema da Cantina",
            ativa: true,   // aguarda o NPC "merendeira"
            tipo_missao: "busca",
            tipo_npc_alvo: "merendeira",
            npc_id_especifico: "merendeira",
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Pode deixar comigo!", correta: true, efeito: { felicidade_alunos: +3, infraestrutura: +2 } },
                { texto: "Não posso ajudar agora.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Estou precisando de algumas bandejas extras para o intervalo. Existe uma caixa guardada no almoxarifado. Você poderia trazer?",
            texto_aguardando: "Já encontrou as bandejas?",
            texto_coleta: "Você pegou a caixa de bandejas! Volte para entregar.",
            texto_entrega: "Muito obrigada! Agora podemos atender todos os alunos.",
            ponto_busca: busca_ponto("almoxarifado"),
            tipo_resolucao: "escolha_livre",

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_alunos: -1 },
                { grau: 2, felicidade_alunos: -3 },
                { grau: 3, evento_critico: "reduzir a qualidade da cantina" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { felicidade_alunos: +2 },
                  texto: "O intervalo ficou mais organizado e os alunos gostaram." },
                { quando: "expirou", apos_meses: 1, efeito: { felicidade_alunos: -3 },
                  texto: "Faltaram bandejas e as filas na cantina ficaram enormes." },
            ]
        },

        // ---- 11. Bolas para a Educação Física (BUSCA / professor) ----
        // Aula prática: quem se diverte são os alunos -> felicidade_alunos
        {
            id: "professor_bolas_esportivas",
            titulo: "Bolas para a Educação Física",
            ativa: true,   // aguarda o NPC "prof_educacao_fisica"
            tipo_missao: "busca",
            tipo_npc_alvo: "professor",
            npc_id_especifico: "prof_educacao_fisica",
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Vou procurar agora!", correta: true, efeito: { felicidade_alunos: +3, infraestrutura: +2 } },
                { texto: "Não estou disponível.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Bom dia! Temos uma aula prática hoje, mas não estou encontrando as bolas esportivas. Acho que estão guardadas na sala de materiais.",
            texto_aguardando: "Conseguiu encontrar as bolas?",
            texto_coleta: "Você encontrou as bolas esportivas! Volte para entregar.",
            texto_entrega: "Ótimo! Agora podemos começar nossa aula.",
            ponto_busca: busca_ponto("corredor_nordeste"),   // REVISAR: não existe "sala de materiais"
            tipo_resolucao: "escolha_livre",

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_alunos: -1 },
                { grau: 2, felicidade_alunos: -3 },
                { grau: 3, evento_critico: "cancelar a aula prática" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { felicidade_alunos: +2 },
                  texto: "A aula prática foi um sucesso e os alunos se divertiram." },
                { quando: "expirou", apos_meses: 1, efeito: { felicidade_alunos: -3 },
                  texto: "Os alunos ficaram sem aula prática e reclamaram." },
            ]
        },

        // ---- 12. Equipamentos da Informática (BUSCA / técnico) -------
        // Funcionário da escola: apresentação envolve todos -> felicidade
        {
            id: "tecnico_cabo_hdmi",
            titulo: "Equipamentos da Informática",
            ativa: true,   // aguarda o NPC "tecnico_informatica"
            tipo_missao: "busca",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            opcoes_pedido: [
                { texto: "Pode deixar, vou buscar!", correta: true, efeito: { felicidade: +2, infraestrutura: +5 } },
                { texto: "Não tenho tempo.", efeito: { acao: "fechar" } },
            ],
            texto_pedido: "Estou preparando os computadores para uma apresentação, mas está faltando um cabo HDMI. Existe um guardado na secretaria. Você poderia buscá-lo?",
            texto_aguardando: "Já encontrou o cabo?",
            texto_coleta: "Você encontrou o cabo HDMI! Volte para entregar.",
            texto_entrega: "Perfeito! Agora podemos utilizar os equipamentos.",
            ponto_busca: busca_ponto("corredor_sudoeste"),   // REVISAR: não existe "secretaria"
            tipo_resolucao: "escolha_livre",

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade: -1 },
                { grau: 2, infraestrutura: -3 },
                { grau: 3, evento_critico: "cancelar a apresentação" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { infraestrutura: +2 },
                  texto: "A apresentação correu bem e mostrou a escola organizada." },
                { quando: "expirou", apos_meses: 1, efeito: { infraestrutura: -3 },
                  texto: "A apresentação foi cancelada por falta de equipamento." },
            ]
        },

        // ---- 13. O Desafio de Pitágoras (DIÁLOGO / Matemática) -------
        {
            id: "prof_matematica_pitagoras",
            titulo: "O Desafio de Pitágoras",
            ativa: true,   // aguarda o NPC "prof_matematica"
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Bom dia! Estou preparando uma atividade de matemática. Você se lembra de como funciona o Teorema de Pitágoras? Em um triângulo retângulo, qual é a fórmula correta?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "a² + b² = c²", correta: true,  efeito: { felicidade_professores: +5, ensino: +5 } },
                { texto: "a + b = c²",   correta: false, efeito: { } },
                { texto: "a² - b² = c²", correta: false, efeito: { } },
                { texto: "a × b = c²",   correta: false, efeito: { } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -2 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "advertir o professor" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +3 },
                  texto: "A atividade de matemática empolgou a turma." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "A atividade foi preparada com a fórmula errada." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "Sem apoio, a atividade de matemática foi cancelada." },
            ]
        },

        // ---- 14. O Mundo Conectado (DIÁLOGO / Geografia) -------------
        {
            id: "prof_geografia_globalizacao",
            titulo: "O Mundo Conectado",
            ativa: true,   // aguarda o NPC "prof_geografia"
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Tenho uma pergunta sobre o conteúdo da nossa última aula. O que significa globalização?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "A integração econômica, cultural e social entre diferentes países.", correta: true,  efeito: { felicidade_professores: +5, ensino: +5 } },
                { texto: "O isolamento completo dos países.",      correta: false, efeito: { } },
                { texto: "A diminuição da comunicação mundial.",   correta: false, efeito: { } },
                { texto: "A proibição do comércio internacional.", correta: false, efeito: { } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -2 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "prejudicar o desempenho da turma" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +3 },
                  texto: "A turma de Geografia entendeu bem o conceito." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "A turma de Geografia ficou com o conceito errado." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "O conteúdo de Geografia ficou sem revisão." },
            ]
        },

        // ---- 15. Interpretando as Palavras (DIÁLOGO / Português) -----
        {
            id: "prof_portugues_metafora",
            titulo: "Interpretando as Palavras",
            ativa: false,   // aguarda o NPC "prof_portugues"
            tipo_missao: "dialogo",
            tipo_npc_alvo: "professor",
            npc_id_especifico: undefined,
            meses_disponiveis: _todos,
            peso_sorteio: 1.0,

            texto: "Estamos estudando figuras de linguagem. Você sabe qual figura aparece na frase: 'Aquele menino é uma fera nos esportes'?",
            tipo_resolucao: "escolha_livre",
            opcoes: [
                { texto: "Metáfora",       correta: true,  efeito: { felicidade_professores: +5, ensino: +5 } },
                { texto: "Hipérbole",      correta: false, efeito: { } },
                { texto: "Ironia",         correta: false, efeito: { } },
                { texto: "Personificação", correta: false, efeito: { } },
            ],

            grau_maximo: 3,
            penalidade_por_grau: [
                { grau: 1, felicidade_professores: -2 },
                { grau: 2, ensino: -3 },
                { grau: 3, evento_critico: "prejudicar a aula de português" }
            ],
            consequencias: [
                { quando: "acertou", apos_meses: 1, efeito: { ensino: +3 },
                  texto: "A turma de Português se divertiu com as figuras de linguagem." },
                { quando: "errou",   apos_meses: 1, efeito: { ensino: -2 },
                  texto: "A turma de Português confundiu as figuras de linguagem." },
                { quando: "expirou", apos_meses: 1, efeito: { ensino: -3 },
                  texto: "A aula de Português ficou sem a revisão prometida." },
            ]
        },

    ];
}
