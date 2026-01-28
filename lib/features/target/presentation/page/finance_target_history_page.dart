import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:finance_control/features/target/domain/model/finance_target_movement_model.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:finance_control/features/target/domain/repository/finance_target_repository.dart';

class FinanceTargetHistoryPage extends StatefulWidget {
  final FinanceTargetModel target;

  const FinanceTargetHistoryPage({super.key, required this.target});

  @override
  State<FinanceTargetHistoryPage> createState() => _FinanceTargetHistoryPageState();
}

class _FinanceTargetHistoryPageState extends State<FinanceTargetHistoryPage> {
  late final FinanceTargetRepository repository;
  late Future<List<FinanceTargetMovementModel>> movementsFuture;
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<FinanceTargetRepository>();
    _loadMovements();
  }

  void _loadMovements() {
    movementsFuture = repository.getMovementsByTargetId(widget.target.id!);
  }

  Future<void> _selectFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _from = picked);
  }

  Future<void> _selectToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _to ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _to = picked);
  }

  List<FinanceTargetMovementModel> _applyFilter(List<FinanceTargetMovementModel> list) {
    if (_from == null && _to == null) return list;
    return list.where((m) {
      final date = m.date;
      if (_from != null && date.isBefore(DateTime(_from!.year, _from!.month, _from!.day))) return false;
      if (_to != null && date.isAfter(DateTime(_to!.year, _to!.month, _to!.day, 23, 59, 59))) return false;
      return true;
    }).toList();
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
          'Histórico - ${widget.target.label}',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectFromDate,
                    child: Text(_from == null ? 'De' : DateFormat('dd/MM/yyyy').format(_from!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectToDate,
                    child: Text(_to == null ? 'Até' : DateFormat('dd/MM/yyyy').format(_to!)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Filtrar'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () { setState(() { _from = null; _to = null; }); },
                  child: const Text('Limpar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FinanceTargetMovementModel>>(
              future: movementsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar histórico: ${snapshot.error}'));
                }

                final list = _applyFilter(snapshot.data ?? []);
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 80, color: AppColors.gray.shade400),
                        const SizedBox(height: 16),
                        Text('Nenhuma movimentação registrada', style: TextStyle(fontSize: 16, color: AppColors.gray.shade600)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final movement = list[index];
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

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [BoxShadow(color: AppColors.gray.shade100, blurRadius: 4, offset: const Offset(0,2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.target.label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Valor da Meta', style: TextStyle(fontSize: 12, color: AppColors.gray.shade600)),
                    Text('R\$ ${widget.target.targetValue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Valor Atual', style: TextStyle(fontSize: 12, color: AppColors.gray.shade600)),
                    Text('R\$ ${widget.target.currentValue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(FinanceTargetMovementModel movement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [BoxShadow(color: AppColors.gray.shade100, blurRadius: 4, offset: const Offset(0,2))],
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
                    Text('R\$ ${movement.value.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: movement.type == 'entrada' ? AppColors.positiveBalance : AppColors.nevagativeBalance)),
                    const SizedBox(height: 4),
                    Text(DateFormat('dd/MM/yyyy HH:mm').format(movement.date), style: TextStyle(fontSize: 12, color: AppColors.gray.shade600)),
                  ],
                ),
              ),
            ],
          ),
          if (movement.description != null && movement.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Descrição', style: TextStyle(fontSize: 12, color: AppColors.gray.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(movement.description!, style: TextStyle(fontSize: 13, color: AppColors.gray.shade700)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.gray.shade500),
              const SizedBox(width: 4),
              Text('Criada em: ${DateFormat('dd/MM/yyyy').format(movement.createdAt)}', style: TextStyle(fontSize: 11, color: AppColors.gray.shade500)),
              const SizedBox(width: 16),
              if (movement.updatedAt != null) ...[
                Icon(Icons.edit_outlined, size: 12, color: AppColors.gray.shade500),
                const SizedBox(width: 4),
                Text('Atualizada em: ${DateFormat('dd/MM/yyyy').format(movement.updatedAt!)}', style: TextStyle(fontSize: 11, color: AppColors.gray.shade500)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
