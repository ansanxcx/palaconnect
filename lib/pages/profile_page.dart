import 'package:flutter/material.dart';
// 1. Add Firebase Auth import
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // 2. Implement the Sign Out function
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // On success, navigate to the login screen and clear the navigation stack
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A7C2F), Color(0xFF66A03B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // The following user details will be populated once you integrate a database like Firestore
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ??
                        'example@email.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ACCOUNT",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A7C2F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ProfileMenuTile(
                    title: 'Edit Profile',
                    subtitle: 'Update your name, mobile, and DOB',
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF66A03B),
                    onTap: () {},
                  ),
                  _ProfileMenuTile(
                    title: 'Change Password',
                    subtitle: 'Update your login password',
                    icon: Icons.lock_outline,
                    iconColor: const Color(0xFF66A03B),
                    onTap: () {
                      // Optionally navigate to a page for changing password
                    },
                  ),
                  _ProfileMenuTile(
                    title: 'My Orders',
                    subtitle: 'View past and current orders',
                    icon: Icons.assignment_outlined,
                    iconColor: const Color(0xFF66A03B),
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  const SizedBox(height: 20),

                  // General Settings
                  const Text(
                    "GENERAL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A7C2F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ProfileMenuTile(
                    title: 'Settings',
                    subtitle: 'Notifications, language, and privacy',
                    icon: Icons.settings_outlined,
                    iconColor: const Color(0xFF66A03B),
                    onTap: () {},
                  ),
                  _ProfileMenuTile(
                    title: 'Help & Support',
                    subtitle: 'Find answers or contact support',
                    icon: Icons.help_outline,
                    iconColor: const Color(0xFF66A03B),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),

                  // 3. New Sign Out Tile
                  _ProfileMenuTile(
                    title: 'Sign Out',
                    subtitle: 'Log out of your PalaConnect account',
                    icon: Icons.logout,
                    iconColor: Colors.red[400]!,
                    isDestructive: true,
                    // 4. Connect the button to the sign out function
                    onTap: () => _signOut(context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? Colors.red[700] : const Color(0xFF2D3436);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.green[100]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
