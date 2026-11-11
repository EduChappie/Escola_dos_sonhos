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

eventos_criticos = [];        

// ===== MEMÓRIA DO JOGO (consequências) =====
flags = {};              // marcas ativadas por consequências: { "zelador_pediu_material": true }
noticias_do_mes = [];    // textos das consequências que aconteceram na virada do mês
                         // (para a tela de fim de mês mostrar depois)

function flag_set(_nome) {
	flags[$ _nome] = true;
}

function flag_tem(_nome) {
	return flags[$ _nome] ?? false;
}

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





// ===== FLUXO DO MÊS =====
function reset() {
	NPCManager.npc_posicionar(mes_atual);
	missionManager.mission_sortear_para_mes(mes_atual);
}

function novoMes() {
	// 1) penalidades das missões que ficaram pendentes
	missionManager.mission_processar_fim_de_mes();

	// 2) avança o mês
	mes_atual += 1;
	moeda += 200;

	// 3) consequências de missões de meses anteriores que vencem agora
	missionManager.mission_aplicar_consequencias(mes_atual);

	obj_player.resetPosition();
	statusManager_UI.reset_values();
	show_debug_message("Passou o mês: " + meses[mes_atual]);

	// 4) posiciona NPCs e sorteia as missões do novo mês
	reset();
}

// ===== início do jogo =====
NPCManager.npc_posicionar(mes_atual);
missionManager.mission_sortear_para_mes(mes_atual);
timeManager.reset();


missionManager.mission_validar_catalogo();
