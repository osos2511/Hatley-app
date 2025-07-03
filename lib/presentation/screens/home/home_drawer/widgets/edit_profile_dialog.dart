import 'package:flutter/material.dart';

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Username')),
          TextField(decoration: const InputDecoration(labelText: 'Email')),
          TextField(decoration: const InputDecoration(labelText: 'Phone')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: اضافة منطق التحديث
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
