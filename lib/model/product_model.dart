// lib/models/products.dart
import 'package:hive/hive.dart';
  
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Products extends HiveObject{
  @HiveField(0)
  String itemName;

  @HiveField(1)
  String itemType;

  @HiveField(2)
  String productName;
  
  @HiveField(3)
  double size;
  
  @HiveField(4)
  double qty;
  
  @HiveField(5)
  double price;

  @HiveField(6)
  String? imagePath;

  Products({
    required this.itemName,
    required this.itemType,
    required this.productName,
    required this.size,
    required this.qty,
    required this.price,
    this.imagePath,
  });
}