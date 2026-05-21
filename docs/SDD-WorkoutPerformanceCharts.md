# Workout Performance Charts Software Design Document

## Objetivo

Adicionar uma feature didatica de graficos de desempenho do treino, mantendo o dominio isolado de UI, IA, JSON, banco de dados e bibliotecas de grafico.

Esta feature existe para demonstrar como um agente pode validar SDD, DDD e TDD antes de qualquer implementacao.

## Problema

Depois que um plano de treino e gerado, o usuario pode querer acompanhar indicadores simples de progresso, como duracao total por treino e distribuicao por grupo muscular. O projeto ainda nao possui uma forma de visualizar esse desempenho.

## Escopo

A feature deve permitir:

1. Calcular duracao total por treino.
2. Calcular duracao total por grupo muscular.
3. Expor dados prontos para apresentacao em grafico.
4. Exibir graficos no app demo usando dados derivados do dominio.
5. Testar calculos sem depender de SwiftUI, IA ou provider externo.

Fora de escopo:

- historico real de execucao;
- banco de dados;
- sincronizacao remota;
- chamada real de IA;
- recomendacao nova de treino;
- analise preditiva;
- bibliotecas externas de graficos.

## Arquitetura Proposta

```text
Domain
└── Services
    └── WorkoutPerformanceAnalyzer

Presentation
└── ViewModels
    └── WorkoutPerformanceChartsViewModel

AIWorkoutCoachDemoApp
└── WorkoutPerformanceChartsView

Tests
└── DomainTests / PresentationTests
```

## Regras de DDD

1. O dominio pode calcular metricas usando `WorkoutPlan`, `Workout` e `Exercise`.
2. O dominio nao pode depender de SwiftUI, Charts, IA, JSON, prompt ou banco.
3. Se houver regra de calculo, ela deve ficar no dominio ou em um domain service.
4. A Presentation apenas formata dados para exibicao.
5. A tela nao deve recalcular regras de negocio.
6. DTOs de grafico, se existirem, devem ficar fora do dominio.

## Modelo Conceitual

Metricas iniciais:

- `totalDurationByWorkout`
- `totalDurationByMuscleGroup`
- `totalWorkoutDuration`

Essas metricas devem ser derivadas de um `WorkoutPlan` ja valido.

## Regras de UI

1. A tela recebe um `WorkoutPlan`.
2. A tela exibe duracao total do plano.
3. A tela exibe um grafico por treino.
4. A tela exibe um grafico por grupo muscular.
5. A tela deve suportar estado defensivo sem dados.
6. A tela nao chama IA.
7. A tela nao persiste dados.

## Estrategia de TDD

Testes obrigatorios antes da implementacao:

- `testPerformanceAnalyzerShouldCalculateTotalDurationByWorkout`
- `testPerformanceAnalyzerShouldCalculateTotalDurationByMuscleGroup`
- `testPerformanceAnalyzerShouldCalculateTotalWorkoutDuration`
- `testChartsViewModelShouldExposeWorkoutChartData`
- `testChartsViewModelShouldExposeMuscleGroupChartData`
- `testChartsViewModelShouldNotRequireAIProvider`

## Estrategia de SDD com Agentes

Antes de implementar, o `ProjectGuardianAgent` deve validar:

1. Este SDD define objetivo, escopo e fora de escopo.
2. As regras de DDD preservam o dominio.
3. A estrategia de TDD lista testes observaveis.
4. A feature nao introduz dependencia externa desnecessaria.
5. A feature nao muda o fluxo de IA.
6. A implementacao planejada tem arquivos e responsabilidades claros.

## Riscos e Mitigacao

- Regra de calculo ficar na View: mitigar com `WorkoutPerformanceAnalyzer`.
- Dependencia de biblioteca externa: mitigar usando estruturas simples ou Swift Charts apenas na app layer.
- Misturar graficos com IA: mitigar deixando graficos derivados apenas do dominio.
- Testes focarem em layout: mitigar testando ViewModels e domain services.

## Criterios de Aceite

- O SDD e aprovado pelo agente antes da implementacao.
- O dominio continua sem importar AI, SwiftUI, JSON, prompt, OpenAI ou Infrastructure.
- Testes de dominio cobrem os calculos.
- Testes de Presentation cobrem os dados expostos para graficos.
- `swift test` passa.
- O app demo compila.

## Implementacao Executada

Arquivos criados:

```text
Sources/AIWorkoutCoach/Domain/Services/WorkoutPerformanceAnalyzer.swift
Sources/AIWorkoutCoach/Presentation/ViewModels/WorkoutPerformanceChartsViewModel.swift
AIWorkoutCoachDemoApp/WorkoutPerformanceChartsView.swift
Tests/AIWorkoutCoachTests/DomainTests/WorkoutPerformanceAnalyzerTests.swift
Tests/AIWorkoutCoachTests/PresentationTests/WorkoutPerformanceChartsViewModelTests.swift
```

Arquivo alterado:

```text
AIWorkoutCoachDemoApp/ContentView.swift
```

Resultado esperado no app demo:

1. Usuario gera um plano.
2. Tela principal exibe `Ver desempenho`.
3. Usuario abre a tela de desempenho.
4. Tela mostra duracao total, duracao por treino e duracao por grupo muscular.
