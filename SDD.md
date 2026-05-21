# AIWorkoutCoach Software Design Document

## Objetivo

AIWorkoutCoach e um projeto didatico em Swift para demonstrar DDD, SDD e TDD em uma funcionalidade de recomendacao de plano de treino usando IA, sem acoplar o dominio a um provedor externo.

## Escopo

O exemplo cobre o fluxo de geracao de um plano semanal de treino:

1. Receber uma solicitacao de recomendacao.
2. Montar um prompt fora do dominio.
3. Chamar um provider de IA por protocolo.
4. Validar a resposta da IA como DTO.
5. Converter o DTO em entidades de dominio.
6. Validar regras de negocio.
7. Persistir o plano em um repositorio em memoria.
8. Expor o resultado em uma tela SwiftUI simples.

Nao ha banco real, rede ou chamada real para OpenAI, Gemini, Claude ou qualquer outro provedor. A UI existe apenas como app demo para capturar a intencao do usuario e exibir o estado.

## Problema Resolvido

Projetos com IA frequentemente deixam prompt, JSON e provider externo vazarem para regras de negocio. Este exemplo mostra como manter a IA como mecanismo de infraestrutura/aplicacao, preservando um dominio testavel e independente.

## Arquitetura Proposta

A arquitetura separa cinco areas:

- Domain: regras de negocio, entidades, value objects, contratos de repositorio e validadores de dominio.
- Application: caso de uso que orquestra o fluxo.
- AI: provider por protocolo, mock, prompt builder, DTOs, validacao da resposta e mapper.
- Infrastructure: implementacao concreta do repositorio em memoria.
- Presentation: ViewModel que expoe loading, plano e erro para a tela.

Dependencia principal:

Application -> Domain, AI
AI -> Domain apenas no mapper e em tipos de entrada compartilhados
Infrastructure -> Domain
Presentation -> Application, Domain
Domain -> nenhuma camada externa

## Divisao de Camadas

### Domain

Contem:

- User
- WorkoutPlan
- Workout
- Exercise
- TrainingGoal
- FitnessLevel
- HealthRestriction
- WorkoutRecommendationInput
- WorkoutRecommendation
- WorkoutPlanRepository
- WorkoutPlanValidator
- WorkoutPlanError

O dominio nao conhece prompt, JSON, DTO, resposta bruta de IA, banco, UI ou provider externo.

### Application

Contem `GenerateWorkoutPlanUseCase`, responsavel por coordenar o fluxo. Ele nao cria regras de negocio novas; ele chama os componentes corretos na ordem correta.

### AI

Contem:

- `AIRecommendationProvider`
- `MockAIRecommendationProvider`
- `WorkoutPromptBuilder`
- DTOs da resposta da IA
- `AIResponseValidator`
- `WorkoutPlanMapper`

A resposta da IA e validada antes de ser convertida para entidade de dominio.

### Infrastructure

Contem `InMemoryWorkoutPlanRepository`, usado para testes e demonstracao.

### Presentation

Contem `WorkoutPlanViewModel`, responsavel por expor estado para SwiftUI:

- `isLoading`
- `workoutPlan`
- `errorMessage`

Presentation nao contem regra de negocio. Ela captura a intencao do usuario e delega para o use case.

### Demo App

O target `AIWorkoutCoachDemoApp` e um app SwiftUI minimo. A tela principal permite tocar em `Gerar treino`, chama o ViewModel e exibe o plano retornado pelo mock de IA.

Features incrementais podem ter SDDs proprios. A tela de detalhes de treino esta documentada em `docs/SDD-WorkoutDetails.md`, sem substituir este SDD principal.

## Entidades do Dominio

- `User`: representa o usuario e suas restricoes de saude.
- `WorkoutPlan`: plano semanal de treino.
- `Workout`: treino individual dentro do plano.
- `Exercise`: exercicio com nome, grupo muscular, duracao e restricoes incompatíveis.

## Value Objects

- `TrainingGoal`: hypertrophy, strength, weightLoss, mobility.
- `FitnessLevel`: beginner, intermediate, advanced.
- `HealthRestriction`: restricao declarada pelo usuario.
- `WorkoutRecommendationInput`: entrada do caso de uso.
- `WorkoutRecommendation`: resultado conceitual da recomendacao.

## Como o DDD Esta Coberto

Este projeto cobre DDD colocando o dominio no centro e mantendo dependencias externas nas bordas.

Mapeamento explicito:

- Linguagem ubiqua: nomes como `WorkoutPlan`, `Workout`, `Exercise`, `TrainingGoal`, `FitnessLevel` e `HealthRestriction` aparecem no codigo, nos testes e no SDD.
- Entities: `User`, `WorkoutPlan`, `Workout` e `Exercise`.
- Value Objects: `TrainingGoal`, `FitnessLevel`, `HealthRestriction`, `WorkoutRecommendationInput` e `WorkoutRecommendation`.
- Domain Service: `WorkoutPlanValidator`, que valida regras envolvendo o plano e as restricoes do usuario.
- Repository Protocol: `WorkoutPlanRepository`, definido no dominio.
- Infrastructure separada: `InMemoryWorkoutPlanRepository`, implementado fora do dominio.
- Use Case: `GenerateWorkoutPlanUseCase`, na camada Application, orquestra o fluxo sem colocar regra de negocio na UI.
- Mappers: `WorkoutPlanMapper`, na camada AI, converte DTO em entidade de dominio depois da validacao.
- DTOs fora do dominio: `AIWorkoutPlanResponseDTO`, `AIWorkoutDTO` e `AIExerciseDTO` ficam na camada AI.

Regras de negocio no dominio:

- `WorkoutPlan` exige pelo menos 1 treino.
- `WorkoutPlan` nao permite mais de 7 treinos.
- `Workout` exige pelo menos 3 exercicios.
- `Exercise` exige nome, grupo muscular e duracao positiva.
- `WorkoutPlanValidator` rejeita exercicios incompativeis com restricoes de saude do usuario.

Fronteiras protegidas:

- Domain nao importa AI.
- Domain nao importa Infrastructure.
- Domain nao importa SwiftUI.
- Domain nao conhece JSON.
- Domain nao conhece prompt.
- Domain nao conhece OpenAI, Gemini, Claude ou qualquer provedor externo.

## Contratos de Entrada e Saida da IA

Entrada para IA:

- Prompt textual gerado por `WorkoutPromptBuilder`.
- Dados usados no prompt: nome do usuario, objetivo, nivel, dias disponiveis e restricoes.
- `WorkoutRecommendationInput`, recebido pelo provider por protocolo para permitir implementacoes futuras com contexto estruturado.

Saida da IA:

- `AIWorkoutPlanResponseDTO`
- `AIWorkoutDTO`
- `AIExerciseDTO`

Esses DTOs pertencem a camada AI e nao entram no dominio sem validacao e mapeamento.

## Estrategia de Prompt

O prompt e construido por `WorkoutPromptBuilder`, fora do dominio. Ele inclui:

- objetivo de treino;
- nivel de condicionamento;
- dias disponiveis por semana;
- restricoes de saude;
- instrucao para retornar dados estruturados.

## Estrategia de Validacao

Existem duas etapas:

1. `AIResponseValidator`: valida estrutura e regras minimas da resposta da IA antes do mapper.
2. `WorkoutPlanValidator` e inicializadores de entidades: aplicam regras de dominio.

Regras principais:

- Plano deve ter entre 1 e 7 treinos.
- Cada treino deve ter ao menos 3 exercicios.
- Cada exercicio deve ter nome, grupo muscular e duracao positiva.
- Restricoes de saude do usuario nao podem conflitar com exercicios do plano.

## Estrategia de Testes

Os testes usam XCTest e mocks/fakes. Nao existe chamada externa.

Cobertura:

- regras de entidade;
- validacao de dominio;
- validacao de DTO da IA;
- mapper DTO -> dominio;
- use case;
- repositorio em memoria;
- prompt builder.
- view model e estados de loading/erro.

## Como o TDD Esta Coberto

O projeto cobre TDD por meio de testes automatizados que descrevem o comportamento esperado antes ou junto da implementacao. A suite funciona como documentacao executavel da arquitetura.

Mapeamento explicito dos testes:

- `WorkoutPlanTests`: cobre invariantes das entidades `WorkoutPlan`, `Workout` e `Exercise`.
- `WorkoutPlanValidatorTests`: cobre a regra de incompatibilidade entre exercicios e `HealthRestriction`.
- `AIResponseValidatorTests`: cobre validacao de resposta invalida da IA e conteudo do prompt.
- `WorkoutPlanMapperTests`: cobre conversao de DTO da IA para entidade de dominio.
- `GenerateWorkoutPlanUseCaseTests`: cobre o fluxo de sucesso e garante que plano invalido nao e persistido.
- `InMemoryWorkoutPlanRepositoryTests`: cobre persistencia fake/in-memory.
- `WorkoutPlanViewModelTests`: cobre estado de loading e exposicao de erro na Presentation.

Testes obrigatorios cobertos:

- `testWorkoutPlanShouldNotAllowMoreThanSevenWorkouts`
- `testWorkoutPlanShouldRequireAtLeastOneWorkout`
- `testWorkoutShouldRequireAtLeastThreeExercises`
- `testExerciseShouldRequirePositiveDuration`
- `testValidatorShouldRejectPlanWithExerciseIncompatibleWithHealthRestriction`
- `testUseCaseShouldReturnValidWorkoutPlanWhenAIResponseIsValid`
- `testUseCaseShouldNotPersistPlanWhenAIResponseIsInvalid`
- `testMapperShouldConvertAIResponseDTOToDomainEntity`
- `testRepositoryShouldSaveAndFindWorkoutPlan`
- `testPromptBuilderShouldIncludeGoalFitnessLevelAndAvailableDays`
- `testViewModelShouldSetLoadingStateWhenGeneratingPlan`
- `testViewModelShouldExposeErrorWhenUseCaseFails`

Todos os testes usam mocks ou fakes. Nenhum teste chama IA real.

## Riscos e Mitigacao

- Resposta imprevisivel da IA: mitigada com DTO e `AIResponseValidator`.
- Acoplamento com provider: mitigado com `AIRecommendationProvider`.
- Regras duplicadas entre AI e dominio: a validacao de IA e estrutural/minima; a autoridade final permanece no dominio.
- Persistir plano invalido: o use case so salva depois da validacao completa.
- UI contendo regra de negocio: mitigado deixando Presentation apenas com estado e delegacao para o use case.

## Decisoes Tecnicas

- Swift Package para facilitar `swift test`.
- Xcode project gerado com XcodeGen para rodar app demo no simulador.
- Sem dependencias externas.
- `async throws` em provider e repositorio para representar chamadas reais futuras.
- Actor no repositorio em memoria para estado mutavel seguro.
- DTOs ficam fora do dominio.
- SwiftUI fica fora do dominio, no app demo e na Presentation.

## Limitacoes do Exemplo

- Nao ha banco de dados real.
- Nao ha parsing JSON real.
- Nao ha autenticacao nem historico de usuario.
- O app visual e propositalmente simples.
- O mock de IA simula sucesso, resposta invalida, erro e timeout.
- O objetivo e clareza arquitetural para tech talk, nao completude de produto.
