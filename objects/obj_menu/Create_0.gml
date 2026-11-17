// =====================================================================
//  LIMPEZA PARA REINICIAR
//  Os managers abaixo são persistent: sobrevivem à troca de sala. Quando o jogo
//  volta ao Menu (botão "Jogar novamente" da tela final), eles ainda existem com
//  os dados da partida anterior. Se não forem destruídos, a room Escola cria
//  uma cópia nova de cada um e fica tudo duplicado.
//  Na primeira vez que o jogo abre não existe nenhum, então não acontece nada.
// =====================================================================
with (gameManager)       instance_destroy();
with (missionManager)    instance_destroy();
with (NPCManager)        instance_destroy();
with (timeManager)       instance_destroy();
with (statusManager_UI)  instance_destroy();
with (dialogoManager_UI) instance_destroy();


// Texto do título
titulo = "Escola dos Sonhos";

velocidade_circulo = 20;   // quanto maior, mais rápida a transição

// Cores do tema
cor_madeira = make_color_rgb(110, 70, 35);    // moldura
cor_quadro  = make_color_rgb(34, 60, 48);     // lousa
cor_borda   = make_color_rgb(20, 35, 28);     // sombra interna da moldura
cor_hover   = make_color_rgb(48, 82, 66);     // lousa mais clara ao passar o mouse
cor_giz     = make_color_rgb(240, 240, 230);  // giz branco
cor_giz_am  = make_color_rgb(250, 225, 120);  // giz amarelo

margem = 30; // espessura da moldura


// Botões
var largura = 280;
var altura  = 64;
var cx      = room_width / 2;

// Cada botão guarda seu texto e sua área (retângulo)
// OBS: a fonte Fredericka só tem letras sem acento, por isso "Opcoes".
// (Para escrever "Opções": no editor da fonte, adicione o intervalo 192-255.)
botoes = [
    { texto: "Jogar",  x1: cx - largura/2, y1: 300, x2: cx + largura/2, y2: 300 + altura },
    { texto: "Opcoes", x1: cx - largura/2, y1: 380, x2: cx + largura/2, y2: 380 + altura },
    { texto: "Sair",   x1: cx - largura/2, y1: 460, x2: cx + largura/2, y2: 460 + altura }
];

// Guarda qual botão o mouse está em cima (-1 = nenhum)
hover = -1;


// =====================================================================
//  OPÇÕES
//  Tempo de cada fase (mês), em segundos. Fica guardado em global.tempo_fase_seg
//  e o timeManager lê esse valor quando a partida começa.
// =====================================================================
tempo_min    = 30;    // menor valor do slider (segundos)
tempo_max    = 300;   // maior valor do slider (5 min)
tempo_passo  = 15;    // de quanto em quanto o slider "pula"
tempo_padrao = 60;    // valor padrão: 1 minuto

// não sobrescreve se o jogador já mexeu e voltou ao menu
if (!variable_global_exists("tempo_fase_seg")) global.tempo_fase_seg = tempo_padrao;

tela         = "menu";   // "menu" | "opcoes"
arrastando   = false;    // true enquanto o mouse segura o slider
slider_hover = false;

// trilho do slider (coordenadas da room)
slider = { x1: cx - 280, x2: cx + 280, y: 450 };

// botões da tela de opções
botoes_opcoes = [
    { texto: "Resetar", x1: cx - 260, y1: 590, x2: cx - 20,  y2: 590 + altura },
    { texto: "Voltar",  x1: cx + 20,  y1: 590, x2: cx + 260, y2: 590 + altura }
];
hover_op = -1;


// segundos -> "1:00"
function fmt_tempo(_seg) {
    var _m = _seg div 60;
    var _s = _seg mod 60;
    return string(_m) + ":" + (_s < 10 ? "0" : "") + string(_s);
}

// soma/subtrai passos do slider (_n = +1 aumenta, -1 diminui)
function tempo_ajustar(_n) {
    global.tempo_fase_seg = clamp(global.tempo_fase_seg + _n * tempo_passo, tempo_min, tempo_max);
}

// desenha um botão no estilo giz (usa a fonte que já estiver ativa)
function desenhar_botao(_b, _sobre) {
    var _cy = (_b.y1 + _b.y2) / 2;

    draw_set_color(cor_hover);
    draw_roundrect_ext(_b.x1, _b.y1, _b.x2, _b.y2, 20, 20, false);

    // Contorno duplo, parecido com traço de giz
    draw_set_color(_sobre ? cor_giz_am : cor_giz);
    draw_roundrect_ext(_b.x1,     _b.y1,     _b.x2,     _b.y2,     20, 20, true);
    draw_roundrect_ext(_b.x1 + 2, _b.y1 + 2, _b.x2 - 2, _b.y2 - 2, 18, 18, true);

    draw_text((_b.x1 + _b.x2) / 2, _cy, _b.texto);

    // Setinhas aparecem só no botão selecionado
    if (_sobre) {
        draw_text(_b.x1 + 30, _cy, ">");
        draw_text(_b.x2 - 30, _cy, "<");
    }
}
