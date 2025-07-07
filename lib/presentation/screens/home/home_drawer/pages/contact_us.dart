import 'package:flutter/material.dart';
import 'package:hatley/core/colors_manager.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             Icon(Icons.mark_email_read, size: 100, color: ColorsManager.white),
            const SizedBox(height: 16),
            const Text(
              'If you have questions or just want to get in touch, use the form below.\nWe look forward to hearing from you!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5,color: ColorsManager.white70),
            ),
            const SizedBox(height: 24),

            // Input Fields
            _buildTextField(label: 'Name', icon: Icons.person),
            const SizedBox(height: 12),
            _buildTextField(label: 'Email', icon: Icons.email),
            const SizedBox(height: 12),
            _buildTextField(label: 'Phone', icon: Icons.phone),
            const SizedBox(height: 12),
            _buildTextField(label: 'Enter your message', icon: Icons.message, maxLines: 4),
            const SizedBox(height: 16),

            // Send Button
            ElevatedButton(
              onPressed: () {
                // Action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonColorApp,
                minimumSize: Size(screenSize.width * 0.7, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Send", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
