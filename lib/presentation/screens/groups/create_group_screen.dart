import 'package:flutter/material.dart';

// TODO: Import Groups BLoC, Events, States
// TODO: Import Contact Picker/Search functionality

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final List<String> _invitedMembers = []; // Placeholder for invited member identifiers (e.g., phone numbers, user IDs)

  @override
  void dispose() {
    _groupNameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _inviteMembers() {
    // TODO: Implement member invitation logic (e.g., open contact picker)
    print("Invite members button tapped");
    // Placeholder: Add dummy members
    setState(() {
      _invitedMembers.add("Friend ${_invitedMembers.length + 1} / صديق ${_invitedMembers.length + 1}");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member Added (Placeholder) / تمت إضافة عضو (عينة)')),
    );
  }

  void _removeMember(String member) {
    setState(() {
      _invitedMembers.remove(member);
    });
  }

  void _submitCreateGroup() {
    if (_formKey.currentState!.validate()) {
      final String groupName = _groupNameController.text.trim();
      final String destination = _destinationController.text.trim();

      // TODO: Dispatch CreateGroup event to GroupsBloc
      print("Creating group: Name=$groupName, Destination=$destination, Members=$_invitedMembers");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group "$groupName" Created (Placeholder) / تم إنشاء مجموعة "$groupName" (عينة)')),
      );

      // Navigate back after creation
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Group / إنشاء مجموعة جديدة'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _groupNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Group Name / اسم المجموعة',
                  labelStyle: TextStyle(color: Colors.amber[700]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group name / يرجى إدخال اسم للمجموعة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _destinationController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Common Destination (Optional) / وجهة مشتركة (اختياري)',
                  labelStyle: TextStyle(color: Colors.amber[700]),
                  hintText: 'e.g., Office Building / مثال: مبنى المكتب',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  // TODO: Add map icon to select destination from map?
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Invite Members / دعوة أعضاء',
                style: TextStyle(color: Colors.amber[700], fontSize: 18),
              ),
              const SizedBox(height: 10),
              // Invited Members List
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _invitedMembers.map((member) => Chip(
                  label: Text(member, style: const TextStyle(color: Colors.black)),
                  backgroundColor: Colors.amber[600],
                  deleteIconColor: Colors.black54,
                  onDeleted: () => _removeMember(member),
                )).toList(),
              ),
              const SizedBox(height: 10),
              // Invite Button
              OutlinedButton.icon(
                onPressed: _inviteMembers,
                icon: Icon(Icons.person_add_alt_1, color: Colors.amber[700]),
                label: Text('Add Members / إضافة أعضاء', style: TextStyle(color: Colors.amber[700])),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.amber[700]!),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 40),
              // Create Group Button
              ElevatedButton(
                onPressed: _submitCreateGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Create Group / إنشاء المجموعة'),
                // TODO: Add animation on tap (Knowledge ID: user_47)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

