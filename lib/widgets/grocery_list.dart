import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';

import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error = null;

  @override
  void initState() {
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('shopping-list-app-ec453-default-rtdb.firebaseio.com',
        'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Fail to fetch data, please try again later...';
      });
    } else {
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((cat) => cat.value.title == item.value['category'])
            .value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItem();
        },
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    final url = Uri.https('shopping-list-app-ec453-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    http.delete(url);

    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _groceryItems.isEmpty
              ? const Center(
                  child: Text(
                  'There are no items in the list yet.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ))
              : ListView.builder(
                  itemCount: _groceryItems.length,
                  itemBuilder: (ctx, index) => Dismissible(
                    key: ValueKey(_groceryItems[index].id),
                    onDismissed: (direction) {
                      _removeItem(_groceryItems[index]);
                    },
                    child: ListTile(
                      title: Text(
                        _groceryItems[index].name,
                      ),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: _groceryItems[index].category.color,
                      ),
                      trailing: Text(
                        _groceryItems[index].quantity.toString(),
                      ),
                    ),
                  ),
                ),
    );
  }
}
