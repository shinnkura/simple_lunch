import 'package:flutter/material.dart';

import '../constants.dart';

class EditMenuScreen extends StatefulWidget {
  final Function(String, String) updateMenu;
  final String initialMenuTitle;
  final String initialMenuDescription;

  EditMenuScreen({
    required this.updateMenu,
    required this.initialMenuTitle,
    required this.initialMenuDescription,
  });

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
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              initialValue: widget.initialMenuTitle,
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
              initialValue: widget.initialMenuDescription,
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
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                '保存',
                style: TextStyle(
                  fontSize: 20,
                  color: kTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
