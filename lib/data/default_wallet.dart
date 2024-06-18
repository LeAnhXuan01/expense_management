import '../model/wallet_model.dart';
import '../model/enum.dart';

List<Wallet> defaultWallets = [
  Wallet(
    walletId: 'default_wallet_1',
    userId: 'default',
    initialBalance: 0,
    name: 'Ví tiền mặt',
    icon: 'IconData(U+0F53A)',
    color: 'MaterialColor(primary value: Color(0xffffeb3b))',
    currency: Currency.VND,
    excludeFromTotal: false,
    createdAt: DateTime.now(),
  ),
  Wallet(
    walletId: 'default_wallet_2',
    userId: 'default',
    initialBalance: 0,
    name: 'Ví ngân hàng',
    icon: 'IconData(U+0F19C)',
    color: 'MaterialColor(primary value: Color(0xff4caf50))',
    currency: Currency.VND,
    excludeFromTotal: false,
    createdAt: DateTime.now(),
  ),
  Wallet(
    walletId: 'default_wallet_3',
    userId: 'default',
    initialBalance: 0,
    name: 'Ví tiết kiệm',
    icon: 'IconData(U+0F4D3)',
    color: 'MaterialColor(primary value: Color(0xffffeb3b))',
    currency: Currency.VND,
    excludeFromTotal: false,
    createdAt: DateTime.now(),
  ),
];

List<Wallet> fixedWallets = [
  Wallet(
    walletId: 'fixed_wallet',
    userId: 'default',
    initialBalance: 0,
    name: 'Ví chính',
    icon: 'IconData(U+0F555)',
    color: 'MaterialColor(primary value: Color(0xfff44336))',
    currency: Currency.VND,
    excludeFromTotal: false,
    createdAt: DateTime.now(),
    isDefault: true,
  ),
];