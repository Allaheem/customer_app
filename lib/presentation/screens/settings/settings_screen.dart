import 'package:flutter/material.dart';

// TODO: Import Settings BLoC, Events, States
// TODO: Import ProfileScreen, PaymentOptionsScreen, PrivacyDashboardScreen, etc.

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Fetch settings from BLoC/Repository
  bool _isUniversalModeEnabled = false; // Accessibility Step 018 (Knowledge ID: user_20)
  bool _isDarkModeEnabled = true; // Placeholder for Theme Toggle (Step 019)

  void _updateSetting(String key, bool value) {
    // TODO: Dispatch event to update setting
    print("Updating setting: $key = $value");
    setState(() {
      if (key == 'universalMode') {
        _isUniversalModeEnabled = value;
        // TODO: Apply necessary UI/UX changes for Universal Mode
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Universal Mode ${_isUniversalModeEnabled ? "Enabled / تم التفعيل" : "Disabled / تم التعطيل"}')),
        );
      } else if (key == 'darkMode') {
        _isDarkModeEnabled = value;
        // TODO: Trigger theme change (Step 019)
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dark Mode ${_isDarkModeEnabled ? "Enabled / تم التفعيل" : "Disabled / تم التعطيل"}')),
        );
      }
    });
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber[700]),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[400])) : null,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
      onTap: onTap,
      tileColor: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

   Widget _buildSwitchTile(String title, String subtitle, bool value, String key, IconData icon) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      value: value,
      onChanged: (newValue) => _updateSetting(key, newValue),
      activeColor: Colors.amber[700],
      inactiveTrackColor: Colors.grey[700],
      activeTrackColor: Colors.amber[900]?.withOpacity(0.7),
      secondary: Icon(icon, color: Colors.amber[700]),
      tileColor: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings / الإعدادات'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Section
          Text('Account / الحساب', style: TextStyle(color: Colors.amber[700], fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSettingsTile('Profile / الملف الشخصي', Icons.person_outline, () { /* TODO: Navigate to Profile */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('Payment Options / خيارات الدفع', Icons.payment_outlined, () { /* TODO: Navigate to Payment Options */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('Ride History / سجل الرحلات', Icons.history_outlined, () { /* TODO: Navigate to Ride History */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('Ride Groups / مجموعات الركوب', Icons.group_outlined, () { /* TODO: Navigate to Groups */ }),

          Divider(color: Colors.grey[800], height: 40),

          // App Settings Section
          Text('App Settings / إعدادات التطبيق', style: TextStyle(color: Colors.amber[700], fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSettingsTile('Privacy Dashboard / لوحة تحكم الخصوصية', Icons.privacy_tip_outlined, () { /* TODO: Navigate to Privacy Dashboard */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('Notifications / الإشعارات', Icons.notifications_outlined, () { /* TODO: Navigate to Notification Settings */ }),
          const SizedBox(height: 10),
          // Theme Toggle (Step 019)
          _buildSwitchTile(
            'Dark Mode / الوضع الداكن',
            'Enable or disable dark theme / تفعيل أو تعطيل المظهر الداكن',
            _isDarkModeEnabled,
            'darkMode',
            Icons.brightness_4_outlined
          ),

          Divider(color: Colors.grey[800], height: 40),

          // Accessibility Section (Step 018 - Knowledge ID: user_20)
          Text('Accessibility / إمكانية الوصول', style: TextStyle(color: Colors.amber[700], fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSwitchTile(
            'Universal Mode / الوضع الشامل',
            'Enhanced accessibility features / ميزات إمكانية وصول محسنة',
            _isUniversalModeEnabled,
            'universalMode',
            Icons.accessibility_new_outlined
          ),
          // TODO: Add specific accessibility settings if Universal Mode is off (e.g., font size)

          Divider(color: Colors.grey[800], height: 40),

          // Support Section
          Text('Support / الدعم', style: TextStyle(color: Colors.amber[700], fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSettingsTile('Help Center / مركز المساعدة', Icons.help_outline, () { /* TODO: Navigate to Help Center */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('Report a Problem / الإبلاغ عن مشكلة', Icons.report_problem_outlined, () { /* TODO: Navigate to Complaint Screen */ }),
          const SizedBox(height: 10),
          _buildSettingsTile('About / حول التطبيق', Icons.info_outline, () { /* TODO: Navigate to About Screen */ }),

          Divider(color: Colors.grey[800], height: 40),

          // Logout Button
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Dispatch Logout event
                print("Logout tapped");
                // TODO: Navigate to Login Screen
              },
              child: Text('Logout / تسجيل الخروج', style: TextStyle(color: Colors.redAccent[100], fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

