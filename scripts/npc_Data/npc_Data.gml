// =====================================================================
//  npc_Data.gml  -  LOCAIS, PONTOS DE BUSCA e NPCs
//
//  Tudo que é "onde as coisas ficam" mora aqui, num lugar só:
//    1) local_catalog()  -> salas e corredores (retângulos da room Escola)
//    2) busca_catalog()  -> quadrados 50x50 onde o player coleta itens
//    3) npc_catalog()    -> quem são os NPCs e a ROTA de janeiro a dezembro
//
//  Para mudar uma sala de lugar, mude só em local_catalog().
//  As rotas dos NPCs usam NOMES de sala, nunca coordenadas soltas.
// =====================================================================


// ---------------------------------------------------------------------
//  1) LOCAIS
//  Cada sala = retângulo (x1,y1) canto superior esquerdo -> (x2,y2) canto
//  inferior direito, em pixels da room "Escola".
//  "pontos" são lugares nomeados onde um NPC pode ficar em pé.
//  Em sala_01 e sala_02 o meio tem mesas/cadeiras, então os pontos ficam
//  no posto do professor ou nos cantos.
// ---------------------------------------------------------------------
function local_catalog() {
    return {
        banheiro_1: { x1: 90,  y1: 119, x2: 214,  y2: 248,
            pontos: { padrao: { x: 152, y: 183 } } },

        banheiro_2: { x1: 257, y1: 116, x2: 387,  y2: 246,
            pontos: { padrao: { x: 322, y: 181 } } },

        cantina:    { x1: 833, y1: 98,  x2: 908,  y2: 132,   // área bem pequena
            pontos: { padrao: { x: 870, y: 115 } } },

        biblioteca: { x1: 1182, y1: 192, x2: 1228, y2: 212,  // área bem pequena
            pontos: { padrao: { x: 1205, y: 202 } } },

        almoxarifado: { x1: 66, y1: 605, x2: 119, y2: 662,
            pontos: { padrao: { x: 119, y: 551 } } },

        corredor:   { x1: 237, y1: 368, x2: 813,  y2: 652,
            pontos: {
                padrao: { x: 525, y: 510 },   // = centro
                centro: { x: 525, y: 510 },
                norte:  { x: 525, y: 400 },
                oeste:  { x: 290, y: 510 },
                leste:  { x: 760, y: 510 },
                sul:    { x: 480, y: 617 }
            } },

        sala_01:    { x1: 884, y1: 441, x2: 1217, y2: 665,
            pontos: {
                padrao:    { x: 991,  y: 509 },   // = professor
                professor: { x: 991,  y: 509 },
                noroeste:  { x: 895,  y: 527 },
                nordeste:  { x: 1178, y: 546 },
                sudoeste:  { x: 915,  y: 635 },
                sudeste:   { x: 1185, y: 635 }
            } },

        sala_02:    { x1: 881, y1: 738, x2: 1215, y2: 921,
            pontos: {
                padrao:    { x: 1001, y: 769 },   // = professor
                professor: { x: 1001, y: 769 },
                noroeste:  { x: 895,  y: 784 },
                nordeste:  { x: 1183, y: 768 },
                sudoeste:  { x: 911,  y: 891 },
                sudeste:   { x: 1183, y: 891 }
            } },

        diretoria:  { x1: 82,  y1: 755, x2: 488,  y2: 922,
            pontos: { padrao: { x: 285, y: 838 } } },

        entrada:    { x1: 596, y1: 941, x2: 796,  y2: 1017,
            pontos: { padrao: { x: 696, y: 979 } } },
    };
}

function local_get(_sala) {
    return local_catalog()[$ _sala];
}

// devolve {x, y} de um ponto de uma sala. Sem _slot usa o "padrao".
function local_ponto(_sala, _slot = "padrao") {
    var _l = local_get(_sala);
    if (_l == undefined) {
        show_debug_message("AVISO: local inexistente: " + string(_sala));
        return undefined;
    }
    var _p = _l.pontos[$ _slot];
    if (_p == undefined) {
        show_debug_message("AVISO: ponto '" + string(_slot) + "' não existe em " + _sala + " (usando o padrão)");
        _p = _l.pontos.padrao;
    }
    return _p;
}


// ---------------------------------------------------------------------
//  2) PONTOS DE BUSCA  (quadrados onde o player aperta E para coletar)
//  Nas missões de busca basta escrever:  ponto_busca: busca_ponto("almoxarifado")
//  x,y = canto superior esquerdo do quadrado; w,h = tamanho.
//  OBS: confira no jogo se algum quadrado cai em cima de parede/móvel.
// ---------------------------------------------------------------------
function busca_catalog() {  // onde vai ter o item pro player coletar
    return {
        almoxarifado:       { x: 68,   y: 610, w: 50, h: 50 },  // cabe a sala inteira
        corredor_noroeste:  { x: 250,  y: 380, w: 50, h: 50 },
        corredor_nordeste:  { x: 750,  y: 380, w: 50, h: 50 },
        corredor_sudoeste:  { x: 250,  y: 590, w: 50, h: 50 },
        corredor_sudeste:   { x: 750,  y: 590, w: 50, h: 50 },
        diretoria:          { x: 120,  y: 790, w: 50, h: 50 },
        banheiro_1:         { x: 110,  y: 140, w: 50, h: 50 },
        banheiro_2:         { x: 280,  y: 140, w: 50, h: 50 },
        entrada:            { x: 620,  y: 960, w: 50, h: 50 },
        cantina:            { x: 833,  y: 98,  w: 75, h: 34 },  // sala inteira
        biblioteca:         { x: 1182, y: 192, w: 46, h: 20 },  // sala inteira
    };
}

function busca_ponto(_nome) {
    var _p = busca_catalog()[$ _nome];
    if (_p == undefined) {
        show_debug_message("AVISO: ponto de busca inexistente: " + string(_nome));
        return { sala: _nome, x: 0, y: 0, w: 50, h: 50 };
    }
    return { sala: _nome, x: _p.x, y: _p.y, w: _p.w, h: _p.h };
}


// ---------------------------------------------------------------------
//  ROTAS -> AGENDA
//  Uma rota tem 12 itens (janeiro..dezembro). Cada item é:
//     "sala"          -> ponto padrão da sala
//     "sala:ponto"    -> ponto específico (ex.: "sala_01:nordeste")
//     "ausente"       -> NPC não aparece naquele mês
// ---------------------------------------------------------------------
function npc_montar_agenda(_rota) {
    if (array_length(_rota) < 12) {
        show_debug_message("AVISO: rota com menos de 12 meses (o último mês definido será repetido)");
    }

    var _agenda = [];
    for (var m = 0; m < array_length(_rota); m++) {
        var _entrada = _rota[m];

        if (_entrada == "ausente") {
            array_push(_agenda, { mes: m, sala: "ausente" });
            continue;
        }

        var _sala = _entrada;
        var _slot = "padrao";
        var _pos  = string_pos(":", _entrada);
        if (_pos > 0) {
            _sala = string_copy(_entrada, 1, _pos - 1);
            _slot = string_copy(_entrada, _pos + 1, string_length(_entrada) - _pos);
        }

        var _p = local_ponto(_sala, _slot);
        if (_p == undefined) continue;

        array_push(_agenda, { mes: m, sala: _sala, x: _p.x, y: _p.y });
    }
    return _agenda;
}


// ---------------------------------------------------------------------
//  3) NPCs
//  O "id" é o nome interno: minúsculo, sem espaço, nunca muda.
//  É ele que as missões usam em npc_id_especifico.
//                   jan  fev  mar  abr  mai  jun  jul  ago  set  out  nov  dez
// ---------------------------------------------------------------------
function npc_catalog() {
    return [
        {
            id: "prof_quimica",
            nome: "Sr. Gilson",
            tipo: "professor",
            materia: "Quimica",
            sprite: sProfessoA1_front_idle,
            afinidade: 0,
            i: 0,   // i referente a interação: 0 == nunca interagiram
            rota: [
                "sala_01:professor", "sala_01:professor", "corredor:oeste",    "sala_01:professor",
                "biblioteca",        "sala_01:professor", "cantina",           "sala_01:professor",
                "corredor:leste",    "sala_01:professor", "diretoria",         "sala_01:professor"
            ],
        },
        {
            id: "prof_historia",
            nome: "Sr. Joaquim",
            tipo: "professor",
            materia: "Historia",
            sprite: sProfessoB1_front_idle,
            afinidade: 0,
            i: 0,
            rota: [
                "sala_02:professor", "sala_02:professor", "sala_02:professor", "biblioteca",
                "sala_02:professor", "corredor:centro",   "sala_02:professor", "cantina",
                "sala_02:professor", "biblioteca",        "sala_02:professor", "diretoria"
            ],
        },
        {
            id: "zelador_rodrigo",
            nome: "Sr. Rodrigo",
            tipo: "zelador",
            materia: undefined,
            sprite: sAlunoA1_down_idle,   // sprite provisório (trocar quando existir o do zelador)
            afinidade: 0,
            i: 0,
            rota: [
                "corredor:sul",   "banheiro_1",   "almoxarifado", "corredor:centro",
                "banheiro_2",     "entrada",      "corredor:oeste", "almoxarifado",
                "cantina",        "banheiro_1",   "corredor:leste", "entrada"
            ],
        },
        {
            id: "aluno_michael",
            nome: "Sr. Michael",
            tipo: "aluno",
            materia: undefined,
            sprite: sAlunoA1_front_idle,
            afinidade: 0,
            i: 0,
            rota: [
                "sala_01:nordeste", "sala_01:nordeste", "cantina",         "sala_01:noroeste",
                "corredor:leste",   "biblioteca",       "sala_01:sudeste", "corredor:leste",
                "sala_01:nordeste", "corredor:centro",  "sala_01:sudoeste", "cantina"
            ],
        },
        {
            id: "aluno_cammy",
            nome: "Sr. Cammy",
            tipo: "aluno",
            materia: undefined,
            sprite: sAlunoB1_front_idle,
            afinidade: 0,
            i: 0,
            rota: [
                "sala_02:sudoeste", "sala_02:sudoeste", "biblioteca",      "corredor:oeste",
                "sala_02:nordeste", "cantina",          "sala_02:sudeste", "biblioteca",
                "sala_02:sudoeste", "cantina",          "corredor:sul",    "sala_02:nordeste"
            ],
        },
    ];
}
