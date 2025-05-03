import 'package:flutter/material.dart';

// TODO: Import Groups BLoC, Events, States
// TODO: Import Group model

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  // TODO: Fetch groups from GroupsBloc/Repository
  final List<Map<String, dynamic>> _groups = [
    {
      'id': 'group1',
      'name': 'Work Colleagues / زملاء العمل',
      'members': ['You / أنت', 'Ali / علي', 'Fatima / فاطمة'],
      'destination': 'Office Building / مبنى المكتب',
    },
    {
      'id': 'group2',
      'name': 'Neighborhood Friends / أصدقاء الحي',
      'members': ['You / أنت', 'Ahmed / أحمد', 'Sara / سارة', 'Khalid / خالد'],
      'destination': 'Community Center / المركز المجتمعي',
    },
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to load groups
  }

  void _createNewGroup() {
    // TODO: Navigate to Create Group Screen (Knowledge ID: user_26)
    print("Navigate to create new group screen");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create New Group Tapped / تم النقر على إنشاء مجموعة جديدة')), // Placeholder
    );
    // Example: Add a dummy group for UI testing
    setState(() {
      _groups.add({
        'id': 'group${_groups.length + 1}',
        'name': 'New Group / مجموعة جديدة ${_groups.length + 1}',
        'members': ['You / أنت'],
        'destination': 'Not Set / لم يتم التعيين',
      });
    });
  }

  void _viewGroupDetails(Map<String, dynamic> group) {
    // TODO: Navigate to Group Details Screen
    print("Navigate to view group details for: ${group['name']}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing Group: ${group['name']} / عرض المجموعة: ${group['name']}')), // Placeholder
    );
  }

  void _leaveGroup(Map<String, dynamic> group) {
    // TODO: Show confirmation and dispatch event to BLoC
    print("Leave group: ${group['name']}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Leave Group / مغادرة المجموعة', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to leave the group "${group['name']}"? / هل أنت متأكد من رغبتك في مغادرة مجموعة "${group['name']}"؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel / إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Dispatch leave group event to BLoC
              setState(() {
                _groups.remove(group);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Left group: ${group['name']} / تمت مغادرة المجموعة: ${group['name']}')), // Placeholder
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Yes, Leave / نعم، مغادرة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTile(Map<String, dynamic> group) {
    List<String> members = List<String>.from(group['members'] ?? []);
    String membersPreview = members.join(', ');
    if (members.length > 3) {
      membersPreview = '${members.take(3).join(', ')}, ...';
    }

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        leading: CircleAvatar(
          backgroundColor: Colors.amber[700],
          child: const Icon(Icons.group, color: Colors.black),
        ),
        title: Text(group['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Members / الأعضاء: $membersPreview',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (group['destination'] != 'Not Set / لم يتم التعيين')
              Text(
                'Common Destination / وجهة مشتركة: ${group['destination']}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[400]),
          color: Colors.grey[800],
          onSelected: (String result) {
            switch (result) {
              case 'details':
                _viewGroupDetails(group);
                break;
              case 'leave':
                _leaveGroup(group);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'details',
              child: Text('View Details / عرض التفاصيل', style: TextStyle(color: Colors.white)),
            ),
            // TODO: Add 'Invite Members' option if user is admin/creator
            const PopupMenuItem<String>(
              value: 'leave',
              child: Text('Leave Group / مغادرة المجموعة', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
        onTap: () => _viewGroupDetails(group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Groups / مجموعات الركوب'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: _groups.isEmpty
                ? const Center(
                    child: Text(
                      'You are not part of any ride groups yet. / أنت لست عضوًا في أي مجموعات ركوب بعد.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      return _buildGroupTile(_groups[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _createNewGroup,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('Create New Group / إنشاء مجموعة جديدة'),
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
          // TODO: Add option to Join Group via code/link?
        ],
      ),
    );
  }
}

