import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T value;
  final ValueChanged<T?> onChanged;
  final List<T> items;

  const CustomDropdownButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
