# Ideias para depois (não implementadas)

Este arquivo guarda ideias combinadas que ficaram para uma segunda fase. Primeiro as mecânicas principais.

## 1. Abertura / "entradinha" do jogo

Cena curta no começo de janeiro: o diretor chega à escola, os professores o recebem e se apresentam, e o jogo ensina o básico (falar com NPC com a tecla de interação, ver as barras de status, olhar o relógio do mês). Fica para depois porque exige animação e composição de cena.

Quando for fazer: pode ser uma sequência de `abrir_texto_simples` com os NPCs já posicionados (Gilson e Joaquim nas salas, Rodrigo no corredor), sem animação nova.

## 2. Eventos mensais (ex.: Festa de Julho)

### A estrutura atual aguenta?

Sim, com poucas extensões, porque já existem as três peças que um evento precisa: posição de NPC por mês, missões com consequências e flags para lembrar o que aconteceu.

O que faltaria:

1. **Rota especial do evento.** Um catálogo `evento_Data` com, para cada evento: `mes`, `titulo`, `requer_flag` (opcional) e `rota_especial` (onde cada NPC fica naquele mês, por exemplo todo mundo na cantina e na entrada). A `npc_posicao_no_mes` olharia primeiro essa rota e só depois a rota normal.
2. **Missões do evento.** As missões ganhariam um campo `evento: "festa_julho"` (e `ativa` só durante o evento). Elas usam o mesmo molde, os mesmos efeitos e as mesmas consequências.
3. **Resultado do evento.** No fim do mês, um resumo conta quantas missões do evento foram feitas e dá um resultado (ex.: festa fraca, boa ou ótima), que gera flags e consequências nos meses seguintes. Ex.: festa ótima = `escola_com_boa_fama` (mais alunos felizes, mais dinheiro em agosto).

Ponto de atenção: a escola é pequena e a cantina/biblioteca são minúsculas, então uma festa com todos os NPCs precisa usar corredor e entrada como "pista de festa" (e várias posições diferentes no corredor para ninguém ficar empilhado).

### Ideias de evento

- **Festa Junina (junho/julho):** barraquinhas, comidas, decoração, música. Combina com a missão de organizar materiais e com orçamento apertado.
- **Festa beneficente:** arrecadar dinheiro para a escola. Boa para decisões de "gastar agora para ganhar depois".
- **Feira de Ciências:** professores de Química e História (e os futuros) apresentam projetos; o diretor escolhe onde investir.
- **Gincana / Olimpíada escolar:** turmas competem; mexe com felicidade dos alunos.
- **Semana do Meio Ambiente:** liga direto com as missões de reciclagem e descarte.
- **Dia do Professor (outubro):** presente/homenagem; mexe com satisfação dos professores.
- **Mostra cultural / formatura (dezembro):** fechamento do ano, usando as flags acumuladas.

### Missões de evento (exemplos de formato, sem criar conteúdo novo)

- Uma de busca (buscar material de decoração no almoxarifado).
- Uma de diálogo (pergunta que decide o cardápio ou o orçamento).
- Uma de decisão com dinheiro (pagar ou fazer na raça).
- Uma de grupo: só libera o resultado final se pelo menos 3 das 4 forem concluídas.
