import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableTile extends StatelessWidget {
  const SlidableTile({
    Key? key,
    required this.tile,
    required this.editAction,
    required this.deleteAction,
  }) : super(key: key);

  final ListTile tile;
  final void Function(BuildContext context) editAction;
  final void Function(BuildContext context) deleteAction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: editAction,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icons.edit,
            label: '編集',
          ),
          SlidableAction(
            onPressed: deleteAction,
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),
      child: tile,
    );
  }
}
