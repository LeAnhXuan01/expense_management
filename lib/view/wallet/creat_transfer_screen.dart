import 'package:flutter/material.dart';

class CreateTransferScreen extends StatefulWidget {
  @override
  _CreateTransferScreenState createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fromAccount = '';
  String _toAccount = '';
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _note = '';
  List<String> _accounts = ['Ví 1', 'Ví 2', 'Ví 3'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tạo chuyển khoản')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _fromAccount.isNotEmpty ? _fromAccount : null,
                items: _accounts.map((String account) {
                  return DropdownMenuItem<String>(
                    value: account,
                    child: Text(account),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _fromAccount = newValue!;
                    // Remove the selected account from the toAccount options
                    if (_toAccount == _fromAccount) {
                      _toAccount = '';
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Chuyển từ tài khoản'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng chọn tài khoản chuyển'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _toAccount.isNotEmpty ? _toAccount : null,
                items: _accounts
                    .where((account) => account != _fromAccount)
                    .map((String account) {
                  return DropdownMenuItem<String>(
                    value: account,
                    child: Text(account),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _toAccount = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Chuyển vào tài khoản'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng chọn tài khoản nhận'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Số tiền chuyển khoản'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                    "Ngày: ${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ghi chú'),
                maxLength: 4000,
                onSaved: (value) {
                  _note = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Save transfer logic here
                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
