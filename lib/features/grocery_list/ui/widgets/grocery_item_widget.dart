import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({
    super.key,
    required this.item,
    required this.onToggleItem,
  });

  final GroceryItem item;
  final void Function(GroceryItem) onToggleItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onToggleItem(item);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('An item was removed.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              onToggleItem(item);
            },
          ),
        ));
      },
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          color: item.category.color,
        ),
        title: Text(item.name),
        trailing: Text(item.quantity.toString()),
        onTap: () {},
      ),
    );
  }
}
