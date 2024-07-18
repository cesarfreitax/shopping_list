import 'package:flutter/material.dart';

import '../../../../models/grocery_item.dart';
import '../widgets/grocery_item_widget.dart';
import '../../../new_item/ui/screen/new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> groceryItems = [];

  void addItem() async {
    GroceryItem? groceryItem = await Navigator.of(context).push<GroceryItem?>(
        MaterialPageRoute(builder: (ctx) => NewItemScreen()));

    if (groceryItem == null) {
      return;
    }

    setState(() {
      groceryItems.add(groceryItem);
    });
  }

  void toggleItem(GroceryItem groceryItem) {
    if (groceryItems.contains(groceryItem)) {
      setState(() {
        groceryItems.remove(groceryItem);
      });
    } else {
      setState(() {
        groceryItems.add(groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget groceryListWidget = ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index) => GroceryItemWidget(
        item: groceryItems[index],
        onToggleItem: toggleItem,
      ),
    );

    Widget emptyGroceryListPlaceholder = const Center(
      child: Text('The list is empty. Add a new item.'),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addItem,
          )
        ],
        title: const Text('Your Groceries'),
      ),
      body: groceryItems.isNotEmpty
          ? groceryListWidget
          : emptyGroceryListPlaceholder,
    );
  }
}
