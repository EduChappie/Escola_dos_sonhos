xp = 50
yp = 120
depth = -100

// tempo pra começar a passagem de meses
space = [0, 2, 0]

// tempo de passagem do mês
pmin = 5
psec = 10
pmil = 0

// começa a contagem
function reset() {
	t_min = pmin
	t_sec = psec
	t_mil = pmil
	alarm[0] = 6
}

function space_to_reset() {
	//with (oNpc1) {
	//	resetPlayer()
	//	haveMission()
	//}
	show_debug_message("Ativa 1");
	//show_debug_message(obj_mission_manager.missao_atual);
	gmin = space[0]
	gsec = space[1]
	gmil = space[2]
	alarm[1] = 6
}

//with (oNpc1) {
//	resetPlayer()
//	haveMission()
//}

// esses códigos estão comentados, pois se referenciam a
// vários npcs, objeto pai