function npc_catalog() {
    return [
        {
            id: "prof_gilson",           // <- é ASSIM que você se refere a ele. Sempre.
            nome: "Sr. Gilson",
            tipo: "professor",
            materia: "Quimica",
            sprite: sProfessoA1_front_idle,
            afinidade: 0,
			i: 0,// i referente a interação 0 == nunca interagiram
            agenda_mensal: [
                { mes: 0,  sala: "sala_artes",  x: 572, y: 604 },
                // ... até 12
            ]
        },
        {
            id: "prof_fernanda",
            nome: "Sra. Fernanda",
            tipo: "professor",
            materia: "Historia",
            sprite: sAlunoB1_side_idle, // trocar depois o sprite, please
			i: 0,
			afinidade: 0,
            agenda_mensal: [ 
				{ mes: 0,  sala: "sala_artes",  x: 500, y: 550 },
			]
        }
    ];
}