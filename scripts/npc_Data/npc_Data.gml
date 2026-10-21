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
                { mes: 0,  sala: "sala_artes",  x: 991, y: 509 },
                // ... até 12
            ]
        },
        {
            id: "prof_Joaquim",
            nome: "Sr. Joaquim",
            tipo: "professor",
            materia: "Historia",
            sprite: sProfessoB1_front_idle, // trocar depois o sprite, please
			i: 0,
			afinidade: 0,
            agenda_mensal: [ 
				{ mes: 0,  sala: "sala_artes",  x: 1001, y: 769 },
			]
        },
		{
            id: "Zelador Rodrigo",           // <- é ASSIM que você se refere a ele. Sempre.
            nome: "Sr. Rodrigo",
            tipo: "zelador",
            materia: undefined,
            sprite: sAlunoA1_down_idle,
            afinidade: 0,
			i: 0,                         // i referente a interação 0 == nunca interagiram
            agenda_mensal: [
                { mes: 0,  sala: "sala_01",  x: 480, y: 617 },
                // ... até 12
            ]
        },
		{
            id: "aluno a1",           // <- é ASSIM que você se refere a ele. Sempre.
            nome: "Sr. Michael",
            tipo: "aluno",
            materia: undefined,
            sprite: sAlunoA1_front_idle,
            afinidade: 0,
			i: 0,                         // i referente a interação 0 == nunca interagiram
            agenda_mensal: [
                { mes: 0,  sala: "sala_01",  x: 1061, y: 190 },
                // ... até 12
            ]
        },
		{
            id: "aluno a2",           // <- é ASSIM que você se refere a ele. Sempre.
            nome: "Sr. Cammy",
            tipo: "aluno",
            materia: undefined,
            sprite: sAlunoB1_front_idle,
            afinidade: 0,
			i: 0,                         // i referente a interação 0 == nunca interagiram
            agenda_mensal: [
                { mes: 0,  sala: "sala_01",  x: 583, y: 287 },
                // ... até 12
            ]
        },
    ];
}