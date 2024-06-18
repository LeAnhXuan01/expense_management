import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/category_model.dart';
import '../../model/wallet_model.dart';
import '../../utils/utils.dart';
import '../../view_model/wallet/wallet_view_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import 'component/image_detail_screen.dart';
import 'component/expense_category_screen.dart';
import 'component/income_category_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/custom_header_2.dart';
import 'component/wallet_list_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncomeTabSelected;
  final Category? selectedCategory;
  final Wallet? selectedWallet;
  AddTransactionScreen({this.selectedCategory, this.selectedWallet, this.isIncomeTabSelected = true});

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
  Wallet? _selectedWallet;
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _isIncomeTabSelected = widget.isIncomeTabSelected;
    _selectedCategory = widget.selectedCategory;
    _selectedWallet = widget.selectedWallet;
    _checkButtonStatus();
  }

  void _checkButtonStatus() {
    setState(() {
      _isButtonEnabled = _amount > 0 && _selectedCategory != null && _selectedWallet != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1999),
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
            ? IncomeCategoryScreen()
            : ExpenseCategoryScreen(),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
        _checkButtonStatus();
      });
    }
  }

  Future<void> _addWallet() async {
    final selectedWallet = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletListScreen(),
      ),
    );

    if (selectedWallet != null) {
      setState(() {
        _selectedWallet = selectedWallet;
        _checkButtonStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              CustomHeader_2(
                leftAction: IconButton(
                  icon: Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    // Handle search action
                  },
                ),
                title: 'Thêm giao dịch',
                rightAction: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Handle search action
                  },
                ),
              ),
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
                            Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: _isIncomeTabSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isIncomeTabSelected = value!;
                                      _selectedCategory = null;
                                      _checkButtonStatus();
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
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: _isIncomeTabSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isIncomeTabSelected = value!;
                                      _selectedCategory = null;
                                      _checkButtonStatus();
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
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Danh mục:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: _addCategory,
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedCategory != null
                                          ? parseColor(_selectedCategory!.color)
                                          : Colors.grey,
                                    ),
                                    child: _selectedCategory != null
                                        ? Icon(
                                      parseIcon(_selectedCategory!.icon),
                                      color: Colors.white,
                                      size: 36,
                                    )
                                        : Icon(
                                      FontAwesomeIcons.question,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                  if (_selectedCategory != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _selectedCategory!.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Ví tiền:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: _addWallet,
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedWallet != null
                                          ? parseColor(_selectedWallet!.color)
                                          : Colors.grey,
                                    ),
                                    child: _selectedWallet != null
                                        ? Icon(
                                      parseIcon(_selectedWallet!.icon),
                                      color: Colors.white,
                                      size: 36,
                                    )
                                        : Icon(
                                      FontAwesomeIcons.question,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                  if (_selectedWallet != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _selectedWallet!.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                                      color: Colors.black.withOpacity(0.7),
                                    ),
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
                        SizedBox(height: 20),
                        Text(
                          'Ảnh',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
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
                        SizedBox(height: 20),
                        CustomElevatedButton_2(
                          text: 'Lưu',
                          onPressed: _isButtonEnabled ? () {
                            // Save transaction logic
                          } : null,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),


    );
  }

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
                  : Colors.grey,
              image: imagePath != null && imagePath.isNotEmpty
                  ? DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: imagePath != null && imagePath.isNotEmpty
                ? null
                : Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (imagePath != null && imagePath.isNotEmpty)
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
