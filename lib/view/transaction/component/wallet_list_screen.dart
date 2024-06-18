import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../model/enum.dart';
import '../../../utils/utils.dart';
import '../../../view_model/wallet/wallet_view_model.dart';
import '../../../widget/custom_header_1.dart';
import '../../../widget/custom_header_3.dart';

class WalletListScreen extends StatefulWidget {
  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => WalletViewModel(),
      child: Consumer<WalletViewModel>(
        builder: (context, viewModel, child){
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_3(
                  title: 'Danh sách ví tiền',
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
                      viewModel.filterWallets(query);
                    });
                  },
                  onSearchClose: () {
                    setState(() {
                      viewModel.isSearching = false;
                      viewModel.searchQuery = '';
                      viewModel.searchController.clear();
                      viewModel.filterWallets('');
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.wallets.length,
                    itemBuilder: (context, index) {
                      final wallet = viewModel.wallets[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          leading: CircleAvatar(
                            backgroundColor: parseColor(wallet.color),
                            child: Icon(
                              parseIcon(wallet.icon),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(wallet.name),
                          subtitle: Text(
                            '${formatInitialBalance(wallet.initialBalance, wallet.currency)} ${wallet.currency == Currency.VND ? 'VND' : 'USD'}',
                          ),
                          onTap: () {
                            Navigator.pop(context, wallet);
                          },
                        ),
                      );
                    },
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
