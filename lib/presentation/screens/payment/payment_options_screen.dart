import 'package:flutter/material.dart';

// TODO: Import BLoC for payment methods management
// TODO: Import models for PaymentMethod

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  // TODO: Fetch payment methods from BLoC/Repository and include Cash/CliQ based on availability
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'cash',
      'id': 'cash_option',
      'isDefault': false, // Cash usually isn't default if cards exist
    },
    {
      'type': 'card',
      'id': 'card_4242',
      'last4': '4242',
      'brand': 'Visa',
      'isDefault': true,
    },
    {
      'type': 'card',
      'id': 'card_5555',
      'last4': '5555',
      'brand': 'Mastercard',
      'isDefault': false,
    },
    {
      'type': 'paypal',
      'id': 'paypal_user@example.com',
      'email': 'user@example.com',
      'isDefault': false,
    },
    {
      'type': 'cliq', // Added CliQ option (Knowledge ID: user_42)
      'id': 'cliq_service',
      'name': 'CliQ Service', // Placeholder name
      'isDefault': false,
    },
  ];

  String? _selectedDefaultMethodId; // Use a unique ID for each method

  @override
  void initState() {
    super.initState();
    // Initialize selected default based on fetched data
    _selectedDefaultMethodId = _paymentMethods.firstWhere((m) => m['isDefault'] == true, orElse: () => _paymentMethods.first)['id'];
  }

  void _addPaymentMethod() {
    // TODO: Navigate to Add Card / Add PayPal / Add CliQ screen
    // print("Navigate to add payment method screen");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Payment Method Tapped / تم النقر على إضافة طريقة دفع')), // Placeholder
    );
  }

  void _editPaymentMethod(Map<String, dynamic> method) {
    // Cannot edit Cash or potentially CliQ in the same way as cards/paypal
    if (method['type'] == 'cash' || method['type'] == 'cliq') {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Cannot edit ${method["type"]} details here / لا يمكن تعديل تفاصيل ${method["type"]} هنا")), // Placeholder
       );
       return;
    }
    // TODO: Navigate to Edit Card / Edit PayPal screen
    // print("Navigate to edit payment method screen for: ${method["id"]}");
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${method['brand'] ?? method['type']} Tapped / تم النقر على تعديل ${method['brand'] ?? method['type']}')), // Placeholder
    );
  }

   void _removePaymentMethod(Map<String, dynamic> method) {
    // Cannot remove Cash option
    if (method['type'] == 'cash') {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Cannot remove Cash option / لا يمكن إزالة خيار الدفع النقدي')), // Placeholder
       );
       return;
    }

    // TODO: Show confirmation and dispatch event to BLoC
    // print("Remove payment method: ${method["id"]}");
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Remove Payment Method / إزالة طريقة الدفع", style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to remove this ${method['brand'] ?? method['name'] ?? method['type']}? / هل أنت متأكد من رغبتك في إزالة ${method['brand'] ?? method['name'] ?? method['type']} هذه؟', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel / إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // TODO: Dispatch remove event to BLoC
                setState(() {
                  final removedId = method['id'];
                  _paymentMethods.removeWhere((m) => m['id'] == removedId);
                  // If the removed method was default, select another one (prefer cash or first available)
                  if (_selectedDefaultMethodId == removedId) {
                     final cashOption = _paymentMethods.firstWhere((m) => m['type'] == 'cash', orElse: () => {});
                     if (cashOption.isNotEmpty) {
                        _setDefaultPaymentMethod(cashOption['id']);
                     } else if (_paymentMethods.isNotEmpty) {
                        _setDefaultPaymentMethod(_paymentMethods.first['id']);
                     } else {
                        _selectedDefaultMethodId = null;
                     }
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${method['brand'] ?? method['name'] ?? method['type']} Removed / تم حذف ${method['brand'] ?? method['name'] ?? method['type']}')), // Placeholder
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Yes, Remove / نعم، إزالة", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
  }

  void _setDefaultPaymentMethod(String methodId) {
     // TODO: Dispatch set default event to BLoC
     // print("Set default payment method: $methodId");
     setState(() {
       _selectedDefaultMethodId = methodId;
       for (var method in _paymentMethods) {
         method['isDefault'] = (method['id'] == methodId);
       }
     });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default payment method updated / تم تحديث طريقة الدفع الافتراضية')), // Placeholder
      );
  }

  Widget _buildPaymentMethodTile(Map<String, dynamic> method) {
    IconData iconData;
    String title;
    String subtitle = '';
    String currentId = method['id'];
    bool canEditOrRemove = true;

    switch (method['type']) {
      case 'cash': // Added Cash option (Knowledge ID: user_42)
        iconData = Icons.money;
        title = 'Cash / الدفع نقداً';
        canEditOrRemove = false;
        break;
      case 'card':
        iconData = Icons.credit_card;
        title = '${method['brand']} ending in ${method['last4']}';
        subtitle = 'Expires XX/XX'; // TODO: Get expiry date
        break;
      case 'paypal':
        iconData = Icons.paypal; // Or a custom PayPal icon
        title = 'PayPal';
        subtitle = method['email'];
        break;
      case 'cliq': // Added CliQ option (Knowledge ID: user_42)
        iconData = Icons.account_balance_wallet; // Placeholder icon
        title = method['name'] ?? 'CliQ';
        subtitle = 'CliQ Payment Service'; // Placeholder subtitle
        // Decide if CliQ can be edited/removed like PayPal/Card
        // canEditOrRemove = true; // Or false depending on integration
        break;
      default:
        iconData = Icons.payment;
        title = 'Unknown Method';
        canEditOrRemove = false;
    }

    return ListTile(
      leading: Icon(iconData, color: Colors.amber[700], size: 40),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: currentId,
            groupValue: _selectedDefaultMethodId,
            onChanged: (value) {
              if (value != null) {
                _setDefaultPaymentMethod(value);
              }
            },
            activeColor: Colors.amber[700],
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.amber[700]!;
                }
                return Colors.grey; // Color for the unselected state
              }),
          ),
          if (canEditOrRemove)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              color: Colors.grey[850],
              onSelected: (String result) {
                switch (result) {
                  case 'edit':
                    _editPaymentMethod(method);
                    break;
                  case 'remove':
                    _removePaymentMethod(method);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "edit",
                  child: Text("Edit / تعديل", style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: Text("Remove / إزالة", style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            )
          else
             const SizedBox(width: 48), // Keep spacing consistent
        ],
      ),
      onTap: () => _setDefaultPaymentMethod(currentId), // Allow tapping anywhere on the tile to set default
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Inherit or define the Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context); // Assuming theme is provided

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options / خيارات الدفع'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(            child: _paymentMethods.isEmpty
                ? const Center(
                    child: Text(
                      'No payment methods added yet. / لم تتم إضافة طرق دفع بعد.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    itemCount: _paymentMethods.length,
                    itemBuilder: (context, index) {
                      // Sort methods? Maybe put Cash first/last?
                      return _buildPaymentMethodTile(_paymentMethods[index]);
                    },
                    separatorBuilder: (context, index) => Divider(color: Colors.grey[800], height: 1),
                  ),
          ),
          // TODO: Add Promo Code section here or in ride confirmation? (Knowledge ID: user_50)
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: TextField(
          //     style: TextStyle(color: Colors.white),
          //     decoration: InputDecoration(
          //       labelText: 'Promo Code / كود الخصم',
          //       labelStyle: TextStyle(color: Colors.amber[700]),
          //       suffixIcon: Icon(Icons.local_offer, color: Colors.amber[700]),
          //       // ... other decoration
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addPaymentMethod,
                icon: const Icon(Icons.add_card, color: Colors.black),
                label: const Text('Add Payment Method / إضافة طريقة دفع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // TODO: Add animation on tap (Knowledge ID: user_47)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

