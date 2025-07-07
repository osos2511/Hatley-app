import 'package:flutter/material.dart';
import 'package:hatley/core/colors_manager.dart';

class EditProfileDialog extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final void Function(String name, String email, String phone) onSave;

  const EditProfileDialog({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final Color primaryBlue =  ColorsManager.buttonColorApp; // أزرق مريح

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(nameController, 'Username'),
          const SizedBox(height: 10),
          _buildTextField(emailController, 'Email'),
          const SizedBox(height: 10),
          _buildTextField(phoneController, 'Phone'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: primaryBlue)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryColorApp,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onSave(
              nameController.text.trim(),
              emailController.text.trim(),
              phoneController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryBlue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      cursorColor: primaryBlue,
      style: const TextStyle(color: Colors.black87),
    );
  }
}
