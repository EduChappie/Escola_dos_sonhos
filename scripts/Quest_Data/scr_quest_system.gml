/// scr_quest_system.gml
/// Lógica central do sistema de missões.
/// Depende de scr_quest_data.gml já ter sido executado (quest_data_init()).
///
/// Fluxo de uso típico:
///   1. NPC dispara quest_open_dialog(quest_index)  -> abre o pop-up A/B
///   2. Jogador escolhe A (aceitar) -> quest_accept(quest_index) -> mostra a pergunta
///   3. Jogador responde -> quest_answer(quest_index, indice_escolhido)
///   4. Jogador escolhe B (recusar) -> quest_refuse(quest_index)
///   5. No fim do mês, chame quest_check_month_end() para aplicar penalidades
///      de missões que ficaram "pendente" ou "recusada".

// -----------------------------------------------------------------
// ESTADO DA UI (controlado por este sistema, lido pelo obj_quest_ui)
// -----------------------------------------------------------------
// global.quest_ui_mode:
//   "none"      -> nada na tela
//   "dialog"    -> mostrando escolha A/B do NPC
//   "question"  -> mostrando a pergunta educativa
//   "result"    -> mostrando resultado (acerto/erro)

function quest_system_init() {
    global.quest_ui_mode     = "none";
    global.quest_ui_index    = -1;
    global.quest_ui_result   = "";     // "acerto" | "erro"
}

/// @desc Abre o pop-up de diálogo (A/B) de uma missão
/// @param quest_index índice em global.quest_data
function quest_open_dialog(quest_index) {
    var _q = global.quest_data[quest_index];

    if (global.quest_state[? _q.id] == "concluida") {
        show_debug_message("Missão '" + _q.titulo + "' já concluída.");
        return;
    }

    global.quest_ui_mode  = "dialog";
    global.quest_ui_index = quest_index;
}

/// @desc Opção A: jogador aceita a missão -> mostra a pergunta educativa
function quest_accept(quest_index) {
    var _q = global.quest_data[quest_index];
    global.quest_state[? _q.id] = "aceita";

    // Desconta o tempo do mês, se a missão consumir minutos (ex: Missão 2 = 4 min)
    if (_q.custo_tempo > 0) {
        global.tempo_disponivel_mes -= _q.custo_tempo;
    }

    global.quest_ui_mode  = "question";
    global.quest_ui_index = quest_index;
}

/// @desc Opção B: jogador recusa/adia a missão
function quest_refuse(quest_index) {
    var _q = global.quest_data[quest_index];
    global.quest_state[? _q.id] = "recusada";

    global.quest_ui_mode  = "none";
    global.quest_ui_index = -1;

    show_debug_message("Missão '" + _q.titulo + "' adiada.");
}

/// @desc Processa a resposta do jogador à pergunta educativa
/// @param quest_index índice em global.quest_data
/// @param resposta_index índice da alternativa escolhida pelo jogador
function quest_answer(quest_index, resposta_index) {
    var _q = global.quest_data[quest_index];

    if (resposta_index == _q.resposta_certa) {
        // ACERTOU
        global.dinheiro     += _q.recompensa_dinheiro;
        global.reputacao    += _q.recompensa_reputacao;
        global.quest_state[? _q.id] = "concluida";
        global.quest_ui_result = "acerto";

        show_debug_message("Missão '" + _q.titulo + "' concluída! +" +
            string(_q.recompensa_dinheiro) + " dinheiro, +" +
            string(_q.recompensa_reputacao) + " reputação.");
    } else {
        // ERROU -> desconta dinheiro, NÃO concede reputação, missão continua pendente
        global.dinheiro -= _q.penalidade_dinheiro;
        global.quest_state[? _q.id] = "pendente"; // pode tentar de novo depois, se for essa a regra
        global.quest_ui_result = "erro";

        show_debug_message("Resposta errada em '" + _q.titulo + "'. -" +
            string(_q.penalidade_dinheiro) + " dinheiro. Sem reputação.");
    }

    global.quest_ui_mode = "result";
}

/// @desc Fecha a UI de resultado e volta ao jogo normal
function quest_close_ui() {
    global.quest_ui_mode   = "none";
    global.quest_ui_index  = -1;
    global.quest_ui_result = "";
}

/// @desc Deve ser chamada uma vez, na virada do mês (ex: obj_calendario / obj_gerente).
/// Aplica as penalidades de qualquer missão que NÃO tenha sido concluída
/// (esteja "pendente" ou "recusada").
function quest_check_month_end() {
    for (var i = 0; i < array_length(global.quest_data); i++) {
        var _q = global.quest_data[i];
        var _status = global.quest_state[? _q.id];

        if (_status == "pendente" || _status == "recusada") {

            global.quest_state[? _q.id] = "ignorada";
            _q.ignorada = true;

            var _efeito = _q.efeito_ignorada;

            // Aplica cada efeito definido no struct de forma genérica
            if (variable_struct_exists(_efeito, "satisfacao_alunos")) {
                global.satisfacao_alunos += _efeito.satisfacao_alunos;
            }
            if (variable_struct_exists(_efeito, "satisfacao_professores")) {
                global.satisfacao_professores += _efeito.satisfacao_professores;
            }
            if (variable_struct_exists(_efeito, "infraestrutura")) {
                global.indicador_infraestrutura += _efeito.infraestrutura;
            }
            if (variable_struct_exists(_efeito, "desempenho_escolar")) {
                global.indicador_desempenho += _efeito.desempenho_escolar;
            }
            if (variable_struct_exists(_efeito, "despesa_extra")) {
                global.dinheiro -= _efeito.despesa_extra;
            }
            if (variable_struct_exists(_efeito, "visual_mesa_quebrada")) {
                global.mesa_sala1_quebrada = true; // usado pelo obj_mesa para trocar sprite
            }

            show_debug_message("Missão '" + _q.titulo + "' NÃO cumprida. Penalidades aplicadas.");
        }
    }
}

/// @desc Reseta todas as missões para "pendente" no início de um novo mês
/// (chame DEPOIS de quest_check_month_end, se quiser que as missões voltem)
function quest_reset_for_new_month() {
    for (var i = 0; i < array_length(global.quest_data); i++) {
        var _q = global.quest_data[i];
        if (global.quest_state[? _q.id] != "concluida") {
            global.quest_state[? _q.id] = "pendente";
            _q.ignorada = false;
            _q.recusada = false;
        }
    }
}
