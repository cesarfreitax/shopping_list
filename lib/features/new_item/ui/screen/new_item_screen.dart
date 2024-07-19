import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/categories_enum.dart';
import 'package:shopping_list/data/consts.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/util/http_util.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() {
    return _NewItemScreenState();
  }
}

class _NewItemScreenState extends State<NewItemScreen> {
  String selectedName = '';
  String selectedQuantity = '1';
  Category selectedCategory = categories[Categories.vegetables]!;
  final formKey = GlobalKey<FormState>();
  var isSaving = false;

  @override
  Widget build(BuildContext context) {
    void addItem() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        setState(() {
          isSaving = true;
        });

        final quantityParsedToInt = int.parse(selectedQuantity);

        final response = await http.post(Consts().getItemsUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': selectedName,
              'quantity': quantityParsedToInt,
              'category': selectedCategory.title
            }));

        HttpUtil().printHttpResponseLog(response);

      if (!context.mounted) {
      return;
      }

      if (response.statusCode >= 400) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unexpected error! Please try again later...'))
      );
      setState(() {
        isSaving = false;
      });
      }

      final responseData = jsonDecode(response.body);

      Navigator.of(context).pop(GroceryItem(
      id: responseData['name'],
      name: selectedName,
      quantity: quantityParsedToInt,
      category: selectedCategory
      )
      );
    }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New item'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value
                          .trim()
                          .length <= 1) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  selectedName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 1) {
                          return 'Must be between 1 and 50 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        selectedQuantity = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                            onTap: () {},
                          )
                      ],
                      onChanged: (value) {
                        selectedCategory = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () {
                      formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: isSaving ? null : addItem,
                    child: isSaving
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    )
                        : const Text('Add item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
