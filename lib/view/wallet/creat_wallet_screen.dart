import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CreateWalletScreen extends StatefulWidget {
  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  String? _currency = 'VND'; // Mặc định đơn vị tiền tệ là VND
  double _initialBalance = 0; // Mặc định số dư ban đầu là 0
  bool _excludeFromTotal = false;
  Color? _selectedColor;
  IconData? selectedIcon;
  bool _showPlusButton_icon = true;
  bool _showPlusButton_color = true;

  bool get isEmptyColor => _selectedColor == null;

  bool get isEmptyIcon => selectedIcon == null;
  bool showErrorColor = false;
  bool showErrorIcon = false;

  final List<IconData> _icons = [
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
          CustomHeader_1(title: 'Tạo ví tiền'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Tên ví'),
                    ),
                    // Hiển thị đơn vị tiền tệ đã chọn cạnh text field số dư ban đầu
                    Row(
                      children: [
                        Flexible(
                          flex: 1, // Tỷ lệ cho TextFormField số dư ban đầu
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Số dư ban đầu'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10), // Để tạo khoảng cách giữa hai TextFormField
                        Flexible(
                          flex: 1, // Tỷ lệ cho DropdownButtonFormField đơn vị tiền tệ
                          child: DropdownButtonFormField<String>(
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
                        ),
                      ],
                    ),



                    // DropdownButtonFormField<String>(
                    //   items: ['VND', 'EURO'].map((String currency) {
                    //     return DropdownMenuItem<String>(
                    //       value: currency,
                    //       child: Text(currency),
                    //     );
                    //   }).toList(),
                    //   onChanged: (newValue) {
                    //     setState(() {
                    //       _currency = newValue!;
                    //     });
                    //   },
                    //   decoration: InputDecoration(labelText: 'Đơn vị tiền tệ'),
                    // ),
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
                        Spacer(), // Thêm Spacer để đẩy mũi tên mở rộng sang phải
                        GestureDetector(
                          onTap: () {
                            // Xử lý mở rộng hoặc thu gọn gridview biểu tượng
                            setState(() {
                              _showPlusButton_icon = !_showPlusButton_icon;
                            });
                          },
                          child: Icon(
                            _showPlusButton_icon ? Icons.arrow_drop_down : Icons.arrow_drop_up, // Thay đổi biểu tượng tùy thuộc vào trạng thái hiện tại
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (_showPlusButton_icon)
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Số cột trong lưới biểu tượng
                          mainAxisSpacing: 10, // Khoảng cách giữa các dòng
                          crossAxisSpacing: 10, // Khoảng cách giữa các cột
                          childAspectRatio: 1, // Tỷ lệ khung hình của mỗi mục trong lưới
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
                                    size: 38,
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
                          'Màu sắc:',
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
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Xử lý mở rộng hoặc thu gọn gridview màu
                            setState(() {
                              _showPlusButton_color = !_showPlusButton_color;
                            });
                          },
                          child: Icon(
                            _showPlusButton_color ? Icons.arrow_drop_down : Icons.arrow_drop_up, // Thay đổi biểu tượng tùy thuộc vào trạng thái hiện tại
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (_showPlusButton_color)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // Số cột trong lưới màu
                          mainAxisSpacing: 10, // Khoảng cách giữa các dòng
                          crossAxisSpacing: 10, // Khoảng cách giữa các cột
                          childAspectRatio: 1, // Tỷ lệ khung hình của mỗi mục trong lưới
                        ),
                        itemCount: _colors.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Xử lý khi chọn màu
                              setState(() {
                                _selectedColor = _colors[index];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: _selectedColor == _colors[index]
                                    ? Border.all(color: Colors.black, width: 2.0) // Hiển thị đường viền nếu màu được chọn
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colors[index],
                                    shape: BoxShape.circle,
                                  ),
                                  child: _selectedColor == _colors[index]
                                      ? Icon(Icons.check, color: Colors.white, size: 24) // Hiển thị dấu tích nếu màu được chọn
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
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
