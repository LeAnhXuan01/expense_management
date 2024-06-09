import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_header_1.dart';

class CreatCategoriesScreen extends StatefulWidget {
  final int initialSelectedValue; // Add this line
  const CreatCategoriesScreen({super.key, this.initialSelectedValue = 0});

  @override
  State<CreatCategoriesScreen> createState() => _CreatCategoriesState();
}

class _CreatCategoriesState extends State<CreatCategoriesScreen> {
  int _selectedValue = 0; // 0: Thu, 1: Chi
  bool _showPlusButton_icon = true;
  bool _showPlusButton_color = true;
  // Biến để theo dõi xem một biểu tượng có được chọn hay không
  IconData? selectedIcon;
  int _selectedColorIndex = -1; // Biến để lưu chỉ số màu đang được chọn
  Color? _selectedColor; // Biến để lưu màu được chọn
  final TextEditingController _nameCategory = TextEditingController();

  bool get isEmptyName => _nameCategory.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => _selectedColor == null;

  bool showErrorName = false;
  bool showErrorIcon = false;
  bool showErrorColor = false;

  final List<IconData> _incomeIcons = [
    FontAwesomeIcons.moneyBillAlt,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.bank,
    FontAwesomeIcons.donate,
    FontAwesomeIcons.addressBook,
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.home,
    FontAwesomeIcons.car,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.instagram,
  ];

  final List<IconData> _expenseIcons = [
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.home,
    FontAwesomeIcons.car,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.instagram,
    FontAwesomeIcons.moneyBillAlt,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.bank,
    FontAwesomeIcons.donate,
    FontAwesomeIcons.addressBook,
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

  List<IconData> get _currentIconsList =>
      _selectedValue == 0 ? _incomeIcons : _expenseIcons;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialSelectedValue; // Initialize _selectedValue using the passed value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader_1(title: 'Tạo danh mục'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 70),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                showErrorName = false;
                              });
                            },
                            controller: _nameCategory,
                            decoration: InputDecoration(
                              labelText: 'Tên danh mục',
                              errorText: showErrorName ? 'Nhập tên danh mục' : null,
                            ),
                          ),
                        ),
                        if (selectedIcon != null)
                          Positioned(
                            left: 2.0,
                            top: 13.0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedColor ?? Colors.blueGrey.shade200,
                              ),
                              child: Icon(
                                selectedIcon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        if (selectedIcon == null)
                          Positioned(
                            left: 2.0,
                            top: 13.0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedColor ?? Colors.blueGrey.shade200,
                              ),
                              child: Icon(
                                FontAwesomeIcons.question,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value as int;
                            });
                          },
                        ),
                        Text(
                          'Thu nhập',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: 50),
                        Radio(
                          value: 1,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value as int;
                            });
                          },
                        ),
                        Text(
                          'Chi tiêu',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
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
                        Spacer(),
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
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Số cột trong lưới
                          mainAxisSpacing: 10, // Khoảng cách giữa các dòng
                          crossAxisSpacing: 10, // Khoảng cách giữa các cột
                          childAspectRatio: 1, // Tỷ lệ khung hình của mỗi mục trong lưới
                        ),
                        itemCount: _currentIconsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Xử lý khi chọn biểu tượng
                              setState(() {
                                selectedIcon = _currentIconsList[index];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: selectedIcon == _currentIconsList[index]
                                    ? Border.all(color: Colors.black, width: 1.0)
                                    : null, // Thêm border chỉ khi được chọn
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selectedIcon == _currentIconsList[index]
                                        ? (_selectedColor ?? Colors.blueGrey.shade200)
                                        : Colors.blueGrey.shade200,
                                  ),
                                  child: Icon(
                                    _currentIconsList[index],
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

                    SizedBox(height: 30),
                    CustomElevatedButton_2(
                      text: 'Tạo',
                      onPressed: () {
                        setState(() {
                          showErrorName = isEmptyName;
                          showErrorIcon = isEmptyIcon;
                          showErrorColor = isEmptyColor;
                        });

                        // Kiểm tra nếu tất cả các trường đều hợp lệ mới thực hiện hành động
                        if (!showErrorName && !showErrorIcon && !showErrorColor) {
                          // Thực hiện hành động tạo danh mục ở đây
                        }
                      },
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
