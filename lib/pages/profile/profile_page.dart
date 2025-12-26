import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? toggleTheme;
  final bool? isDarkMode;

  const ProfilePage({Key? key, this.toggleTheme, this.isDarkMode})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isLoggedIn = false;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    UserModel? user;

    if (loggedIn) {
      user = await AuthService.getStoredUser();
    }

    setState(() {
      isLoggedIn = loggedIn;
      currentUser = user;
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      setState(() {
        isLoggedIn = false;
        currentUser = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil logout')),
      );
    }
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ganti Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password baru tidak cocok')),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      final result = await AuthService.changePassword(
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text,
                      );

                      setDialogState(() => isLoading = false);

                      if (result['success'] == true) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password berhasil diubah'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                result['message'] ?? 'Gagal mengubah password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADB5),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    final isDark = widget.isDarkMode ?? false;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: const Color(0xFF00ADB5),
        ),
        title: const Text('Mode Tampilan'),
        subtitle: Text(isDark ? 'Mode Gelap' : 'Mode Terang'),
        trailing: Switch(
          value: isDark,
          onChanged:
              widget.toggleTheme != null ? (_) => widget.toggleTheme!() : null,
          activeColor: const Color(0xFF00ADB5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: isLoggedIn ? _buildLoggedInView() : _buildGuestView(),
            ),
    );
  }

  Widget _buildGuestView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xFF393E46),
          child: Icon(Icons.person_outline, size: 80, color: Color(0xFF00ADB5)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Selamat Datang!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Login untuk mengakses fitur lengkap',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, '/login');
              _checkAuthStatus(); // Refresh after login
            },
            icon: const Icon(Icons.login),
            label: const Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADB5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Register Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, '/register');
              _checkAuthStatus(); // Refresh after register
            },
            icon: const Icon(Icons.person_add),
            label: const Text(
              'Buat Akun Baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF00ADB5)),
              foregroundColor: const Color(0xFF00ADB5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),

        // Theme Toggle for Guest
        const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildThemeToggle(),

        const SizedBox(height: 24),
        const Text(
          'Anda bisa melihat Doa dan Artikel tanpa login.',
          style: TextStyle(
              fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoggedInView() {
    final user = currentUser!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundColor:
              user.isAdmin ? const Color(0xFF00ADB5) : const Color(0xFF393E46),
          child: Icon(
            user.isAdmin ? Icons.admin_panel_settings : Icons.person,
            size: 80,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Admin Badge
        if (user.isAdmin)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00ADB5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '👑 ADMIN',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),

        // User Info Cards
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF00ADB5)),
            title: const Text('Email'),
            subtitle: Text(user.email),
          ),
        ),
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.badge, color: Color(0xFF00ADB5)),
            title: const Text('Role'),
            subtitle: Text(user.isAdmin ? 'Administrator' : 'User'),
          ),
        ),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        // Theme Toggle
        const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildThemeToggle(),

        // Change Password Card
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF00ADB5)),
            title: const Text('Ganti Password'),
            subtitle: const Text('Ubah password akun Anda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(),
          ),
        ),

        const SizedBox(height: 24),

        // Logout Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        if (user.isAdmin) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Admin Menu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buka halaman Doa atau Artikel,\nlalu tap 📝 untuk kelola konten.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
