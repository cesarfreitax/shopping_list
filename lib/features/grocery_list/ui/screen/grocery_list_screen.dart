import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/consts.dart';
import 'package:shopping_list/util/http_util.dart';

import '../../../../models/grocery_item.dart';
import '../widgets/grocery_item_widget.dart';
import '../../../new_item/ui/screen/new_item_screen.dart';

import 'package:http/http.dart' as http;

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> groceryItems = [];
  var isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    http.Response? response;

    try {
      response = await http.get(Consts().getItemsUrl);
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unexpected error! Please try again later...';
      });
      return;
    }


    if (response.statusCode >= 400) {
      setState(() {
        errorMessage = 'Fetching failed. Please try again later...';
        isLoading = false;
      });
      return;
    }

    if (response.body == 'null') {
      setState(() {
        isLoading = false;
      });
      return;
    }

    Map<String, dynamic> listData = jsonDecode(response.body);
    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final itemCategory = categories.entries.firstWhere(
          (category) => category.value.title == item.value['category']);

      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: itemCategory.value));
    }

    setState(() {
      groceryItems = loadedItems;
      isLoading = false;
    });

    HttpUtil().printHttpResponseLog(response);

    // for (final item in response.)
  }

  void addItem() async {
    final groceryItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    setState(() {
      groceryItems.add(groceryItem);
    });
  }

  void removeItem(GroceryItem groceryItem) async {
    final groceryItemIndex = groceryItems.indexOf(groceryItem);

    final response = await http.delete(Consts().getDeleteByIdUrl(groceryItem.id));

    setState(() {
      groceryItems.remove(groceryItem);
    });

    if (response.statusCode >= 400) {
      groceryItems.insert(groceryItemIndex, groceryItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget groceryListWidget = ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index) => GroceryItemWidget(
        item: groceryItems[index],
        onRemoveItem: removeItem,
      ),
    );

    Widget emptyGroceryListPlaceholder = const Center(
      child: Text('The list is empty. Add a new item.'),
    );

    Widget content = errorMessage != null
        ? Center(
            child: Text(errorMessage!),
          )
        : isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (groceryItems.isNotEmpty
                ? groceryListWidget
                : emptyGroceryListPlaceholder);

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
      body: content,
    );
  }
}
