import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/category_item.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import 'expense_category_add_screen.dart';
import 'income_category_add_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isIncomeTabSelected = true; // default to income tab
  DateTime _selectedDate = DateTime.now(); // default to current date
  // Tạo một biến để theo dõi danh mục được chọn
  int _selectedCategoryIndex = -1; // Không có danh mục nào được chọn ban đầu
  double _amount = 0.0; // Biến để lưu số tiền
  bool _isButtonEnabled = false; // Biến để kiểm tra xem nút "Lưu" có được kích hoạt hay không

  bool isCategoryExist(CategoryItem category) {
    List<CategoryItem> targetList = _isIncomeTabSelected ? incomeCategories : expenseCategories;
    for (CategoryItem existingCategory in targetList) {
      if (existingCategory.name == category.name) {
        return true;
      }
    }
    return false;
  }


  // Hàm kiểm tra điều kiện để kích hoạt nút "Lưu"
  void _checkButtonStatus() {
    setState(() {
      // Kích hoạt nút "Lưu" nếu số tiền lớn hơn 0 và đã chọn danh mục
      _isButtonEnabled = _amount > 0 && _selectedCategoryIndex != -1;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Chỉ định ngày bắt đầu là năm 2000
      lastDate: DateTime.now(), // Chỉ định ngày kết thúc là ngày hiện tại
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
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
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: Colors.deepPurpleAccent,
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
                                onTap: (){

                                },
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
                                onTap: (){
                                  Navigator.of(context).pop;
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ]
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isIncomeTabSelected = true;
                                  _selectedCategoryIndex = -1; // Reset selected category index
                                  _checkButtonStatus(); // Kiểm tra điều kiện để kích hoạt nút "Lưu"
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _isIncomeTabSelected ? Colors.white : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Thu nhập',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: _isIncomeTabSelected ? FontWeight.bold : FontWeight.normal,
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
                                  _selectedCategoryIndex = -1; // Reset selected category index
                                  _checkButtonStatus(); // Kiểm tra điều kiện để kích hoạt nút "Lưu"
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !_isIncomeTabSelected ? Colors.white : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Chi tiêu',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: !_isIncomeTabSelected ? FontWeight.bold : FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          onChanged: (value){
                            setState(() {
                              // Cập nhật giá trị của số tiền khi người dùng thay đổi
                              _amount = double.tryParse(value) ?? 0.0;
                              // Kiểm tra điều kiện để kích hoạt nút "Lưu"
                              _checkButtonStatus();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Số tiền',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Danh mục',
                          style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                        ),
                        Container(
                          height: 270, // Adjust height according to your needs
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            // itemCount: categories.length >= 5 ? 6 : categories.length + 1,
                            // itemCount: _isIncomeTabSelected ? incomeCategories.length : expenseCategories.length,
                            itemCount: _isIncomeTabSelected ? (incomeCategories.length > 5 ? 6 : incomeCategories.length) : (expenseCategories.length > 5 ? 6 : expenseCategories.length),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < 5) {
                                // final category = categories[index];
                                final category = _isIncomeTabSelected ? incomeCategories[index] : expenseCategories[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Xử lý khi nhấn vào một danh mụct
                                    setState(() {
                                      _selectedCategoryIndex = index; // Cập nhật chỉ mục của danh mục được chọn
                                      _checkButtonStatus();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _selectedCategoryIndex == index ? category.color : null, // Đặt màu nền của container tùy thuộc vào danh mục có được chọn hay không
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: category.color,
                                          ),
                                          child: Icon(
                                            category.icon,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          category.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14, color: _selectedCategoryIndex == index ? Colors.white : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  // onTap: () {
                                  //   //Xử lý khi nhấn nút "Add"
                                  //   // Kiểm tra tab hiện tại là tab thu nhập hay tab chi tiêu
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => _isIncomeTabSelected == true
                                  //           ? IncomeCategoryAddScreen()
                                  //           : ExpenseCategoryAddScreen(),
                                  //     )
                                  //   );
                                  //   // Navigator.of(context).pushNamed('/creat-categories');
                                  //
                                  // },
                                  onTap: () async {
                                    //Xử lý khi nhấn nút "Add"
                                    // Kiểm tra tab hiện tại là tab thu nhập hay tab chi tiêu
                                    final selectedCategory = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => _isIncomeTabSelected ? IncomeCategoryAddScreen() : ExpenseCategoryAddScreen(),
                                      ),
                                    );

                                    if (selectedCategory != null) {
                                      // Kiểm tra xem danh mục đã tồn tại trong danh sách của AddTransaction chưa
                                      bool isExistInAddTransaction = isCategoryExist(selectedCategory);

                                      // Nếu danh mục đã tồn tại trong danh sách của AddTransaction
                                      if (isExistInAddTransaction) {
                                        setState(() {
                                          if (_isIncomeTabSelected) {
                                            // Lấy danh mục vị trí đầu tiên trong danh sách AddTransaction
                                            CategoryItem firstCategory = incomeCategories[0];
                                            // Loại bỏ danh mục trùng lặp trong danh sách AddTransaction
                                            incomeCategories.remove(selectedCategory);
                                            // Thêm danh mục mới vào đầu danh sách AddTransaction
                                            incomeCategories.insert(0, selectedCategory);
                                            // Nếu danh mục vị trí đầu tiên trong danh sách AddTransaction trùng với danh mục được chọn, không cần cập nhật chỉ mục
                                            if (firstCategory != selectedCategory) {
                                              _selectedCategoryIndex = 0;
                                            }
                                          } else {
                                            CategoryItem firstCategory = expenseCategories[0];
                                            expenseCategories.remove(selectedCategory);
                                            expenseCategories.insert(0, selectedCategory);
                                            if (firstCategory != selectedCategory) {
                                              _selectedCategoryIndex = 0;
                                            }
                                          }
                                          _checkButtonStatus(); // Kiểm tra điều kiện để kích hoạt nút "Lưu"
                                        });
                                      }
                                      // Nếu danh mục không tồn tại trong danh sách của AddTransaction
                                      else {
                                        setState(() {
                                          if (_isIncomeTabSelected) {
                                            // Chèn danh mục mới vào vị trí đầu tiên của danh sách AddTransaction
                                            incomeCategories.insert(0, selectedCategory);
                                          } else {
                                            expenseCategories.insert(0, selectedCategory);
                                          }
                                          _selectedCategoryIndex = 0;
                                          _checkButtonStatus(); // Kiểm tra điều kiện để kích hoạt nút "Lưu"
                                        });
                                      }
                                    }



                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40, top: 25),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueGrey.shade200,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
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
                                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
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
                          maxLines: null, // Allow multiline input
                          maxLength: 4000,
                          decoration: InputDecoration(
                            labelText: 'Ghi chú',
                          ),
                        ),
                        Text('Ảnh', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey
                              ),
                              child: Icon(FontAwesomeIcons.plus, color: Colors.white, size: 30,),                        ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey
                              ),
                              child: Icon(FontAwesomeIcons.plus, color: Colors.white, size: 30,),                        ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey
                              ),
                              child: Icon(FontAwesomeIcons.plus, color: Colors.white, size: 30,),
                            ),
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
            bottom: 30, // Điều chỉnh vị trí của nút "Lưu" ở đáy màn hình
            left: 0,
            right: 0,
            child: CustomElevatedButton_2(
              text: 'Lưu',
              onPressed: _isButtonEnabled ? () {
// Thực hiện hành động khi nút "Lưu" được kích hoạt
              } : null,
            )
          ),
        ],
      )
    );
  }
}




