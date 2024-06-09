import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../model/category_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import 'component/image_detail_screen.dart';
import 'expense_category_add_screen.dart';
import 'income_category_add_screen.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncomeTabSelected;

  AddTransactionScreen({this.isIncomeTabSelected = true});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late bool _isIncomeTabSelected;
  DateTime _selectedDate = DateTime.now();
  double _amount = 0.0;
  final TextEditingController _noteController = TextEditingController();
  bool _isButtonEnabled = false;
  Category? _selectedCategory;
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _isIncomeTabSelected = widget.isIncomeTabSelected;

    _checkButtonStatus();
  }

  void _checkButtonStatus() {
    setState(() {
      _isButtonEnabled = _amount > 0 && _selectedCategory != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _addCategory() async {
    final selectedCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _isIncomeTabSelected
            ? IncomeCategoryAddScreen()
            : ExpenseCategoryAddScreen(),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
        _checkButtonStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35, left: 20, right: 20),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.list_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Thêm giao dịch',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isIncomeTabSelected = true;
                                    _selectedCategory = null;
                                    _checkButtonStatus();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _isIncomeTabSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Thu nhập',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: _isIncomeTabSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isIncomeTabSelected = false;
                                    _selectedCategory = null;
                                    _checkButtonStatus();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: !_isIncomeTabSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Chi tiêu',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: !_isIncomeTabSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _amount = double.tryParse(value) ?? 0.0;
                                _checkButtonStatus();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Số tiền',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Danh mục:',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black.withOpacity(0.7)),
                              ),
                              SizedBox(width: 30),
                              GestureDetector(
                                onTap: _addCategory,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueGrey.shade200,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.question,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                )

                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Row(
                                  children: [
                                    Text(
                                      'Chọn ngày:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            maxLines: null,
                            maxLength: 4000,
                            decoration: InputDecoration(
                              labelText: 'Ghi chú',
                            ),
                          ),
                          Text(
                            'Ảnh',
                            style: TextStyle(
                                fontSize: 16, color: Colors.black.withOpacity(0.7)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < 3; i++)
                                buildContainer(context, i < _images.length ? _images[i].path : null),
                            ],
                          ),

                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: CustomElevatedButton_2(
                text: 'Lưu',
                onPressed: () {},
              )

            ),
          ],
        ));
  }

  // Trong phương thức buildContainer
  GestureDetector buildContainer(BuildContext context, String? imagePath) {
    return GestureDetector(
      onTap: () {
        if (imagePath != null && imagePath.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDetailScreen(imagePath: imagePath),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thêm ảnh'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('Chụp ảnh'),
                        onTap: () {
                          Navigator.of(context).pop();
                          captureImage(context);
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: Text('Thêm ảnh từ thư viện'),
                        onTap: () {
                          Navigator.of(context).pop();
                          pickImageFromGallery(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: imagePath != null && imagePath.isNotEmpty
                  ? null
                  : Colors.grey, // Tránh việc màu nền bị che khuất bởi ảnh
              image: imagePath != null && imagePath.isNotEmpty
                  ? DecorationImage(
                image: FileImage(File(imagePath!)),
                fit: BoxFit.cover,
              )
                  : null, // Tránh việc hiển thị ảnh mặc định khi không có ảnh
            ),
            child: imagePath != null && imagePath.isNotEmpty
                ? null // Không cần hiển thị biểu tượng plus khi đã có ảnh
                : Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (imagePath != null && imagePath.isNotEmpty) // Hiển thị biểu tượng "x" nếu có ảnh
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _images.removeWhere((element) => element.path == imagePath);
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> captureImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }
}
