# ProjectGuardianAgent Report: Workout Performance Charts

## Decisao

`approved`

A feature pode avancar para implementacao, desde que siga o plano de arquivos e os testes definidos neste relatorio.

## Resumo da Feature

Criar graficos de desempenho derivados de um `WorkoutPlan` ja valido. A feature deve calcular duracao por treino, duracao por grupo muscular e duracao total do plano. A UI apenas exibe os dados calculados.

## Checklist SDD

- [x] Objetivo claro.
- [x] Problema descrito.
- [x] Escopo definido.
- [x] Fora de escopo definido.
- [x] Arquitetura proposta.
- [x] Regras de DDD descritas.
- [x] Regras de UI descritas.
- [x] Estrategia de TDD descrita.
- [x] Riscos e mitigacoes descritos.
- [x] Criterios de aceite verificaveis.

## Checklist DDD

- [x] Domain continua independente de IA.
- [x] Domain continua independente de SwiftUI.
- [x] Domain continua independente de JSON.
- [x] Domain continua independente de prompt.
- [x] Domain continua independente de Infrastructure.
- [x] Calculos de desempenho ficam em domain service.
- [x] Presentation apenas formata dados para grafico.

## Checklist TDD

- [x] Testes de dominio definidos para calculos.
- [x] Testes de Presentation definidos para dados de grafico.
- [x] Nenhum teste exige chamada real para IA.
- [x] Criterios de aceite podem ser validados com XCTest.

## Plano de Arquivos

Arquivos a criar na implementacao:

```text
Sources/AIWorkoutCoach/Domain/Services/WorkoutPerformanceAnalyzer.swift
Sources/AIWorkoutCoach/Presentation/ViewModels/WorkoutPerformanceChartsViewModel.swift
AIWorkoutCoachDemoApp/WorkoutPerformanceChartsView.swift
Tests/AIWorkoutCoachTests/DomainTests/WorkoutPerformanceAnalyzerTests.swift
Tests/AIWorkoutCoachTests/PresentationTests/WorkoutPerformanceChartsViewModelTests.swift
```

Arquivos que podem ser alterados:

```text
AIWorkoutCoachDemoApp/ContentView.swift
README.md
SDD.md
```

Arquivos que nao devem ser alterados para esta feature:

```text
Sources/AIWorkoutCoach/AI
Sources/AIWorkoutCoach/Infrastructure
```

## Testes Esperados

- `testPerformanceAnalyzerShouldCalculateTotalDurationByWorkout`
- `testPerformanceAnalyzerShouldCalculateTotalDurationByMuscleGroup`
- `testPerformanceAnalyzerShouldCalculateTotalWorkoutDuration`
- `testChartsViewModelShouldExposeWorkoutChartData`
- `testChartsViewModelShouldExposeMuscleGroupChartData`
- `testChartsViewModelShouldNotRequireAIProvider`

## Riscos

- Risco: colocar calculo na View.
  - Mitigacao: criar `WorkoutPerformanceAnalyzer` no dominio.
- Risco: acoplar a feature a Swift Charts no dominio.
  - Mitigacao: dominio retorna estruturas simples; grafico fica no app demo.
- Risco: misturar desempenho com nova chamada de IA.
  - Mitigacao: feature deriva dados apenas do `WorkoutPlan`.

## Proximo Passo

Implementar os testes primeiro, depois criar `WorkoutPerformanceAnalyzer`, `WorkoutPerformanceChartsViewModel` e a tela SwiftUI. Ao final, rodar:

```bash
swift test
```

## Execucao

Status: `implemented`

O plano aprovado foi executado com TDD:

1. Testes de dominio foram criados.
2. `WorkoutPerformanceAnalyzer` foi implementado no dominio.
3. Testes de Presentation foram criados.
4. `WorkoutPerformanceChartsViewModel` foi implementado.
5. `WorkoutPerformanceChartsView` foi adicionada ao app demo.
6. `ContentView` passou a navegar para a tela de desempenho.

Validacao:

```text
swift test
24 testes, 0 falhas
```
