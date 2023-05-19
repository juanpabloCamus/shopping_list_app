import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';

class Grocery {
  const Grocery(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
