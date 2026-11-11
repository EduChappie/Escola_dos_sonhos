# Escola dos Sonhos - Estrutura do projeto

## Onde fica cada coisa

| O que | Onde | Observação |
|---|---|---|
| Salas, corredores e pontos onde NPC fica | `scripts/npc_Data/npc_Data.gml` -> `local_catalog()` | Coordenadas em x1,y1 (canto superior esquerdo) e x2,y2 (canto inferior direito) |
| Quadrados de coleta (missões de busca) | `npc_Data.gml` -> `busca_catalog()` | Missão usa `busca_ponto("nome")` |
| NPCs e rota de janeiro a dezembro | `npc_Data.gml` -> `npc_catalog()` | Rota por NOME de sala, 12 itens |
| Missões e consequências | `scripts/mission_Data/mission_Data.gml` | O molde está comentado no topo do arquivo |
| Lógica de missões / consequências | `objects/missionManager/Create_0.gml` | |
| Status, dinheiro, flags, virada de mês | `objects/gameManager/Create_0.gml` | |
| Duração do mês | `objects/timeManager/Create_0.gml` -> `pmin` | Hoje: 4 minutos |

## Como a virada de mês funciona

1. Missões pendentes recebem a penalidade do grau (ou expiram).
2. O mês avança e entra o dinheiro do mês.
3. Consequências agendadas para este mês são aplicadas (efeitos, flags, notícias).
4. NPCs vão para as posições da rota do novo mês.
5. Novas missões são sorteadas (respeitando `ativa`, `requer_flag` e `bloqueada_por_flag`).

## Regras de nome

- IDs de NPC: minúsculo, sem espaço, nunca mudam. Ex.: `prof_quimica`, `zelador_rodrigo`, `aluno_michael`.
- IDs de missão: `quem_assunto`. Ex.: `zelador_limpeza_patio`.
- Salas: `sala_01`, `banheiro_1`, `almoxarifado`... exatamente como em `local_catalog()`.
- Flags: `descricao_curta_em_minusculo`. Ex.: `zelador_pediu_material`.

## Como adicionar um NPC novo

1. Em `npc_catalog()`, copie um bloco e troque `id`, `nome`, `tipo`, `materia`, `sprite`.
2. Preencha a `rota` com 12 itens (use `"ausente"` para meses em que ele não aparece).
3. Confira no mesmo mês se dois NPCs não caem na mesma sala pequena (cantina e biblioteca são minúsculas).
4. Se existir missão dormente para ele (`ativa: false`), troque para `ativa: true`.
5. Rode o jogo e olhe a aba Output: avisos começam com `AVISO:`.

## Sprites (organização sugerida)

Hoje os sprites seguem `s<Tipo><Letra><Número>_<direção>_<estado>` (ex.: `sAlunoA1_front_idle`). Sugestão: manter esse padrão para não quebrar nada e criar, no IDE do GameMaker, estas pastas dentro de Sprites:

```
Sprites/
  NPCs/
    Professores/
    Alunos/
    Funcionarios/      (zelador, merendeira, bibliotecária, técnico)
  Player/
  Cenario/
  UI/
```

Para cada NPC novo: um conjunto `idle` (frente, costas, lado) e, se for andar, `walk` com as mesmas direções.

Pendências de nome (fazer pelo IDE, clicando com o botão direito -> Rename, para o GameMaker atualizar tudo):

- `sProfessoA1_front_idle` e `sProfessoB1_front_idle`: falta o "r" (`sProfessorA1_...`). Depois de renomear, atualizar o campo `sprite` em `npc_catalog()`.
- `Sprite42`, `Sprite43`, `Sprite45`, `Sprite46`: sem nome descritivo.
- Há `down` e `front` no mesmo conjunto (ex.: `sAlunoA1_down_idle` e `sAlunoA1_front_idle`). Vale decidir qual é qual e padronizar.
- O zelador usa um sprite de aluno provisório.

## Pendências de organização (IDE)

- Scripts: opcionalmente renomear para `scr_npc_data` e `scr_mission_data` e criar as pastas virtuais `Scripts/Dados` e `Scripts/Sistemas`.
- Os arquivos `Escola_dos_Sonhos Alpha 0..yyz` e `Escola_dos_Sonhos Beta 1.0.yyz` na raiz são backups em zip: melhor guardá-los fora da pasta do projeto.
- A nota `notes/leia-me` ainda fala de "addEdu" (pasta antiga).

## Coisas que o código ainda não faz (de propósito)

- A tela de fim de mês ainda não mostra `gameManager.noticias_do_mes` (as consequências já são guardadas lá).
- `meses_disponiveis` só vale com `modo_teste = false` (em `missionManager`).
- Missões não se repetem: com poucas missões, o conteúdo acaba nos primeiros meses.
