// ===== CONFIGURAÇÕES (mexa aqui) =====
sala_jogo      = Escola;   // room do jogo (nome do seu asset)
tempo_historia = 5;        // segundos que a história fica na tela
tempo_fade     = 1;        // segundos de fade in/out do texto
max_chars      = 20;       // limite de letras de cada nome

historia = "Você acaba de assumir uma escola que precisa de ajuda.\n\nCom a sua ajuda, vamos transformá-la em uma referência.";

// ===== DADOS SALVOS =====
global.nome_diretor = "";
global.nome_escola  = "";

// ===== CONTROLE =====
estado    = 0;      // 0 = história | 1 = perguntas
timer     = 0;
alpha     = 0;
campo     = 0;      // 0 = nome do diretor | 1 = nome da escola
nome_diretor = "";
nome_escola  = "";
iniciando = false;
keyboard_string = "";

// ===== TEMA (mesmo do menu) =====
cor_madeira = make_color_rgb(110, 70, 35);
cor_quadro  = make_color_rgb(34, 60, 48);
cor_hover   = make_color_rgb(48, 82, 66);
cor_giz     = make_color_rgb(240, 240, 230);
cor_giz_am  = make_color_rgb(250, 225, 120);
margem = 30;

// ===== LAYOUT (em coordenadas da GUI) =====
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

caixa_w = 460;
caixa_h = 54;

campos = [
    { x1: _cx - caixa_w/2, y1: _gh * 0.40, x2: _cx + caixa_w/2, y2: _gh * 0.40 + caixa_h },
    { x1: _cx - caixa_w/2, y1: _gh * 0.60, x2: _cx + caixa_w/2, y2: _gh * 0.60 + caixa_h }
];

botao = { x1: _cx - 140, y1: _gh * 0.78, x2: _cx + 140, y2: _gh * 0.78 + 60 };

// ===== FUNÇÕES =====
function selecionar_campo(_n) {
    campo = _n;
    keyboard_string = (_n == 0) ? nome_diretor : nome_escola;
}

function pode_continuar() {
    return (string_length(string_trim(nome_diretor)) > 0
         && string_length(string_trim(nome_escola))  > 0);
}

function continuar() {
    if (iniciando || !pode_continuar()) return;
    iniciando = true;

    // salva os dados
    global.nome_diretor = string_trim(nome_diretor);
    global.nome_escola  = string_trim(nome_escola);

    // fecha o círculo e abre o jogo
    var t = instance_create_depth(0, 0, -10000, obj_transicao);
    t.velocidade   = 20;
    t.sala_destino = sala_jogo;
}