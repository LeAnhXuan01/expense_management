import 'package:expense_management/widget/custom_header_3.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../utils/utils.dart';
import '../../view_model/category/category_list_view_model.dart';
import '../../widget/custom_header_1.dart';
import 'creat_categories_screen.dart';
import 'edit_categories.dart';

class CategoryListScreen extends StatefulWidget {
  final int selectedTabIndex;

  CategoryListScreen({this.selectedTabIndex = 0}); // Mặc định là 0 (thu nhập)

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late int _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.selectedTabIndex; // Gán selectedTabIndex từ đối số của màn hình
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _buildTab(String label, int index, Color selectedColor, Color defaultColor) {
    bool isSelected = _selectedTabIndex == index;
    return TextButton(
      onPressed: () => _onTabSelected(index),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(isSelected ? selectedColor : defaultColor),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryListViewModel(),
      child: Consumer<CategoryListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_3(
                  title: 'Quản lý danh mục.',
                  action: GestureDetector(
                    onTap: () {
                      setState(() {
                        viewModel.isSearching = true;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                    ),
                  ),
                  isSearching: viewModel.isSearching,
                  onSearchChanged: (query) {
                    setState(() {
                      viewModel.searchQuery = query;
                      viewModel.filterCategories(query);
                    });
                  },
                  onSearchClose: () {
                    setState(() {
                      viewModel.isSearching = false;
                      viewModel.searchQuery = '';
                      viewModel.searchController.clear();
                      viewModel.filterCategories('');
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab('Thu nhập', 0, Colors.green, Colors.grey),
                    _buildTab('Chi tiêu', 1, Colors.red, Colors.grey),
                  ],
                ),
                Expanded(
                  child: _selectedTabIndex == 0
                      ? _buildCategoryList(viewModel.incomeCategories, viewModel)
                      : _buildCategoryList(viewModel.expenseCategories, viewModel),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              shape: CircleBorder(),
              onPressed: () async {
                int initialSelectedValue = _selectedTabIndex;
                final newCategory = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatCategoriesScreen(initialSelectedValue: initialSelectedValue),
                  ),
                );

                // Kiểm tra nếu danh mục mới được tạo và điều hướng lại về CategoryListScreen với tab tương ứng
                if (newCategory != null && newCategory is Category) {
                  await viewModel.loadCategories();
                  setState(() {
                    _selectedTabIndex = newCategory.type == TransactionType.income ? 0 : 1;
                  });
                }
              },
              child: Icon(Icons.add, color: Colors.white),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories, CategoryListViewModel viewModel) {
    if (viewModel.isSearching && categories.isEmpty) {
      return Center(
        child: Text(
          'Không có kết quả tìm kiếm nào.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    if (categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            if(category.isDefault){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Thông báo'),
                    content: Text(
                        'Đây là danh mục không thể chỉnh sửa hoặc xóa',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                            ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }else{
              _showOptionsDialog(context, category, viewModel);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: parseColor(category.color),
                ),
                child: Icon(
                  parseIcon(category.icon),
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showOptionsDialog(BuildContext context, Category category, CategoryListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lựa chọn cho: ${category.name}'),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),

                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context); 
                        final updatedCategory = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCategoriesScreen(category: category),
                          ),
                        );
                        if (updatedCategory != null && updatedCategory is Category) {
                          await viewModel.loadCategories();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.penToSquare, color: Colors.white),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                      border: Border.all(color: Colors.grey ,width: 2),
                    ),
                    child: TextButton(
                      onPressed: () {
                        viewModel.deleteCategory(category.categoryId);
                        Navigator.pop(context);
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.trash, color: Colors.white,),
                          Text(
                            'Xóa',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
