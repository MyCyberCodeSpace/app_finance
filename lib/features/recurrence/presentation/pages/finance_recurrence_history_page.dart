import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_movement_model.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:finance_control/features/recurrence/domain/repository/finance_recurrence_movement_repository.dart';

class FinanceRecurrenceHistoryPage extends StatefulWidget {
  final FinanceRecurrenceModel recurrence;

  const FinanceRecurrenceHistoryPage({
    super.key,
    required this.recurrence,
  });

  @override
  State<FinanceRecurrenceHistoryPage> createState() =>
      _FinanceRecurrenceHistoryPageState();
}

class _FinanceRecurrenceHistoryPageState
    extends State<FinanceRecurrenceHistoryPage> {
  late final FinanceRecurrenceMovementRepository repository;
  late Future<List<FinanceRecurrenceMovementModel>> movements;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<FinanceRecurrenceMovementRepository>();
    movements = repository.getByRecurrenceId(widget.recurrence.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Histórico - ${widget.recurrence.label}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildRecurrenceHeader(),
          Expanded(
            child: FutureBuilder<List<FinanceRecurrenceMovementModel>>(
              future: movements,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar histórico: ${snapshot.error}',
                    ),
                  );
                }

                final movementsList = snapshot.data ?? [];

                if (movementsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 80,
                          color: AppColors.gray.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma movimentação registrada',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movementsList.length,
                  itemBuilder: (context, index) {
                    final movement = movementsList[index];
                    return _buildMovementCard(movement);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurrenceHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recurrence.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valor',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    Text(
                      'R\$ ${widget.recurrence.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    Text(
                      widget.recurrence.recurrenceType.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(
              widget.recurrence.isActive ? 'Ativa' : 'Inativa',
              style: TextStyle(
                fontSize: 12,
                color: widget.recurrence.isActive
                    ? Colors.white
                    : AppColors.gray.shade600,
              ),
            ),
            backgroundColor: widget.recurrence.isActive
                ? AppColors.positiveBalance
                : AppColors.gray.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(FinanceRecurrenceMovementModel movement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R\$ ${movement.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.positiveBalance,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(movement.executionDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (movement.description != null &&
              movement.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Descrição',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              movement.description!,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray.shade700,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: AppColors.gray.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                'Criada em: ${DateFormat('dd/MM/yyyy').format(movement.createdAt)}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.gray.shade500,
                ),
              ),
              const SizedBox(width: 16),
              if (movement.updatedAt != null) ...[
                Icon(
                  Icons.edit_outlined,
                  size: 12,
                  color: AppColors.gray.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  'Atualizada em: ${DateFormat('dd/MM/yyyy').format(movement.updatedAt!)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.gray.shade500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
