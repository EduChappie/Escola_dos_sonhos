/// scr_quest_data.gml
/// Define os dados de todas as missões do jogo (Gestão Escolar).
/// Chame quest_data_init() uma única vez, no Create Event do
/// obj_quest_manager (persistente), antes de usar qualquer outra
/// função do sistema de quests.

function quest_data_init() {

    // ds_map global que guarda o ESTADO de cada missão em tempo de jogo
    // (separado dos dados fixos, para não perder progresso ao recarregar dados)
    global.quest_state = ds_map_create();

    // Array com os dados fixos (estáticos) de cada missão
    global.quest_data = [];

    // ---------------------------------------------------------------
    // MISSÃO 1 - A Limpeza e Manutenção (Zelador)
    // ---------------------------------------------------------------
    global.quest_data[0] = {
        id                : "quest_zelador_lixo",
        npc                : "Zelador",
        titulo            : "A Limpeza e Manutenção",
        contexto        : "O zelador acumulou muito lixo reciclável no pátio e precisa de ajuda para organizar o descarte correto.",
        categoria        : "Ciências / Meio Ambiente",

        // Pergunta educativa (exemplo - pode trocar por um pool de perguntas)
        pergunta        : "Qual destes materiais deve ser descartado na lixeira AZUL de reciclagem?",
        alternativas    : ["Restos de comida", "Folha de papel usada", "Pilha usada", "Vidro quebrado"],
        resposta_certa    : 1, // índice da alternativa correta (Papel = lixeira azul)

        // Custos / recompensas
        custo_tempo        : 0,      // esta missão não consome minutos do mês
        recompensa_dinheiro : 150,
        recompensa_reputacao: 5,
        penalidade_dinheiro : 80,   // se errar a questão

        // Efeitos se for IGNORADA até o fim do mês
        efeito_ignorada : {
            satisfacao_alunos      : -5,
            satisfacao_professores : -5,
            infraestrutura         : -5
        },

        // Controle de estado
        prazo_dias        : 30, // "até o fim do mês"
        concluida        : false,
        recusada        : false,
        ignorada        : false
    };

    // ---------------------------------------------------------------
    // MISSÃO 2 - O Material Didático de Matemática (Professor)
    // ---------------------------------------------------------------
    global.quest_data[1] = {
        id                : "quest_professor_matematica",
        npc                : "Professor de Matemática",
        titulo            : "O Material Didático de Matemática",
        contexto        : "O professor precisa de novos jogos pedagógicos para a aula, mas o orçamento da matéria está curto.",
        categoria        : "Matemática",

        pergunta        : "Se uma turma tem 32 alunos e serão formados grupos de 4, quantos grupos serão criados?",
        alternativas    : ["6", "7", "8", "9"],
        resposta_certa    : 2, // 32 / 4 = 8

        custo_tempo            : 4, // consome 4 minutos do mês, conforme especificado
        recompensa_dinheiro    : 150,
        recompensa_reputacao   : 5,
        penalidade_dinheiro    : 80,

        efeito_ignorada : {
            desempenho_escolar        : -5,
            satisfacao_professores    : -5
        },

        prazo_dias        : 30,
        concluida        : false,
        recusada        : false,
        ignorada        : false
    };

    // ---------------------------------------------------------------
    // MISSÃO 3 - A Carteira Quebrada na Sala 1 (Estrutura)
    // ---------------------------------------------------------------
    global.quest_data[2] = {
        id                : "quest_carteira_quebrada",
        npc                : "Estrutura (Sala 1)",
        titulo            : "A Carteira Quebrada na Sala 1",
        contexto        : "Uma mesa quebrada na sala principal impede um aluno de sentar adequadamente.",
        categoria        : "Geral / Infraestrutura",

        pergunta        : "Qual é a forma correta de descartar/consertar um móvel de madeira quebrado de forma sustentável?",
        alternativas    : ["Queimar no pátio", "Restaurar/reparar a peça danificada", "Jogar no lixo comum", "Deixar do jeito que está"],
        resposta_certa    : 1,

        custo_tempo            : 0,
        recompensa_dinheiro    : 150, // verba liberada para o conserto
        recompensa_reputacao   : 5,
        penalidade_dinheiro    : 80,

        efeito_ignorada : {
            infraestrutura            : -8,
            satisfacao_alunos        : -5,
            visual_mesa_quebrada    : true, // flag usada para trocar sprite/estado do cenário
            despesa_extra            : 50   // impacto financeiro acumulado
        },

        prazo_dias        : 30,
        concluida        : false,
        recusada        : false,
        ignorada        : false
    };

    // Inicializa o estado de cada missão no map global (status = "pendente")
    for (var i = 0; i < array_length(global.quest_data); i++) {
        var _q = global.quest_data[i];
        global.quest_state[? _q.id] = "pendente"; // pendente | aceita | concluida | recusada | ignorada
    }
}
