import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../transaction/component/catalog_color_screen.dart';
import '../transaction/component/icon_category_screen.dart';

class CreateWalletScreen extends StatefulWidget {
  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  String _walletName = '';
  double _initialBalance = 0.0;
  IconData _icon = Icons.wallet;
  Color _color = Colors.blue;
  String _currency = 'VND';
  bool _excludeFromTotal = false;
  int _selectedColorIndex = -1;
  Color? _selectedColor;
  IconData? selectedIcon;

  bool get isEmptyColor => _selectedColor == null;

  bool get isEmptyIcon => selectedIcon == null;
  bool showErrorColor = false;
  bool showErrorIcon = false;

  final List<IconData> _icons = [
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.moneyBill,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.bank,
    FontAwesomeIcons.donate,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.sackDollar,

  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.deepPurpleAccent,
    Colors.cyanAccent,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(title: 'Tạo ví tiền'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Tên ví'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Số dư ban đầu'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      items: ['VND', 'EURO'].map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _currency = newValue!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Đơn vị tiền tệ'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Biểu tượng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: 10),
                        if (isEmptyIcon && showErrorIcon)
                          Text(
                            'Chọn một biểu tượng danh mục',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Số cột trong lưới
                        mainAxisSpacing: 30, // Khoảng cách giữa các dòng
                        crossAxisSpacing: 30, // Khoảng cách giữa các cột
                        childAspectRatio:
                            1, // Tỷ lệ khung hình của mỗi mục trong lưới
                      ),
                      itemCount: _icons.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // Xử lý khi chọn biểu tượng
                            setState(() {
                              selectedIcon = _icons[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: selectedIcon == _icons[index]
                                  ? Border.all(color: Colors.black, width: 1.0)
                                  : null, // Thêm border chỉ khi được chọn
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedIcon == _icons[index]
                                      ? (_selectedColor ?? Colors.blueGrey.shade200)
                                      : Colors.blueGrey.shade200,
                                ),
                                child: Icon(
                                  _icons[index],
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Text(
                          'Màu sắc',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: 10),
                        if (isEmptyColor && showErrorColor)
                          Text(
                            'Chọn màu danh mục',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50, // Điều chỉnh chiều cao của hàng màu sắc
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // Chỉ định scroll theo chiều ngang
                              itemCount: _colors.length,
                              // Số lượng màu sắc muốn hiển thị
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    // Xử lý khi chọn màu sắc
                                    setState(() {
                                      _selectedColorIndex = index;
                                      _selectedColor =
                                          _colors[index]; // Cập nhật màu được chọn
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 15),
                                    // Khoảng cách giữa các màu sắc
                                    width: 40,
                                    // Điều chỉnh chiều rộng của mỗi màu sắc
                                    decoration: BoxDecoration(
                                      color: _colors[index],
                                      // Sử dụng màu sắc từ danh sách màu sắc (_colors)
                                      shape: BoxShape.circle,
                                    ),
                                    child: _selectedColorIndex == index
                                        ? Icon(Icons.check,
                                            color: Colors.white,
                                            size:
                                                24) // Hiển thị biểu tượng check cho shade được chọn
                                        : null, // Không hiển thị biểu tượng check cho các shade khác,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Xử lý khi nhấn vào nút 'Plus'
                            final selectedColor =
                                await Navigator.of(context).push<Color?>(
                              MaterialPageRoute(
                                builder: (context) => CatalogColorScreen(
                                  colors: _colors,
                                  initialColor: _selectedColor,
                                ),
                              ),
                            );
                            if (selectedColor != null) {
                              setState(() {
                                // Cập nhật màu được chọn nếu có
                                _selectedColorIndex =
                                    _colors.indexOf(selectedColor);
                                _selectedColor = selectedColor;
                              });
                            }
                          },
                          child: Container(
                            width: 40, // Điều chỉnh chiều rộng của nút 'Plus'
                            height: 40, // Điều chỉnh chiều cao của nút 'Plus'
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade200,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text('Không bao gồm trong tổng số dư'),
                      value: _excludeFromTotal,
                      onChanged: (bool value) {
                        setState(() {
                          _excludeFromTotal = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomElevatedButton_2(
                      text: 'Tạo',
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
