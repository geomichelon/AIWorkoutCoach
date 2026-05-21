# Workout Details Software Design Document

## Objetivo

Adicionar uma tela de detalhes para cada treino (`Workout`) gerado pelo AIWorkoutCoach, mantendo o dominio isolado de SwiftUI, IA, DTOs, prompt e persistencia.

## Escopo

A feature cobre:

1. Listar treinos gerados na tela principal.
2. Permitir navegar para os detalhes de um treino.
3. Exibir titulo do treino.
4. Exibir exercicios do treino.
5. Exibir nome, grupo muscular e duracao de cada exercicio.
6. Exibir aviso quando um exercicio tiver restricoes incompatíveis declaradas no proprio exercicio.

Fora de escopo:

- chamar IA novamente na tela de detalhes;
- persistir alteracoes;
- editar treino;
- recalcular regras de dominio na UI;
- parsear JSON;
- conhecer DTOs da camada AI.

## Arquitetura

A feature fica na camada Presentation e no app demo:

```text
Sources/AIWorkoutCoach/Presentation/ViewModels
└── WorkoutDetailsViewModel.swift

AIWorkoutCoachDemoApp
└── WorkoutDetailsView.swift
```

## Regras da Tela

1. A tela recebe um `Workout` ja validado pelo dominio.
2. A tela nao chama IA.
3. A tela nao persiste dados.
4. A tela nao conhece DTOs da IA.
5. A tela nao altera regras de negocio.
6. O ViewModel formata duracao para exibicao.
7. O ViewModel expoe linhas de exercicio prontas para SwiftUI.
8. Restricoes incompatíveis sao exibidas como aviso visual.

## DDD na Feature

O dominio continua sendo a fonte da verdade:

- `Workout` representa o treino.
- `Exercise` representa cada exercicio.
- `HealthRestriction` continua sendo conceito de dominio.

A Presentation apenas transforma esses objetos em estado de tela.

## TDD na Feature

Testes esperados:

- `testDetailsViewModelShouldExposeWorkoutTitle`
- `testDetailsViewModelShouldExposeExerciseRows`
- `testDetailsViewModelShouldFormatDuration`
- `testDetailsViewModelShouldExposeRestrictionWarnings`
- `testDetailsViewModelShouldNotRequireAIProvider`

Esses testes garantem que a tela de detalhes nao precisa de IA, provider, DTO ou repository.

## Riscos e Mitigacao

- Regra de negocio vazar para SwiftUI: mitigado com `WorkoutDetailsViewModel`.
- Tela depender de IA: mitigado recebendo apenas `Workout`.
- Duplicar validacao de dominio na UI: mitigado tratando a tela como exibicao de um treino ja valido.

## Limitacoes

- A tela e somente leitura.
- Nao ha edicao de exercicios.
- Nao ha persistencia de estado visual.
- O aviso de restricao usa os dados ja presentes em `Exercise`.
