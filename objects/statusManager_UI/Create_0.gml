// o tempo é desenhado no timeManager

ui = ui_Data();


function reset_values() {
	ui = ui_Data()	
}


depth = -1000;   // por cima de tudo, inclusive do relógio


// =====================================================================
//  RESUMO DE FIM DE MÊS (overlay desenhado por cima do jogo)
//
//  Estados:  "inativo" -> "fade_out" -> "painel" -> "fade_in" -> "inativo"
//    fade_out : a tela escurece
//    painel   : o resumo desliza da esquerda e espera o botão Continuar
//    fade_in  : o jogo do mês novo aparece
//
//  Os dados vêm do gameManager (fechar_mes devolve o "resumo").
//  A lógica roda a partir do Draw GUI (resumo_atualizar) para não precisar
//  de um evento Step novo neste objeto.
// =====================================================================
resumo_estado = "inativo";
resumo        = undefined;
fade          = 0;      // 0 = jogo visível ... 1 = tela toda preta
fade_vel      = 0.06;   // velocidade do fade (0.06 = ~0,3 s)
painel_slide  = 0;      // 0 = fora da tela (esquerda) ... 1 = no lugar
painel_t      = 0;      // frames desde que o painel abriu (anima as linhas)
hold_t        = 0;      // frames que o nome do mês fica na tela preta antes do fade in
botao         = { x: 0, y: 0, w: 0, h: 0 };   // área do botão Continuar (atualizada no desenho)


// chamado pelo gameManager quando o tempo zera
function resumo_iniciar() {
	resumo_estado = "fade_out";
	fade = 0;
}


function resumo_atualizar() {
	switch (resumo_estado) {

		case "fade_out": {
			fade = min(1, fade + fade_vel);
			if (fade >= 1) {
				resumo = gameManager.fechar_mes();   // calcula o mês (tela toda preta)
				painel_slide = 0;
				painel_t = 0;
				resumo_estado = "painel";
			}
			break;
		}

		case "painel": {
			painel_t += 1;
			painel_slide = min(1, painel_slide + 0.05);

			var _mx = device_mouse_x_to_gui(0);
			var _my = device_mouse_y_to_gui(0);
			var _clicou = mouse_check_button_pressed(mb_left)
				&& point_in_rectangle(_mx, _my, botao.x, botao.y, botao.x + botao.w, botao.y + botao.h);
			var _tecla = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

			// painel_t > 30: evita pular sem querer logo que o painel aparece
			if (painel_t > 30 && (_clicou || _tecla)) {
				if (resumo.ultimo) {
					resumo_estado = "inativo";
					gameManager.encerrar_ano();
				} else {
					gameManager.abrir_mes();         // prepara o mês novo escondido pela tela preta
					resumo_estado = "fade_in";
					hold_t = 0;
				}
			}
			break;
		}

		case "fade_in": {
			if (hold_t < 60) { hold_t += 1; break; }   // segura o nome do mês por ~1 s
			fade = max(0, fade - fade_vel);
			if (fade <= 0) {
				resumo_estado = "inativo";
				gameManager.terminar_transicao();    // libera o jogador e reinicia o relógio
			}
			break;
		}
	}
}


// desenha a variação (seta + valor) alinhada à direita em _xr
// _dinheiro = true escreve "R$" antes do número
function resumo_desenhar_delta(_xr, _y, _delta, _dinheiro) {
	var _txt = "0";
	var _cor = c_gray;

	if (_delta > 0) {
		_cor = c_lime;
		_txt = "+" + (_dinheiro ? "R$ " : "") + string(_delta);
	}
	else if (_delta < 0) {
		_cor = c_red;
		_txt = "-" + (_dinheiro ? "R$ " : "") + string(abs(_delta));
	}

	draw_set_color(_cor);
	draw_set_halign(fa_right);
	draw_text(_xr, _y, _txt);
	draw_set_halign(fa_left);

	// seta: triângulo para cima (verde) ou para baixo (vermelho)
	var _ax = _xr - string_width(_txt) - 20;
	var _ay = _y + 10;   // meio da linha (ajuste se mudar o tamanho da fonte)
	if (_delta > 0) {
		draw_triangle(_ax - 8, _ay + 6, _ax + 8, _ay + 6, _ax, _ay - 8, false);
	}
	else if (_delta < 0) {
		draw_triangle(_ax - 8, _ay - 6, _ax + 8, _ay - 6, _ax, _ay + 8, false);
	}
	draw_set_color(c_white);
}


function resumo_desenhar() {
	if (resumo_estado == "inativo") return;

	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();

	draw_set_font(Font_principal);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	// 1) escurece o jogo
	draw_set_alpha(fade);
	draw_set_color(c_black);
	draw_rectangle(0, 0, _gw, _gh, false);

	// 2) painel de resumo
	if (resumo_estado == "painel") {
		var _a = (resumo_estado == "fade_in") ? fade : 1;   // some junto com o fade

		var _pw = min(_gw * 0.7, 900);
		var _ph = min(_gh - 80, 560);
		var _ease = 1 - power(1 - painel_slide, 3);          // desliza e desacelera
		var _px = lerp(-_pw - 20, (_gw - _pw) / 2, _ease);
		var _py = (_gh - _ph) / 2;

		draw_set_alpha(_a);
		draw_set_color(c_black);
		
		// caixa de fundo
		draw_sprite_stretched(
			UI_Flat_Frame01a, 
			0, 
			_px, 
			_py, 
			_pw, 
			_ph
		);

		var _pad = 32;
		var _x0 = _px + _pad;
		var _x1 = _px + _pw - _pad;
		var _y  = _py + _pad;

		// título
		draw_set_color(c_black);
		draw_text(_x0, _y, "Resumo de " + resumo.mes_nome);
		if (!resumo.ultimo) {
			draw_set_halign(fa_right);
			draw_text(_x1, _y, "Próximo: " + resumo.proximo_nome);
			draw_set_halign(fa_left);
		}
		_y += 48;

		// linhas dos parâmetros (aparecem em cascata e os números "correm")
		var _rev = painel_t - 20;
		for (var k = 0; k < array_length(resumo.linhas); k++) {
			var _l = resumo.linhas[k];
			var _p = clamp((_rev - k * 10) / 30, 0, 1);
			var _valor = round(lerp(_l.antes, _l.depois, _p));

			draw_set_alpha(_a * _p);
			draw_set_color(c_black);
			draw_text(_x0, _y, _l.nome);
			draw_text(_x0 + 260, _y, string(_l.antes) + "  >  " + string(_valor));
			if (_p >= 1) resumo_desenhar_delta(_x1, _y, _l.delta, false);
			_y += 34;
		}

		// dinheiro
		var _kd = array_length(resumo.linhas);
		var _pd = clamp((_rev - _kd * 10) / 30, 0, 1);
		var _din = resumo.dinheiro;
		draw_set_alpha(_a * _pd);
		draw_set_color(c_black);
		draw_text(_x0, _y, "Dinheiro");
		draw_text(_x0 + 260, _y, "R$ " + string(_din.antes) + "  >  R$ " + string(round(lerp(_din.antes, _din.depois, _pd))));
		if (_pd >= 1) resumo_desenhar_delta(_x1, _y, _din.delta, true);
		_y += 28;
		if (_din.verba > 0) {
			draw_set_color(c_gray);
			draw_text(_x0 + 260, _y - 4, "(inclui R$ " + string(_din.verba) + " de verba do mês)");
			draw_set_color(c_black);
			_y += 22;
		}
		_y += 12;

		// missões do mês
		draw_set_alpha(_a);
		draw_set_color(c_black);
		draw_text(_x0, _y, "Missões:  " + string(resumo.resolvidas) + " resolvidas   |   "
			+ string(resumo.expiradas) + " expiraram   |   " + string(resumo.pendentes) + " pendentes");
		_y += 40;

		// botão Continuar (posição calculada antes para limitar as notícias)
		var _bw = 260;
		var _bh = 48;
		botao.w = _bw;
		botao.h = _bh;
		botao.x = _px + (_pw - _bw) / 2;
		botao.y = _py + _ph - _pad - _bh;

		// notícias (consequências de meses anteriores que aconteceram agora)
		draw_set_color(c_blue);
		draw_text(_x0, _y, "O que aconteceu:");
		draw_set_color(c_black);
		_y += 30;
		if (array_length(resumo.noticias) == 0) {
			draw_set_color(c_gray);
			draw_text(_x0, _y, "Nenhuma consequência de meses anteriores neste mês.");
			draw_set_color(c_black);
		} else {
			for (var n = 0; n < array_length(resumo.noticias); n++) {
				var _txt = "- " + resumo.noticias[n];
				var _hn = string_height_ext(_txt, 22, _x1 - _x0);
				if (_y + _hn > botao.y - 12) break;   // acabou o espaço
				draw_text_ext(_x0, _y, _txt, 22, _x1 - _x0);
				_y += _hn + 6;
			}
		}

		// botão
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _hover = point_in_rectangle(_mx, _my, botao.x, botao.y, botao.x + botao.w, botao.y + botao.h);
		
		//draw_set_color(_hover ? c_olive : c_black);
		//draw_rectangle(botao.x, botao.y, botao.x + botao.w, botao.y + botao.h, false);
		//draw_set_color(c_yellow);
		//draw_rectangle(botao.x, botao.y, botao.x + botao.w, botao.y + botao.h, true);
		
		if (_hover) {
			draw_sprite_stretched(
				UI_Flat_Frame03a_hover,
				0,
				botao.x,
				botao.y,
				botao.w, 
				botao.h
			);
		} else {
			
			draw_sprite_stretched(
				UI_Flat_Frame03a,
				0,
				botao.x,
				botao.y,
				botao.w, 
				botao.h
			);
		
		}
		
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text(botao.x + botao.w / 2, botao.y + botao.h / 2, resumo.ultimo ? "Ver avaliação final" : "Continuar  [Enter]");
	}

	// 3) apresentação do mês novo: nome do mês enquanto o jogo aparece
	if (resumo_estado == "fade_in") {
		draw_set_alpha(min(1, fade * 2));
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed(_gw / 2, _gh / 2 - 20, gameManager.meses[gameManager.mes_atual], 3, 3, 0);
		draw_text(_gw / 2, _gh / 2 + 40, "Mês " + string(gameManager.mes_atual + 1) + " de 12");
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
