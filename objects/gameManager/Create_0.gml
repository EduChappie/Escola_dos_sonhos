meses = [
	"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
	"Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
];
randomise();

mes_atual = 0;

// =====================================================================
//  OS 4 PARÂMETROS DO JOGO (0 a 100 = já é a porcentagem)
//
//    felicidade_alunos      -> felicidade dos ALUNOS
//    felicidade_professor   -> felicidade dos PROFESSORES
//    ensino                 -> nível de ensino
//    infraestrutura         -> estado físico da escola
//  + moeda (dinheiro)
//
//  CHAVES DE EFEITO usadas nas missões (mission_Data):
//    felicidade              -> afeta os DOIS (alunos e professores)
//    felicidade_alunos       -> só alunos
//    felicidade_professores  -> só professores
//    ensino                  -> ensino
//    infraestrutura          -> infraestrutura
//    dinheiro                -> moeda
//  (aliases antigos ainda aceitos: satisfacao_professores = felicidade_professores,
//   desempenho_escolar = ensino)
// =====================================================================
infraestrutura       = 50;
ensino               = 50;
felicidade_alunos    = 50;
felicidade_professor = 50;
moeda                = 160;   
verba_mensal         = 50;   // dinheiro que entra a cada virada de mês

eventos_criticos = [];        

// ===== MEMÓRIA DO JOGO (consequências) =====
flags = {};              // marcas ativadas por consequências: { "zelador_pediu_material": true }
noticias_do_mes = [];    // textos das consequências que aconteceram na virada do mês
                         // (a tela de resumo do mês mostra isso)

function flag_set(_nome) {
	flags[$ _nome] = true;
}

function flag_tem(_nome) {
	return flags[$ _nome] ?? false;
}

// ===== FASE DO JOGO / RESUMO DO MÊS =====
fase = "jogando";        // "jogando" | "transicao" (fim de mês: fades + tela de resumo)
mes_inicio = undefined;  // "foto" dos parâmetros no começo do mês (preenchida no fim deste Create)
resumo_atual = undefined;
historico_meses = [];    // um resumo por mês fechado (usado na avaliação final)

// Barras que aparecem na tela (nome da variável, texto e cor)
barras = [
	{ var_nome: "felicidade_alunos",    texto: "Alunos",         cor: c_aqua   },
	{ var_nome: "felicidade_professor", texto: "Professores",    cor: c_orange },
	{ var_nome: "infraestrutura",       texto: "Infraestrutura", cor: c_lime   },
	{ var_nome: "ensino",               texto: "Ensino",         cor: c_yellow }
];

// ===== EFEITOS =====
// Soma um valor num status e trava entre 0 e 100
function stat_somar(_nome, _valor) {
	var _atual = variable_instance_get(id, _nome);
	variable_instance_set(id, _nome, clamp(_atual + _valor, 0, 100));
}

// true se o jogador tem dinheiro para cobrir o custo do efeito
function pode_pagar(_efeito) {
    if (_efeito == undefined) return true;
    var _d = _efeito[$ "dinheiro"];
    if (_d == undefined || _d >= 0) return true;   // não custa nada
    return (moeda >= abs(_d));
}

// Recebe um struct de efeito, por exemplo { felicidade: +2, dinheiro: -150 }
// Funciona para recompensas, erros, penalidades por grau e consequências
function aplicar_efeito(_efeito) {
	if (_efeito == undefined) return;

	var _chaves = variable_struct_get_names(_efeito);
	for (var i = 0; i < array_length(_chaves); i++) {
		var _k = _chaves[i];
		var _v = _efeito[$ _k];

		switch (_k) {
			case "dinheiro":
				moeda = max(0, moeda + _v);
				break;

			case "felicidade":   // geral: afeta alunos E professores
				stat_somar("felicidade_alunos", _v);
				stat_somar("felicidade_professor", _v);
				break;

			case "felicidade_alunos":
				stat_somar("felicidade_alunos", _v);
				break;

			case "felicidade_professores":
			case "satisfacao_professores":   // nome antigo (alias)
				stat_somar("felicidade_professor", _v);
				break;

			case "infraestrutura":
				stat_somar("infraestrutura", _v);
				break;

			case "ensino":
			case "desempenho_escolar":       // nome antigo (alias)
				stat_somar("ensino", _v);
				break;

			case "evento_critico":
				evento_critico_executar(_v);
				break;

			case "grau":   // campo de controle das penalidades
			case "acao":   // tratado pelo missionManager
				break;

			default:
				show_debug_message("EFEITO DESCONHECIDO: " + _k);
		}
	}
}

function evento_critico_executar(_nome) {
	show_debug_message("EVENTO CRÍTICO: " + _nome);
	array_push(eventos_criticos, _nome);
	// depois: demitir NPC, cancelar aula, etc.
}





// =====================================================================
//  FLUXO DO MÊS
//
//  Tempo zerou -> fim_do_mes()
//     1) o jogo congela (fase = "transicao") e a tela escurece (fade out)
//     2) fechar_mes(): penalidades, mês novo, verba, consequências -> monta o RESUMO
//     3) o painel de resumo desliza (statusManager_UI) e espera o botão Continuar
//     4) abrir_mes(): reposiciona NPCs, sorteia missões, tira a nova "foto" do mês
//     5) fade in -> terminar_transicao(): o jogo volta e o relógio recomeça
// =====================================================================

// foto dos parâmetros neste instante (para comparar no fim do mês)
function foto_estado() {
	return {
		felicidade_alunos:    felicidade_alunos,
		felicidade_professor: felicidade_professor,
		ensino:               ensino,
		infraestrutura:       infraestrutura,
		moeda:                moeda
	};
}

function reset() {
	NPCManager.npc_posicionar(mes_atual);
	missionManager.mission_sortear_para_mes(mes_atual);
}

// chamado pelo timeManager quando o relógio chega a zero
function fim_do_mes() {
	if (fase != "jogando") return;
	fase = "transicao";
	if (instance_exists(dialogoManager_UI)) dialogoManager_UI.fechar();
	statusManager_UI.resumo_iniciar();   // começa o fade out
}

// calcula o mês e devolve o resumo (chamado com a tela toda preta)
function fechar_mes() {
	var _mes    = mes_atual;
	var _ultimo = (_mes >= 11);

	// 1) penalidades das missões que ficaram pendentes
	missionManager.mission_processar_fim_de_mes();

	// quantas missões foram encerradas neste mês
	var _resolvidas = 0;
	var _expiradas  = 0;
	var _hist = missionManager.mission_history;
	for (var i = 0; i < array_length(_hist); i++) {
		if ((_hist[i][$ "mes_resolucao"] ?? -1) != _mes) continue;
		if ((_hist[i][$ "resultado"] ?? "") == "expirou") _expiradas++;
		else _resolvidas++;
	}

	// 2) avança o mês, entra a verba e vencem as consequências agendadas
	var _verba = 0;
	noticias_do_mes = [];
	if (!_ultimo) {
		mes_atual += 1;
		_verba = verba_mensal;
		moeda += _verba;
		missionManager.mission_aplicar_consequencias(mes_atual);
	}
	statusManager_UI.reset_values();

	// 3) monta o resumo comparando com a foto do início do mês
	var _antes = mes_inicio;
	var _linhas = [];
	for (var i = 0; i < array_length(barras); i++) {
		var _b = barras[i];
		var _a = _antes[$ _b.var_nome];
		var _d = variable_instance_get(id, _b.var_nome);
		array_push(_linhas, { nome: _b.texto, antes: _a, depois: _d, delta: _d - _a });
	}

	var _resumo = {
		mes_indice:  _mes,
		mes_nome:    meses[_mes],
		proximo_nome: (_ultimo ? "" : meses[mes_atual]),
		ultimo:      _ultimo,
		linhas:      _linhas,
		dinheiro:    { antes: _antes.moeda, depois: moeda, delta: moeda - _antes.moeda, verba: _verba },
		noticias:    noticias_do_mes,
		resolvidas:  _resolvidas,
		expiradas:   _expiradas,
		pendentes:   array_length(missionManager.active_missions)
	};

	array_push(historico_meses, _resumo);
	resumo_atual = _resumo;
	show_debug_message("Mês fechado: " + _resumo.mes_nome);
	return _resumo;
}

// prepara o mês novo (chamado ainda escondido pela tela preta)
function abrir_mes() {
	obj_player.resetPosition();
	reset();                              // posiciona NPCs e sorteia as missões
	statusManager_UI.reset_values();
	mes_inicio = foto_estado();
	show_debug_message("Começou o mês: " + meses[mes_atual]);
}

// fade in terminou: devolve o controle ao jogador e reinicia o relógio
function terminar_transicao() {
	fase = "jogando";
	timeManager.reset();
}

// dezembro fechado: vai para a avaliação final
function encerrar_ano() {
	global.historico_ano = historico_meses;   // a sala final lê daqui
	show_debug_message("Fim de jogo");
	if (room_exists(Statisticas_final)) room_goto(Statisticas_final);
}

// ===== início do jogo =====
NPCManager.npc_posicionar(mes_atual);
missionManager.mission_sortear_para_mes(mes_atual);
timeManager.reset();
mes_inicio = foto_estado();


missionManager.mission_validar_catalogo();
