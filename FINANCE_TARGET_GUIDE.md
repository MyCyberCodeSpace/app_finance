# Guia de Metas Financeiras (Finance Target)

## Visão Geral

O sistema de metas financeiras permite que usuários criem objetivos de economia com depósitos recorrentes. Ao criar uma meta, o sistema automaticamente cria um tipo financeiro vinculado para rastrear os depósitos relacionados.

## Estrutura da Tabela

### finance_target

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | INTEGER | Identificador único |
| `label` | TEXT | Nome da meta (ex: "Férias na Europa") |
| `target_value` | REAL | Valor total da meta |
| `current_value` | REAL | Valor já economizado |
| `desired_deposit` | REAL | Valor desejado por depósito |
| `recurrency_days` | INTEGER | Dias entre cada depósito |
| `type_id` | INTEGER | FK para finance_types (criado automaticamente) |
| `due_date` | TEXT | Data limite (opcional) |
| `created_at` | TEXT | Data de criação |
| `updated_at` | TEXT | Data da última atualização |

## Funcionalidades

### 1. Criar Meta Financeira

Ao criar uma nova meta:

```dart
final target = FinanceTargetModel(
  label: 'Viagem para o Japão',
  targetValue: 15000.0,
  currentValue: 0.0,
  desiredDeposit: 500.0,  // Depositar R$ 500 a cada
  recurrencyDays: 30,      // 30 dias (mensalmente)
  typeId: 0,               // Será preenchido automaticamente
  dueDate: DateTime(2027, 12, 31),
);

final targetId = await repository.create(target);
```

**O que acontece automaticamente:**
1. É criado um tipo financeiro com:
   - Nome: mesmo da meta ("Viagem para o Japão")
   - Categoria: `income` (receita/entrada)
   - Ícone: `savings`
   - Cor: verde (#4CAF50)
   - Limite: desabilitado

2. O `type_id` é vinculado automaticamente à meta

### 2. Atualizar Meta

Ao atualizar uma meta, o nome do tipo vinculado também é atualizado:

```dart
final updatedTarget = target.copyWith(
  label: 'Viagem para o Japão - 2028',
  desiredDeposit: 600.0,
);

await repository.update(updatedTarget);
```

### 3. Deletar Meta

Ao deletar uma meta:
- Verifica se existem registros financeiros vinculados ao tipo
- Se SIM: lança exceção (não permite deletar)
- Se NÃO: deleta o tipo E a meta

```dart
try {
  await repository.delete(targetId);
} catch (e) {
  // 'Não é possível excluir esta meta: existem registros vinculados ao tipo.'
}
```

## Cálculos Úteis

### Quantos depósitos são necessários?

```dart
int depositsNeeded(FinanceTargetModel target) {
  final remaining = target.targetValue - target.currentValue;
  return (remaining / target.desiredDeposit).ceil();
}
```

### Quando a meta será alcançada?

```dart
DateTime estimatedCompletionDate(FinanceTargetModel target) {
  final deposits = depositsNeeded(target);
  final totalDays = deposits * target.recurrencyDays;
  return DateTime.now().add(Duration(days: totalDays));
}
```

### Progresso percentual

```dart
double progressPercentage(FinanceTargetModel target) {
  return (target.currentValue / target.targetValue) * 100;
}
```

## Registrando Depósitos

Para registrar um depósito na meta, crie um registro financeiro usando o `type_id` da meta:

```dart
final record = FinanceRecordModel(
  date: DateTime.now(),
  value: target.desiredDeposit,
  typeId: target.typeId,  // Tipo vinculado à meta
  paymentId: 1,
  description: 'Depósito mensal - ${target.label}',
  isRecurring: false,
);

await financeRecordRepository.create(record);

// Atualizar current_value da meta
final updatedTarget = target.copyWith(
  currentValue: target.currentValue + target.desiredDeposit,
  updatedAt: DateTime.now(),
);
await financeTargetRepository.update(updatedTarget);
```

## Exemplos de Uso

### Meta de curto prazo (semanal)
```dart
FinanceTargetModel(
  label: 'Presente de aniversário',
  targetValue: 300.0,
  currentValue: 0.0,
  desiredDeposit: 50.0,
  recurrencyDays: 7,  // Semanal
  typeId: 0,
)
```

### Meta de longo prazo (mensal)
```dart
FinanceTargetModel(
  label: 'Entrada do apartamento',
  targetValue: 50000.0,
  currentValue: 15000.0,
  desiredDeposit: 2000.0,
  recurrencyDays: 30,  // Mensal
  typeId: 0,
  dueDate: DateTime(2028, 12, 31),
)
```

### Meta sem prazo (fundo de emergência)
```dart
FinanceTargetModel(
  label: 'Fundo de emergência',
  targetValue: 20000.0,
  currentValue: 5000.0,
  desiredDeposit: 500.0,
  recurrencyDays: 30,
  typeId: 0,
  dueDate: null,  // Sem data limite
)
```

## Integração com Finance Records

Todos os depósitos feitos para uma meta aparecem nos registros financeiros normalmente, pois usam o tipo criado automaticamente. Isso permite:

1. Rastrear historicamente todos os depósitos
2. Filtrar registros por meta específica (usando o type_id)
3. Visualizar no dashboard os valores depositados
4. Aplicar regras de recorrência aos depósitos

## Migração de Dados Existentes

Se você já tem metas no banco sem os novos campos, precisará:

1. Deletar o banco de dados atual (ou incrementar a versão)
2. Os dados iniciais serão recriados com os tipos vinculados
3. Metas existentes de usuários precisarão de migração manual

## Validações Recomendadas

- `desiredDeposit` deve ser > 0
- `recurrencyDays` deve ser > 0
- `targetValue` deve ser > `currentValue`
- `label` não pode estar vazio
