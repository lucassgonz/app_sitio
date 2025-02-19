import 'package:flutter/material.dart';
import 'custom_scaffold.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the settings screen",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32), // Espaçamento entre os elementos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ativar modo escuro"),
                Switch(
                  value: isDarkMode,
                  onChanged: onThemeChanged, 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
