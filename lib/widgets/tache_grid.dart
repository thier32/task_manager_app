import 'package:flutter/material.dart';
import 'package:task_manager_app/models/tache.dart';
import 'tache_item.dart';

class TacheGrid extends StatelessWidget {
  final List<Tache> taches;
  final Function(int, bool?) onCheckboxChanged;
  final Function(int) onDeletePressed;
  final Function(int) onEditPressed;

  const TacheGrid({
    super.key,
    required this.taches,
    required this.onCheckboxChanged,
    required this.onDeletePressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (taches.isEmpty) {
      return const Center(
        child: Text(
          'Aucune tâche pour le moment. Ajoutez-en une !',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),     
      itemCount: taches.length,
      itemBuilder: (context, index) {
        final tache = taches[index];
        return TacheItem(
          tache: tache,
          onCheckboxChanged: (valeur) => onCheckboxChanged(index, valeur),
          onDeletePressed: () => onDeletePressed(index),
          onEditPressed: () => onEditPressed(index),
        );
      },
    );
  }
}