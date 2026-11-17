// sei que o certo seria desenhar no status manager
// mas fica mais fácil o timerManager
// gerenciar todo o tempo mesmo

// no fim de mês (fades e resumo) o relógio some, para não ficar por cima da tela preta
if (gameManager.fase != "jogando") exit;

//desenhar o timer
var t =""
t += "Tempo: "
t += string(t_min)
t += ":"
if t_sec >9 {t +=""+string(t_sec)}
if t_sec <10 {t +="0"+string(t_sec)}
t +="."
t += string(t_mil)



draw_set_colour(c_white)

draw_set_halign(fa_left)//optional
draw_set_valign(fa_top)//optional


// vermelho só nos últimos 10 segundos (antes ficava vermelho em todo "x:0y", ex.: 1:05)
if (t_min == 0 && t_sec < 10) draw_set_color(c_red)


draw_text(xp,yp,t)
draw_set_color(c_white)   // não deixa o vermelho vazar para os outros desenhos da GUI