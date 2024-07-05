import 'package:flutter/material.dart';
import '../../model/wallet_model.dart';
import '../../utils/utils.dart';

class MultiWalletSelectionDialog extends StatefulWidget {
  final List<Wallet> wallets;
  final List<Wallet> selectedWallets;
  final Function(List<Wallet>) onSelect;

  MultiWalletSelectionDialog({
    required this.wallets,
    required this.selectedWallets,
    required this.onSelect,
  });

  @override
  _MultiWalletSelectionDialogState createState() => _MultiWalletSelectionDialogState();
}

class _MultiWalletSelectionDialogState extends State<MultiWalletSelectionDialog> {
  late List<Wallet> selectedWallets;
  late List<Wallet> filteredWallets;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWallets = List.from(widget.selectedWallets);
    filteredWallets = List.from(widget.wallets);
    searchController.addListener(() {
      filterWallets();
    });
  }

  void filterWallets() {
    setState(() {
      filteredWallets = widget.wallets
          .where((wallet) =>
          wallet.name.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Chọn ví',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm ví',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredWallets.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    bool allSelected = selectedWallets.length == widget.wallets.length;
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: CheckboxListTile(
                        value: allSelected,
                        title: Text('Tất cả'),
                        secondary: Icon(
                          Icons.list,
                          color: Colors.grey,
                          size: 35,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedWallets = List.from(widget.wallets);
                            } else {
                              selectedWallets.clear();
                            }
                          });
                        },
                      ),
                    );
                  } else {
                    final wallet = filteredWallets[index - 1];
                    bool isSelected = selectedWallets.contains(wallet);
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: CheckboxListTile(
                        value: isSelected,
                        title: Text(wallet.name),
                        secondary: CircleAvatar(
                          backgroundColor: parseColor(wallet.color),
                          child: Icon(
                            parseIcon(wallet.icon),
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedWallets.add(wallet);
                            } else {
                              selectedWallets.remove(wallet);
                            }
                          });
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: selectedWallets.isNotEmpty ? () {
                      widget.onSelect(selectedWallets);
                      Navigator.pop(context);
                    } : null,
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 18, color: selectedWallets.isNotEmpty ? Colors.blue : Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
