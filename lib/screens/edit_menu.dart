import 'package:flutter/material.dart';

import '../constants.dart';

class EditMenuScreen extends StatefulWidget {
  final Function(String, String) updateMenu;

  EditMenuScreen({required this.updateMenu});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  final _formKey = GlobalKey<FormState>();

  String _menuTitle = '';

  String _menuDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '献立の変更',
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: kTextColor,
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: '本日の献立',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '献立を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _menuTitle = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '説明',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                onSaved: (value) {
                  _menuDescription = value!;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.updateMenu(_menuTitle, _menuDescription);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text('保存', style: TextStyle(color: kTextColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
