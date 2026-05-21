# AIWorkoutCoach

Projeto exemplo em Swift para uma tech talk sobre DDD + SDD + TDD aplicados a uma funcionalidade com IA.

O objetivo e demonstrar como gerar uma recomendacao de plano de treino usando IA sem acoplar o dominio a prompt, DTO, JSON, UI, banco de dados ou provedor externo.

## Como Abrir no Xcode

O projeto possui um Xcode project gerado:

```bash
open AIWorkoutCoach.xcodeproj
```

No Xcode, use o scheme `AIWorkoutCoachDemoApp` para rodar o app no simulador.

Tambem e possivel abrir apenas o Swift Package:

```bash
open Package.swift
```

## Como Rodar os Testes

Pelo terminal:

```bash
swift test
```

Pelo Xcode:

1. Abra `AIWorkoutCoach.xcodeproj`.
2. Selecione o scheme `AIWorkoutCoach`.
3. Use `Cmd + U`.

## Como Rodar o App Demo

1. Abra `AIWorkoutCoach.xcodeproj`.
2. Selecione o scheme `AIWorkoutCoachDemoApp`.
3. Escolha um iPhone Simulator.
4. Use `Cmd + R`.
5. Na tela principal, toque em `Gerar treino`.

O app usa `MockAIRecommendationProvider`; nenhuma chamada real para IA e feita.

## Camadas

```text
AIWorkoutCoach
├── Sources/AIWorkoutCoach
│   ├── Domain
│   ├── Application
│   ├── AI
│   ├── Infrastructure
│   └── Presentation
├── AIWorkoutCoachDemoApp
├── docs
│   └── SDD-WorkoutDetails.md
├── Tests/AIWorkoutCoachTests
├── SDD.md
├── README.md
├── Package.swift
└── AIWorkoutCoach.xcodeproj
```

## Explicacao Rapida das Camadas

- Domain: entidades, value objects, erros, validadores de dominio e protocolo de repositorio.
- Application: `GenerateWorkoutPlanUseCase`, que orquestra o fluxo.
- AI: prompt builder, provider por protocolo, mock, DTOs, validator e mapper.
- Infrastructure: `InMemoryWorkoutPlanRepository`.
- Presentation: `WorkoutPlanViewModel`, que expoe estado para a tela.
- Demo App: SwiftUI app que captura a intencao do usuario e exibe o plano.

## Como a IA Foi Isolada

A IA e acessada por `AIRecommendationProvider`. O mock permite simular:

- sucesso;
- resposta invalida;
- erro;
- timeout.

A resposta da IA entra como DTO, passa por `AIResponseValidator` e so depois e convertida pelo `WorkoutPlanMapper` em entidade de dominio.

## Como o DDD Aparece

O dominio fica em `Sources/AIWorkoutCoach/Domain` e concentra a linguagem do negocio:

- `WorkoutPlan`
- `Workout`
- `Exercise`
- `TrainingGoal`
- `FitnessLevel`
- `HealthRestriction`
- `WorkoutPlanRepository`
- `WorkoutPlanValidator`

O dominio nao importa AI, Infrastructure, SwiftUI, JSON, prompt ou OpenAI.

Mapeamento direto:

- Entities: `User`, `WorkoutPlan`, `Workout`, `Exercise`.
- Value Objects: `TrainingGoal`, `FitnessLevel`, `HealthRestriction`, `WorkoutRecommendationInput`, `WorkoutRecommendation`.
- Domain Service: `WorkoutPlanValidator`.
- Repository Protocol: `WorkoutPlanRepository`.
- Infrastructure separada: `InMemoryWorkoutPlanRepository`.
- Use Case: `GenerateWorkoutPlanUseCase`.
- DTOs e mapper fora do dominio: `AIWorkoutPlanResponseDTO`, `AIWorkoutDTO`, `AIExerciseDTO`, `WorkoutPlanMapper`.

## Como o SDD Aparece

O arquivo `SDD.md` documenta:

- objetivo;
- escopo;
- arquitetura;
- divisao de camadas;
- contrato de IA;
- estrategia de prompt;
- estrategia de validacao;
- estrategia de testes;
- riscos e mitigacoes;
- limitacoes do exemplo.

Para a feature de detalhes de treino, existe um SDD incremental em `docs/SDD-WorkoutDetails.md`. Ele documenta apenas a tela de detalhes, suas regras de UI, testes e fronteiras arquiteturais.

## Como o TDD Aparece

Os testes em `Tests/AIWorkoutCoachTests` cobrem:

- regras de dominio;
- validacao de plano;
- validacao de resposta da IA;
- mapper DTO -> dominio;
- use case;
- repository;
- view model.

Todos os testes usam mocks ou fakes. Nenhum teste chama IA real.

Mapeamento direto:

- `WorkoutPlanTests`: regras de entidade.
- `WorkoutPlanValidatorTests`: restricoes de saude.
- `AIResponseValidatorTests`: resposta de IA e prompt.
- `WorkoutPlanMapperTests`: DTO para dominio.
- `GenerateWorkoutPlanUseCaseTests`: fluxo de sucesso e falha.
- `InMemoryWorkoutPlanRepositoryTests`: persistencia fake.
- `WorkoutPlanViewModelTests`: loading e erro na Presentation.

## Fluxo Principal

1. A tela chama `WorkoutPlanViewModel`.
2. O ViewModel chama `GenerateWorkoutPlanUseCase`.
3. O Use Case recebe `WorkoutRecommendationInput`.
4. `WorkoutPromptBuilder` monta o prompt.
5. `AIRecommendationProvider` retorna um DTO mockado.
6. `AIResponseValidator` valida a resposta.
7. `WorkoutPlanMapper` converte DTO em dominio.
8. `WorkoutPlanValidator` aplica regras de negocio.
9. `WorkoutPlanRepository` persiste o plano.
10. O ViewModel expoe o resultado para a tela.

## Roteiro Sugerido para a Tech Talk

1. Abra `SDD.md` e explique as decisoes antes do codigo.
2. Mostre `Domain` e destaque que nao ha dependencia de IA ou UI.
3. Mostre `AIRecommendationProvider` e `MockAIRecommendationProvider`.
4. Mostre `AIResponseValidator` e `WorkoutPlanMapper`.
5. Abra `GenerateWorkoutPlanUseCase` para explicar a orquestracao.
6. Rode `swift test`.
7. Abra `AIWorkoutCoachDemoApp` no simulador.
8. Toque em `Gerar treino` e mostre que a UI usa mock de IA.
9. Toque em um treino para abrir a tela de detalhes.

## Agentes no Processo

Esta branch inclui um exemplo de agente de processo em `docs/agents/ProjectGuardianAgent.md`.

O agente valida o SDD, as fronteiras de DDD e a estrategia de TDD antes da implementacao de uma nova feature. O exemplo aplicado esta em `docs/agents/ProjectGuardianAgent-WorkoutPerformanceCharts-Report.md`.
