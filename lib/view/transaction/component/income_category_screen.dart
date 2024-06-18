import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';
import '../../../view_model/category/category_list_view_model.dart';
import '../../../widget/custom_header_3.dart';

class IncomeCategoryScreen extends StatefulWidget {
  const IncomeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCategoryScreen> createState() => _IncomeCategoryScreenState();
}

class _IncomeCategoryScreenState extends State<IncomeCategoryScreen> {
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
                  title: 'Danh mục thu nhập.',
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: viewModel.incomeCategories.isEmpty &&
                            viewModel.isSearching
                        ? Center(
                            child: Text(
                              'Không có kết quả tìm kiếm nào.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : viewModel.incomeCategories.isEmpty
                            ? Center(
                                child: Text(
                                  'Không có danh mục thu nhập nào.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              )
                            : GridView.builder(
                                itemCount: viewModel.incomeCategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  final category =
                                      viewModel.incomeCategories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, category);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
