import 'package:flutter/material.dart';

// TODO: Import Groups BLoC, Events, States
// TODO: Import Group model
// TODO: Import Contact Picker/Search functionality

class GroupDetailsScreen extends StatefulWidget {
  final String groupId; // Pass the ID of the group to display

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  // TODO: Fetch group details from GroupsBloc/Repository based on widget.groupId
  late Map<String, dynamic> _groupDetails;
  bool _isCurrentUserAdmin = true; // Placeholder - determine based on fetched data

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to load details for widget.groupId
    // Placeholder data
    _groupDetails = {
      'id': widget.groupId,
      'name': 'Work Colleagues / زملاء العمل',
      'members': ['You / أنت', 'Ali / علي', 'Fatima / فاطمة', 'Zaid / زيد'],
      'destination': 'Office Building / مبنى المكتب',
      'adminUserId': 'currentUser', // Placeholder
    };
    _isCurrentUserAdmin = _groupDetails['adminUserId'] == 'currentUser'; // Example check
  }

  void _inviteMembers() {
    // TODO: Implement member invitation logic (e.g., open contact picker)
    print("Invite members button tapped for group ${widget.groupId}");
    // Placeholder: Add dummy members
    setState(() {
      _groupDetails['members'].add("New Member ${_groupDetails['members'].length - 3} / عضو جديد ${_groupDetails['members'].length - 3}");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member Added (Placeholder) / تمت إضافة عضو (عينة)')),
    );
    // TODO: Dispatch InviteMember event to BLoC
  }

  void _removeMember(String member) {
    if (member == 'You / أنت') {
      _leaveGroup(); // User removing themselves means leaving the group
      return;
    }
    // TODO: Show confirmation and dispatch event to BLoC (only if admin)
    print("Remove member: $member from group ${widget.groupId}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Remove Member / إزالة عضو', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to remove "$member" from the group? / هل أنت متأكد من رغبتك في إزالة "$member" من المجموعة؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel / إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Dispatch RemoveMember event to BLoC
              setState(() {
                _groupDetails['members'].remove(member);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Member "$member" Removed / تم إزالة العضو "$member"')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Yes, Remove / نعم، إزالة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _leaveGroup() {
    // TODO: Show confirmation and dispatch event to BLoC
    print("Leave group: ${_groupDetails['name']}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Leave Group / مغادرة المجموعة', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to leave the group "${_groupDetails['name']}"? / هل أنت متأكد من رغبتك في مغادرة مجموعة "${_groupDetails['name']}"؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel / إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first
              // TODO: Dispatch LeaveGroup event to BLoC
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Left group: ${_groupDetails['name']} / تمت مغادرة المجموعة: ${_groupDetails['name']}')),
              );
              // Navigate back after leaving
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Yes, Leave / نعم، مغادرة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editGroupName() {
     // TODO: Implement editing group name (show dialog with text field)
     print("Edit group name tapped");
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Edit Group Name Tapped (Not Implemented) / تم النقر على تعديل اسم المجموعة (غير منفذ)')),
     );
  }

  void _editDestination() {
     // TODO: Implement editing common destination
     print("Edit destination tapped");
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Edit Destination Tapped (Not Implemented) / تم النقر على تعديل الوجهة (غير منفذ)')),
     );
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);
    final List<String> members = List<String>.from(_groupDetails['members'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(_groupDetails['name'] ?? 'Group Details / تفاصيل المجموعة'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
        actions: [
          if (_isCurrentUserAdmin)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.amber[700]),
              tooltip: 'Edit Group Name / تعديل اسم المجموعة',
              onPressed: _editGroupName,
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Common Destination
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on_outlined, color: Colors.amber[700]),
              title: Text(
                _groupDetails['destination'] != null && _groupDetails['destination'].isNotEmpty
                    ? _groupDetails['destination']
                    : 'No Common Destination Set / لم يتم تعيين وجهة مشتركة',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              subtitle: const Text('Common Destination / وجهة مشتركة', style: TextStyle(color: Colors.grey)),
              trailing: _isCurrentUserAdmin
                  ? IconButton(
                      icon: Icon(Icons.edit_location_alt_outlined, color: Colors.grey[400]),
                      tooltip: 'Edit Destination / تعديل الوجهة',
                      onPressed: _editDestination,
                    )
                  : null,
            ),
            Divider(color: Colors.grey[800], height: 30),

            // Members List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members (${members.length}) / الأعضاء (${members.length})',
                  style: TextStyle(color: Colors.amber[700], fontSize: 18),
                ),
                if (_isCurrentUserAdmin)
                  TextButton.icon(
                    onPressed: _inviteMembers,
                    icon: Icon(Icons.person_add_alt_1, color: Colors.amber[700], size: 18),
                    label: Text('Invite / دعوة', style: TextStyle(color: Colors.amber[700])),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                bool isYou = member == 'You / أنت';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isYou ? Colors.amber[800] : Colors.grey[700],
                    child: Icon(Icons.person_outline, color: isYou ? Colors.black : Colors.white70),
                  ),
                  title: Text(member, style: const TextStyle(color: Colors.white)),
                  trailing: (_isCurrentUserAdmin && !isYou) // Admin can remove others
                      ? IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent[100]),
                          tooltip: 'Remove Member / إزالة عضو',
                          onPressed: () => _removeMember(member),
                        )
                      : null,
                );
              },
            ),
            Divider(color: Colors.grey[800], height: 30),

            // Leave Group Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _leaveGroup,
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text('Leave Group / مغادرة المجموعة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

