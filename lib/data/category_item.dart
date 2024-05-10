import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconItem {
  final String name;
  final List<IconData> icons;

  IconItem(this.name, this.icons);
}

List<IconItem> icons = [
  IconItem('Tài chính', [
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.moneyBillAlt,
    FontAwesomeIcons.coins,
    //Thêm icon tài chính khác ở đây
  ]),
  IconItem('Di chuyển', [
    FontAwesomeIcons.car,
    FontAwesomeIcons.bicycle,
    FontAwesomeIcons.bus,
    //Thêm icon di chuyển khác ở đây
  ]),
  IconItem('Mua sắm', [
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.tags,
    FontAwesomeIcons.barcode,
    FontAwesomeIcons.cartPlus,
    FontAwesomeIcons.cartArrowDown,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.store,
    FontAwesomeIcons.shoppingBasket,

  ]),
  IconItem('Đồ ăn thức uống', [
    FontAwesomeIcons.coffee,
    FontAwesomeIcons.beer,
    FontAwesomeIcons.wineGlass,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.pizzaSlice,
    FontAwesomeIcons.hamburger,
    FontAwesomeIcons.iceCream,
    FontAwesomeIcons.breadSlice,
    FontAwesomeIcons.cocktail,
    FontAwesomeIcons.appleAlt,
    FontAwesomeIcons.pepperHot,
    FontAwesomeIcons.candyCane,
  ]),
  IconItem('Sức khỏe', [
    FontAwesomeIcons.heartbeat,
    FontAwesomeIcons.stethoscope,
    FontAwesomeIcons.hospital,
    FontAwesomeIcons.syringe,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.pills,
    FontAwesomeIcons.mortarPestle,
    FontAwesomeIcons.briefcaseMedical,
    FontAwesomeIcons.virus,
    FontAwesomeIcons.virusSlash,
    FontAwesomeIcons.bacteria,
    FontAwesomeIcons.procedures,
    FontAwesomeIcons.solidHospital,
  ]),
  IconItem('Làm đẹp', [
    FontAwesomeIcons.smile,
    FontAwesomeIcons.female,
    FontAwesomeIcons.male,
    FontAwesomeIcons.venus,
    FontAwesomeIcons.mars,
    FontAwesomeIcons.venusMars,
    FontAwesomeIcons.fistRaised,
    FontAwesomeIcons.handHoldingHeart,
    FontAwesomeIcons.handPeace,
    FontAwesomeIcons.handshake,
    FontAwesomeIcons.kissWinkHeart,
    FontAwesomeIcons.solidSmile,
  ]),
  IconItem('Giải trí', [
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.music,
    FontAwesomeIcons.film,
    FontAwesomeIcons.ticketAlt,
    FontAwesomeIcons.headphones,
    FontAwesomeIcons.theaterMasks,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.images,
    FontAwesomeIcons.video,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.playCircle,
    FontAwesomeIcons.tv,
  ]),
  IconItem('Tập thể dục', [
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.running,
    FontAwesomeIcons.biking,
    FontAwesomeIcons.swimmer,
    FontAwesomeIcons.basketballBall,
    FontAwesomeIcons.footballBall,
    FontAwesomeIcons.volleyballBall,
    FontAwesomeIcons.baseballBall,
    FontAwesomeIcons.golfBall,
    FontAwesomeIcons.tableTennis,
    FontAwesomeIcons.skating,
    FontAwesomeIcons.skiing,
  ]),
  IconItem('Thư giãn', [
    FontAwesomeIcons.bed,
    FontAwesomeIcons.couch,
    FontAwesomeIcons.chair,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.hotTub,
    FontAwesomeIcons.swimmingPool,
    FontAwesomeIcons.campground,
    FontAwesomeIcons.smoking,
    FontAwesomeIcons.wineGlassAlt,
  ]),
  IconItem('Giáo dục', [
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.book,
    FontAwesomeIcons.school,
    FontAwesomeIcons.chalkboardTeacher,
    FontAwesomeIcons.microscope,
    FontAwesomeIcons.atom,
    FontAwesomeIcons.globe,
    FontAwesomeIcons.history,
    FontAwesomeIcons.language,
    FontAwesomeIcons.paintBrush,
    FontAwesomeIcons.code,
  ]),
  IconItem('Gia đình/Trẻ em', [
    FontAwesomeIcons.child,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.babyCarriage,
    FontAwesomeIcons.bath,
    FontAwesomeIcons.child,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.child,
  ]),
  //Thêm các đầu mục danh mục khác ở đây
];

// class CategoryItem {
//   final String name;
//   final IconData icon;
//   final Color color;
//
//   CategoryItem({
//     required this.name,
//     required this.icon,
//     required this.color
//   });
// }

class CategoryItem {
  final String name;
  final String icon; // Thay đổi kiểu dữ liệu của icon thành String
  final Color? color; // Thay đổi kiểu dữ liệu của color thành String

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  // Phương thức tạo từ dữ liệu Map
  CategoryItem.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        icon = map['icon'],
        color = map['color'] != null ? Color(int.parse(map['color'])) : null;

  // Phương thức chuyển đổi sang dữ liệu Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'color': color != null ? color!.value.toString() : null, // Chuyển đổi Color sang chuỗi màu
    };
  }
}


// List<CategoryItem> incomeCategories = [
//   CategoryItem(name: 'Lương', icon: FontAwesomeIcons.moneyBillAlt, color: Colors.red),
//   CategoryItem(name: 'Tiền thưởng', icon: FontAwesomeIcons.gift,  color: Colors.blue),
//   CategoryItem(name: 'hỏi', icon: FontAwesomeIcons.moneyBillAlt, color: Colors.yellow),
//   CategoryItem(name: 'chấm', icon: FontAwesomeIcons.gift, color: Colors.black),
//   CategoryItem(name: '?', icon: FontAwesomeIcons.gift, color: Colors.green),
//   CategoryItem(name: 'lol', icon: FontAwesomeIcons.car, color: Colors.deepPurpleAccent),
//   CategoryItem(name: 'xuan', icon: FontAwesomeIcons.airbnb, color: Colors.green),
//   CategoryItem(name: 'huy', icon: FontAwesomeIcons.addressBook, color: Colors.deepPurpleAccent),
//   // Thêm các danh mục thu nhập khác tại đây
// ];
//
// List<CategoryItem> expenseCategories = [
//   CategoryItem(name: 'Ăn uống', icon: FontAwesomeIcons.utensils, color: Colors.red),
//   CategoryItem(name: 'Di chuyển', icon: FontAwesomeIcons.car, color: Colors.blue),
//   CategoryItem(name: 'chơi game', icon: FontAwesomeIcons.utensils, color: Colors.yellow),
//   CategoryItem(name: 'bay lak', icon: FontAwesomeIcons.car, color: Colors.green),
//   CategoryItem(name: 'xam', icon: FontAwesomeIcons.utensils, color: Colors.deepPurpleAccent),
//   CategoryItem(name: 'lol', icon: FontAwesomeIcons.car, color: Colors.black),
//   // Thêm các danh mục chi tiêu khác tại đây
// ];

