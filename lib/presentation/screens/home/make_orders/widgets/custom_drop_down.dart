import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueItems = items.toSet().toList(); // إزالة التكرار
    final filteredValue = uniqueItems.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: filteredValue,
      hint: Text(hint),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          uniqueItems
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
