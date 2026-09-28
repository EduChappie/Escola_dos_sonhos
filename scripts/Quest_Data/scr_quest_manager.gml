/// scr_quest_manager.gml
/// Funções reais para o obj_quest_manager (objeto persistente).
/// No Create Event do objeto, chame apenas: quest_manager_create();
/// No Step Event do objeto, chame apenas:   quest_manager_step();

function quest_manager_create() {
    // Indicadores gerais da gestão escolar
    global.dinheiro                 = 1000;
    global.reputacao                = 0;
    global.satisfacao_alunos        = 100;
    global.satisfacao_professores   = 100;
    global.indicador_infraestrutura = 100;
    global.indicador_desempenho     = 100;
    global.tempo_disponivel_mes     = 60;
    global.mesa_sala1_quebrada      = false;

    global.dia_atual         = 1;
    global.ultimo_dia_do_mes = 30;
    global.mes_ja_fechado    = false;

    quest_data_init();   // scr_quest_data.gml
    quest_system_init(); // scr_quest_system.gml
}

function quest_manager_step() {
    // Fecha o mês automaticamente quando o último dia é atingido
    if (global.dia_atual >= global.ultimo_dia_do_mes && !global.mes_ja_fechado) {
        quest_check_month_end();
        global.mes_ja_fechado = true;
    }
}

/// @desc Chame isto ao virar o dia (ex: no seu relógio/calendário de jogo)
function quest_manager_advance_day() {
    global.dia_atual += 1;

    if (global.dia_atual > global.ultimo_dia_do_mes) {
        global.dia_atual      = 1;
        global.mes_ja_fechado = false;
        quest_reset_for_new_month();
    }
}
