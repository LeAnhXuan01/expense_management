import '../model/category_model.dart';
import '../model/enum.dart';

List<Category> defaultCategories = [
  Category(
    categoryId: 'default_expense_1',
    userId: 'default',
    name: 'Đồ ăn & Thức uống',
    type: TransactionType.expense,
    icon: 'IconData(U+0F2E7)', // FontAwesomeIcons.utensils
    color: 'MaterialColor(primary value: Color(0xffff5722))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_2',
    userId: 'default',
    name: 'Mua sắm',
    type: TransactionType.expense,
    icon: 'IconData(U+0F290)', // FontAwesomeIcons.shoppingBag
    color: 'MaterialColor(primary value: Color(0xff9c27b0))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_3',
    userId: 'default',
    name: 'Di chuyển',
    type: TransactionType.expense,
    icon: 'IconData(U+0F1B9)', // FontAwesomeIcons.car
    color: 'MaterialColor(primary value: Color(0xff03a9f4))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_4',
    userId: 'default',
    name: 'Nhà cửa',
    type: TransactionType.expense,
    icon: 'IconData(U+0F015)', // FontAwesomeIcons.home
    color: 'MaterialColor(primary value: Color(0xff795548))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_5',
    userId: 'default',
    name: 'Hóa đơn',
    type: TransactionType.expense,
    icon: 'IconData(U+0F571)', // FontAwesomeIcons.fileInvoice
    color: 'MaterialColor(primary value: Color(0xff607d8b))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_6',
    userId: 'default',
    name: 'Giải trí',
    type: TransactionType.expense,
    icon: 'IconData(U+0F008)', // FontAwesomeIcons.film
    color: 'MaterialColor(primary value: Color(0xffe91e63))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_7',
    userId: 'default',
    name: 'Du lịch',
    type: TransactionType.expense,
    icon: 'IconData(U+0F072)', // FontAwesomeIcons.plane
    color: 'MaterialColor(primary value: Color(0xff4caf50))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_8',
    userId: 'default',
    name: 'Gia đình',
    type: TransactionType.expense,
    icon: 'IconData(U+0F0C0)', // FontAwesomeIcons.users
    color: 'MaterialColor(primary value: Color(0xffffc107))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_9',
    userId: 'default',
    name: 'Sức khỏe',
    type: TransactionType.expense,
    icon: 'IconData(U+0F21E)', // FontAwesomeIcons.heartbeat
    color: 'MaterialColor(primary value: Color(0xfff44336))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_10',
    userId: 'default',
    name: 'Giáo dục',
    type: TransactionType.expense,
    icon: 'IconData(U+0F19D)', // FontAwesomeIcons.graduationCap
    color: 'MaterialColor(primary value: Color(0xff009688))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_11',
    userId: 'default',
    name: 'Quà tặng',
    type: TransactionType.expense,
    icon: 'IconData(U+0F06B)', // FontAwesomeIcons.gift
    color: 'MaterialColor(primary value: Color(0xffe040fb))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_12',
    userId: 'default',
    name: 'Làm đẹp',
    type: TransactionType.expense,
    icon: 'IconData(U+0F1FC)', // FontAwesomeIcons.paintBrush
    color: 'MaterialColor(primary value: Color(0xff9e9e9e))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_13',
    userId: 'default',
    name: 'Điện',
    type: TransactionType.expense,
    icon: 'IconData(U+0F0E7)', // FontAwesomeIcons.bolt
    color: 'MaterialColor(primary value: Color(0xffffc400))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_14',
    userId: 'default',
    name: 'Nước',
    type: TransactionType.expense,
    icon: 'IconData(U+0F043)', // FontAwesomeIcons.tint
    color: 'MaterialColor(primary value: Color(0xff2196f3))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_expense_15',
    userId: 'default',
    name: 'Internet',
    type: TransactionType.expense,
    icon: 'IconData(U+0F1EB)', // FontAwesomeIcons.wifi
    color: 'MaterialColor(primary value: Color(0xff673ab7))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_1',
    userId: 'default',
    name: 'Lương',
    type: TransactionType.income,
    icon: 'IconData(U+0F0D6)', // FontAwesomeIcons.dollarSign
    color: 'MaterialColor(primary value: Color(0xffffeb3b))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_2',
    userId: 'default',
    name: 'Tiền Thưởng',
    type: TransactionType.income,
    icon: 'IconData(U+0F091)', // FontAwesomeIcons.award
    color: 'MaterialColor(primary value: Color(0xff4caf50))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_3',
    userId: 'default',
    name: 'Quà tặng',
    type: TransactionType.income,
    icon: 'IconData(U+0F06B)', // FontAwesomeIcons.gift
    color: 'MaterialColor(primary value: Color(0xffe040fb))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_4',
    userId: 'default',
    name: 'Cho vay',
    type: TransactionType.income,
    icon: 'IconData(U+0F4C0)', // FontAwesomeIcons.handshake
    color: 'MaterialColor(primary value: Color(0xff4caf50))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_5',
    userId: 'default',
    name: 'Tiền thừa kế',
    type: TransactionType.income,
    icon: 'IconData(U+0F0A9)', // FontAwesomeIcons.userInjured (thừa kế từ người thân)
    color: 'MaterialColor(primary value: Color(0xff8bc34a))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_6',
    userId: 'default',
    name: 'Tiền lãi',
    type: TransactionType.income,
    icon: 'IconData(U+0F201)', // FontAwesomeIcons.piggyBank
    color: 'MaterialColor(primary value: Color(0xff00bcd4))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_7',
    userId: 'default',
    name: 'Tiền cho thuê',
    type: TransactionType.income,
    icon: 'IconData(U+0F1AD)', // FontAwesomeIcons.building
    color: 'MaterialColor(primary value: Color(0xffff9800))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_8',
    userId: 'default',
    name: 'Bán hàng',
    type: TransactionType.income,
    icon: 'IconData(U+0F291)', // FontAwesomeIcons.shoppingCart
    color: 'MaterialColor(primary value: Color(0xff3f51b5))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_9',
    userId: 'default',
    name: 'Tiền hoàn thuế',
    type: TransactionType.income,
    icon: 'IconData(U+0F1C3)', // FontAwesomeIcons.moneyBill
    color: 'MaterialColor(primary value: Color(0xff607d8b))',
    createdAt: DateTime.now(),
  ),
  Category(
    categoryId: 'default_income_10',
    userId: 'default',
    name: 'Lãi suất ngân hàng',
    type: TransactionType.income,
    icon: 'IconData(U+0F53C)', // FontAwesomeIcons.university
    color: 'MaterialColor(primary value: Color(0xff9c27b0))',
    createdAt: DateTime.now(),
  ),
];

List<Category> fixedCategories = [
  Category(
    categoryId: 'fixed_expense',
    userId: 'default',
    name: 'Khác',
    type: TransactionType.expense,
    icon: 'IconData(U+0003F)',
    color: 'MaterialColor(primary value: Color(0xfff44336))',
    createdAt: DateTime.now(),
    isDefault: true,
  ),
  Category(
    categoryId: 'fixed_income',
    userId: 'default',
    name: 'Khác',
    type: TransactionType.income,
    icon: 'IconData(U+0003F)',
    color: 'MaterialColor(primary value: Color(0xff4caf50))',
    createdAt: DateTime.now(),
    isDefault: true,
  ),
];
