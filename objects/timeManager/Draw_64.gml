// sei que o certo seria desenhar no status manager
// mas fica mais fácil o timerManager
// gerenciar todo o tempo mesmo

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


if t_min < 1 and t_sec < 30 then draw_set_color(c_red)


draw_text(xp,yp,t)