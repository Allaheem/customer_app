import 'package:flutter/material.dart';

// TODO: Import Privacy BLoC, Events, States
// TODO: Import UserSettings model

class PrivacyDashboardScreen extends StatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  State<PrivacyDashboardScreen> createState() => _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState extends State<PrivacyDashboardScreen> {
  // TODO: Fetch current settings from PrivacyBloc/Repository
  bool _sharePreciseLocation = true;
  bool _shareLocationDuringRideOnly = true;
  bool _showPhoneNumberToDriver = true;
  bool _allowAccessToRideHistory = true;
  bool _allowPromotionalEmails = false;
  bool _allowDataForAnalysis = true; // Anonymous analysis

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to load privacy settings
  }

  void _updateSetting(String settingKey, bool newValue) {
    // TODO: Dispatch UpdatePrivacySetting event to BLoC
    print("Updating setting: $settingKey = $newValue");
    setState(() {
      switch (settingKey) {
        case 'preciseLocation':
          _sharePreciseLocation = newValue;
          // If precise location is turned off, 'during ride only' might become irrelevant or disabled
          if (!newValue) _shareLocationDuringRideOnly = false;
          break;
        case 'locationDuringRideOnly':
          _shareLocationDuringRideOnly = newValue;
          break;
        case 'showPhoneNumber':
          _showPhoneNumberToDriver = newValue;
          break;
        case 'accessRideHistory':
          _allowAccessToRideHistory = newValue;
          break;
        case 'promotionalEmails':
          _allowPromotionalEmails = newValue;
          break;
        case 'dataForAnalysis':
          _allowDataForAnalysis = newValue;
          break;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Setting Updated / تم تحديث الإعداد: $settingKey'), duration: const Duration(seconds: 1)),
    );
  }

  Widget _buildPrivacySwitchTile({
    required String titleEn,
    required String titleAr,
    required String descriptionEn,
    required String descriptionAr,
    required bool value,
    required String settingKey,
    bool enabled = true, // This parameter controls the onChanged callback
  }) {
    return SwitchListTile(
      title: Text("$titleAr / $titleEn", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text("$descriptionAr / $descriptionEn", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      value: value,
      onChanged: enabled ? (newValue) => _updateSetting(settingKey, newValue) : null, // Correctly disables if enabled is false
      activeColor: Colors.amber[700],
      inactiveTrackColor: Colors.grey[700],
      activeTrackColor: Colors.amber[900]?.withOpacity(0.7),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      secondary: Icon(
        settingKey == 'preciseLocation' || settingKey == 'locationDuringRideOnly' ? Icons.location_on_outlined
        : settingKey == 'showPhoneNumber' ? Icons.phone_outlined
        : settingKey == 'accessRideHistory' ? Icons.history_outlined
        : settingKey == 'promotionalEmails' ? Icons.email_outlined
        : settingKey == 'dataForAnalysis' ? Icons.analytics_outlined
        : Icons.privacy_tip_outlined,
        color: Colors.amber[700]
      ),
      tileColor: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // Removed the incorrect 'enabled: enabled,' line here
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    // final ThemeData theme = Theme.of(context); // Assuming theme is provided higher up

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Dashboard / لوحة تحكم الخصوصية'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Manage Your Data Sharing Preferences / إدارة تفضيلات مشاركة بياناتك',
            style: TextStyle(color: Colors.grey[300], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Location Sharing (Knowledge ID: user_9, user_10)
          _buildPrivacySwitchTile(
            titleEn: 'Share Precise Location',
            titleAr: 'مشاركة الموقع الدقيق',
            descriptionEn: 'Allow the app to use your precise location for pickups and driver matching.',
            descriptionAr: 'السماح للتطبيق باستخدام موقعك الدقيق لتحديد مكان الالتقاء ومطابقة السائقين.',
            value: _sharePreciseLocation,
            settingKey: 'preciseLocation',
          ),
          const SizedBox(height: 10),
          _buildPrivacySwitchTile(
            titleEn: 'Share Location Only During Ride',
            titleAr: 'مشاركة الموقع أثناء الرحلة فقط',
            descriptionEn: 'Limit location sharing only to the time you are actively in a ride.',
            descriptionAr: 'تقييد مشاركة الموقع فقط أثناء تواجدك في رحلة نشطة.',
            value: _shareLocationDuringRideOnly,
            settingKey: 'locationDuringRideOnly',
            enabled: _sharePreciseLocation, // Enable only if precise location is shared
          ),
          Divider(color: Colors.grey[800], height: 30),

          // Phone Number Visibility (Knowledge ID: user_9, user_10)
          _buildPrivacySwitchTile(
            titleEn: 'Show Phone Number to Driver',
            titleAr: 'إظهار رقم الهاتف للسائق',
            descriptionEn: 'Allow the driver to see your phone number for communication purposes.',
            descriptionAr: 'السماح للسائق برؤية رقم هاتفك لأغراض التواصل.',
            value: _showPhoneNumberToDriver,
            settingKey: 'showPhoneNumber',
          ),
          Divider(color: Colors.grey[800], height: 30),

          // Ride History Access (Knowledge ID: user_9, user_10)
          _buildPrivacySwitchTile(
            titleEn: 'Allow App Access to Ride History',
            titleAr: 'السماح للتطبيق بالوصول لسجل الرحلات',
            descriptionEn: 'Allow the app to store and display your past ride history.',
            descriptionAr: 'السماح للتطبيق بتخزين وعرض سجل رحلاتك السابقة.',
            value: _allowAccessToRideHistory,
            settingKey: 'accessRideHistory',
          ),
          Divider(color: Colors.grey[800], height: 30),

          // Communication Preferences
          _buildPrivacySwitchTile(
            titleEn: 'Receive Promotional Emails',
            titleAr: 'استقبال رسائل البريد الإلكتروني الترويجية',
            descriptionEn: 'Receive emails about promotions, offers, and news.',
            descriptionAr: 'استقبال رسائل بريد إلكتروني حول العروض الترويجية والأخبار.',
            value: _allowPromotionalEmails,
            settingKey: 'promotionalEmails',
          ),
          Divider(color: Colors.grey[800], height: 30),

          // Data Analysis
          _buildPrivacySwitchTile(
            titleEn: 'Allow Data for Analysis',
            titleAr: 'السماح باستخدام البيانات للتحليل',
            descriptionEn: 'Allow use of anonymized data to improve app performance and features.',
            descriptionAr: 'السماح باستخدام البيانات مجهولة المصدر لتحسين أداء التطبيق وميزاته.',
            value: _allowDataForAnalysis,
            settingKey: 'dataForAnalysis',
          ),
          const SizedBox(height: 20),

          // Link to full privacy policy
          TextButton(
            onPressed: () {
              // TODO: Open Privacy Policy URL
              print("Navigate to Privacy Policy");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Privacy Policy... / جاري فتح سياسة الخصوصية...')), // Placeholder
              );
            },
            child: Text(
              'View Full Privacy Policy / عرض سياسة الخصوصية الكاملة',
              style: TextStyle(color: Colors.amber[700], decoration: TextDecoration.underline, decorationColor: Colors.amber[700]), // Ensure underline matches text color
            ),
          ),
        ],
      ),
    );
  }
}

