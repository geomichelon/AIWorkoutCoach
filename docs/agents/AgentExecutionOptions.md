# Formas de Executar Agentes no AIWorkoutCoach

Este documento descreve formas diferentes de executar agentes no contexto desta branch. O objetivo e mostrar como agentes podem apoiar o desenvolvimento orientado por SDD, DDD e TDD antes da implementacao de uma nova funcionalidade.

## Contexto

Nesta branch, o exemplo de agente e o `ProjectGuardianAgent`.

Arquivos relacionados:

```text
docs/agents/ProjectGuardianAgent.md
docs/agents/ProjectGuardianAgent-WorkoutPerformanceCharts-Report.md
docs/SDD-WorkoutPerformanceCharts.md
```

O papel do agente e validar:

- se existe SDD da feature;
- se o SDD tem objetivo, escopo, arquitetura, riscos e criterios de aceite;
- se as fronteiras de DDD continuam protegidas;
- se existe estrategia de TDD;
- se a feature pode seguir para implementacao.

## Opcao 1: Executar o Agente Conversacionalmente no Codex

Esta e a forma mais simples.

Voce pede ao Codex:

```text
Atue como ProjectGuardianAgent.

Leia:
- SDD.md
- docs/SDD-WorkoutPerformanceCharts.md
- docs/agents/ProjectGuardianAgent.md
- arvore atual de arquivos

Antes de implementar qualquer codigo, valide se a feature de graficos de desempenho pode seguir.

Responda com:
1. Decisao: approved, needs_changes ou blocked.
2. Checklist SDD.
3. Checklist DDD.
4. Checklist TDD.
5. Plano de arquivos.
6. Riscos.
7. Proximo passo.

Nao implemente codigo ainda.
```

Vantagens:

- nao exige script;
- permite raciocinio mais flexivel;
- bom para explorar tradeoffs;
- ideal para revisao arquitetural.

Limites:

- depende da conversa;
- nao e automaticamente repetivel;
- o resultado precisa ser salvo manualmente se virar documentacao.

## Opcao 2: Executar por Prompt Manual Copiado do Documento do Agente

O arquivo `ProjectGuardianAgent.md` possui um prompt exemplo.

Fluxo:

1. Abra `docs/agents/ProjectGuardianAgent.md`.
2. Copie o bloco `Prompt Exemplo`.
3. Cole no Codex ou ChatGPT.
4. Inclua os arquivos relevantes no contexto.
5. Salve a resposta em um relatorio Markdown.

Saida esperada:

```text
docs/agents/ProjectGuardianAgent-WorkoutPerformanceCharts-Report.md
```

Vantagens:

- simples;
- didatico;
- bom para tech talk;
- deixa claro que o SDD e o contrato do agente.

Limites:

- ainda e manual;
- pode variar entre execucoes;
- nao valida regras objetivas no terminal.

## Opcao 3: Executar um Agente Local Deterministico

Nesta abordagem, o agente nao chama IA. Ele roda localmente e valida regras objetivas do projeto.

Exemplo de comando desejado:

```bash
swift run ProjectGuardianAgent docs/SDD-WorkoutPerformanceCharts.md
```

O agente poderia validar:

- se o arquivo SDD existe;
- se secoes obrigatorias existem;
- se `Sources/AIWorkoutCoach/Domain` nao importa `SwiftUI`;
- se `Sources/AIWorkoutCoach/Domain` nao referencia `AI`, `DTO`, `Prompt`, `OpenAI`, `Gemini` ou `Claude`;
- se o SDD lista testes esperados;
- se nenhum teste chama IA real.

Possivel estrutura:

```text
Sources/ProjectGuardianAgent
└── main.swift
```

Vantagens:

- repetivel;
- sem custo;
- sem chamada externa;
- bom para CI;
- bom para demonstrar guardrails objetivos.

Limites:

- nao raciocina como um LLM;
- valida apenas regras codificadas;
- nao substitui revisao humana ou conversacional.

## Opcao 4: Script Local que Monta o Prompt

Outra alternativa e criar um script que nao chama IA, mas monta o prompt completo para ser colado no Codex.

Exemplo:

```bash
./scripts/run_project_guardian_agent.sh docs/SDD-WorkoutPerformanceCharts.md
```

O script poderia imprimir:

- conteudo do `SDD.md`;
- conteudo do SDD da feature;
- conteudo do `ProjectGuardianAgent.md`;
- arvore de arquivos;
- prompt final.

Vantagens:

- reduz trabalho manual;
- mantem controle sobre o contexto enviado;
- nao depende de API;
- facil de apresentar.

Limites:

- ainda exige colar o prompt em uma ferramenta de IA;
- nao executa raciocinio sozinho.

## Opcao 5: Agente Local com CLI/API de IA

Essa opcao chama um modelo real por CLI ou API.

Exemplo conceitual:

```bash
./scripts/run_project_guardian_agent.sh docs/SDD-WorkoutPerformanceCharts.md --use-llm
```

Ou:

```bash
codex run ProjectGuardianAgent docs/SDD-WorkoutPerformanceCharts.md
```

Fluxo:

1. Script coleta contexto.
2. Script envia contexto para um modelo.
3. Modelo retorna relatorio.
4. Script salva relatorio em `docs/agents/generated/`.

Vantagens:

- mais proximo de um agente autonomo;
- repetivel;
- pode gerar relatorios automaticamente;
- pode ser integrado a pull requests.

Limites:

- exige autenticacao;
- pode ter custo;
- pode falhar por rede;
- exige cuidado com dados sensiveis;
- precisa de politica clara sobre o que pode ser enviado.

## Opcao 6: Agente no Pull Request

O agente tambem pode funcionar como etapa de revisao em PR.

Fluxo:

1. Dev cria ou altera SDD da feature.
2. Dev abre PR.
3. Agente valida SDD, DDD e TDD.
4. Agente comenta no PR com `approved`, `needs_changes` ou `blocked`.
5. Implementacao so segue se o agente aprovar.

Checklist do agente no PR:

- SDD existe?
- Feature esta no escopo?
- Domain continua independente?
- Testes foram definidos?
- Testes foram implementados?
- `swift test` passou?

Vantagens:

- aproxima agentes do fluxo real de engenharia;
- cria historico de decisoes;
- evita violacoes arquiteturais chegarem na main.

Limites:

- exige integracao com GitHub Actions ou ferramenta similar;
- exige credenciais;
- precisa evitar comentarios ruidosos.

## Recomendacao para Esta Tech Talk

Para a apresentacao, o fluxo mais claro e:

1. Mostrar o SDD principal.
2. Mostrar o SDD da feature de graficos.
3. Mostrar `ProjectGuardianAgent.md`.
4. Mostrar o relatorio aprovado.
5. Explicar que a implementacao so acontece depois da aprovacao.
6. Implementar com TDD.
7. Rodar `swift test`.

Mensagem central:

```text
SDD define o contrato.
O agente valida o contrato.
DDD protege o dominio.
TDD prova o comportamento.
```

## Estado Atual da Branch

Esta branch ainda nao implementa os graficos.

Ela demonstra o passo anterior:

```text
SDD da feature -> agente valida -> feature aprovada para implementacao
```

O proximo passo seria implementar:

```text
Sources/AIWorkoutCoach/Domain/Services/WorkoutPerformanceAnalyzer.swift
Sources/AIWorkoutCoach/Presentation/ViewModels/WorkoutPerformanceChartsViewModel.swift
AIWorkoutCoachDemoApp/WorkoutPerformanceChartsView.swift
Tests/AIWorkoutCoachTests/DomainTests/WorkoutPerformanceAnalyzerTests.swift
Tests/AIWorkoutCoachTests/PresentationTests/WorkoutPerformanceChartsViewModelTests.swift
```
