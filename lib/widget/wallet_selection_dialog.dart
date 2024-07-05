import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:provider/provider.dart';
import '../model/enum.dart';
import '../utils/utils.dart';

class WalletSelectionDialog extends StatelessWidget {
  final List<Wallet> wallets;
  final Function(Wallet) onSelect;

  WalletSelectionDialog({required this.wallets, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WalletViewModel(),
      child: Consumer<WalletViewModel>(
        builder: (context, viewModel, child){
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        final wallet = wallets[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: parseColor(wallet.color),
                              child: Icon(
                                parseIcon(wallet.icon),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(wallet.name),
                            subtitle: Text(
                              '${formatAmount(wallet.initialBalance, wallet.currency)} ${wallet.currency == Currency.VND ? '₫' : '\$'}',
                            ),
                            onTap: () {
                              onSelect(wallet);
                              Navigator.pop(context);
                            },
                          ),
                        );
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
                          child: Text('Hủy', style: TextStyle(fontSize: 18, color: Colors.red), ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
