import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({
    super.key,
    required this.item,
    required this.onRemoveItem,
  });

  final GroceryItem item;
  final void Function(GroceryItem) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        onRemoveItem(item);
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
