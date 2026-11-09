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
var y0      = room_height / 2 + 80;

// Cada botão guarda seu texto e sua área (retângulo)
botoes = [
    { texto: "Jogar", x1: cx - largura/2, y1: 300, x2: cx + largura/2, y2: 300 + altura },
    { texto: "Sair",  x1: cx - largura/2, y1: 380, x2: cx + largura/2, y2: 380 + altura }
];

// Guarda qual botão o mouse está em cima (-1 = nenhum)
hover = -1;