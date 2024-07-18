import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/categories_enum.dart';
import 'package:shopping_list/models/category.dart';

import '../../../../models/grocery_item.dart';

class NewItemScreen extends StatelessWidget {
  NewItemScreen({super.key});

  String selectedName = '';
  String selectedQuantity = '1';
  Category selectedCategory = categories[Categories.vegetables]!;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void addItem() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop(
          GroceryItem(
            id: DateTime.now().toString(),
            name: selectedName,
            quantity: int.parse(selectedQuantity),
            category: selectedCategory,
          ),
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
                      value.trim().length <= 1) {
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
                    child: const Text('Reset'),
                    onPressed: () {
                      formKey.currentState!.reset();
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: addItem,
                    child: const Text('Add item'),
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
