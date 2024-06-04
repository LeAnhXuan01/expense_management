import 'enum.dart';

class Category {
  String categoryId;
  String userId;
  String name;
  TransactionType type;
  String icon;
  String color;

  Category({
    required this.categoryId,
    required this.userId,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'userId': userId,
      'name': name,
      'type': type.index,
      'icon': icon,
      'color': color,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'],
      userId: map['userId'],
      name: map['name'],
      type: TransactionType.values[map['type']],
      icon: map['icon'],
      color: map['color'],
    );
  }
}