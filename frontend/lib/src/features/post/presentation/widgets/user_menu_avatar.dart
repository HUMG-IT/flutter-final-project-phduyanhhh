import 'package:flutter/material.dart';

class UserMenuAvatar extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onLogout;

  const UserMenuAvatar({
    super.key,
    required this.onProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_UserMenuAction>(
      onSelected: (value) {
        switch (value) {
          case _UserMenuAction.profile:
            onProfile();
            break;
          case _UserMenuAction.logout:
            onLogout();
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _UserMenuAction.profile,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Trang cá nhân'),
          ),
        ),
        PopupMenuItem(
          value: _UserMenuAction.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
      ),
    );
  }
}

enum _UserMenuAction {
  profile,
  logout,
}
