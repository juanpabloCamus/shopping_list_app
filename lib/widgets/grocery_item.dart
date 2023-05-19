import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem({super.key, required this.item});

  final Grocery item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: item.category.color),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            item.name,
            style: const TextStyle(fontSize: 20),
          ),
          const Spacer(),
          Text(
            item.quantity.toString(),
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
