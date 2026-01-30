import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'login_page.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  User? user;
  String name = "Pengguna";
  String email = "Loading...";
  String? photoUrl;
  String initial = "U";

  // Controller untuk animasi ringan
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // [ANIMASI RINGAN] Setup animasi Fade & Slide Up sederhana
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadUserData() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      name = user?.displayName ?? "User"; 
      email = user?.email ?? "-";
      photoUrl = user?.photoURL;
      initial = name.isNotEmpty ? name[0].toUpperCase() : "U";
    });
  }

  void _showEditNameDialog() {
    final nameController = TextEditingController(text: name);
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(texts.editNameTitle, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: TextField(
          controller: nameController,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            labelText: texts.nameLabel,
            labelStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFd99de9)),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(texts.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFd99de9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                try {
                  await FirebaseService().updateUserName(nameController.text);
                  if (mounted) {
                    Navigator.pop(context);
                    _loadUserData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(texts.nameSuccess), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(texts.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final Color primaryColor = const Color(0xFFd99de9);
    final Color backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          texts.myProfile, 
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Stack(
        children: [
          // 1. BACKGROUND (Static)
          Container(
            height: 280, 
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  const Color(0xFFE1BEE7),
                ],
              ),
            ),
          ),

          // 2. KONTEN (Animated)
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 40), 
                    
                    // --- KARTU PROFIL ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Avatar dengan Error Handling yang Benar
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: primaryColor.withOpacity(0.15),
                              // [FIX] Pastikan backgroundImage hanya di-set jika photoUrl TIDAK null
                              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                              // [FIX] Error handler hanya dipasang jika ada photoUrl
                              onBackgroundImageError: photoUrl != null 
                                  ? (_, __) => setState(() { photoUrl = null; }) 
                                  : null,
                              child: photoUrl == null 
                                  ? Text(initial, style: TextStyle(fontSize: 32, color: primaryColor, fontWeight: FontWeight.bold))
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Nama & Edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  name, 
                                  style: TextStyle(
                                    fontSize: 22, 
                                    fontWeight: FontWeight.bold, 
                                    color: isDarkMode ? Colors.white : const Color(0xFF2D3142)
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: _showEditNameDialog,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit_rounded, size: 14, color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(email, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- INFORMASI AKUN ---
                    _buildSectionTitle(texts.accountInfo, isDarkMode),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (!isDarkMode)
                            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildProfileItem(Icons.email_outlined, texts.emailLabel, email, isDarkMode),
                          _buildDivider(isDarkMode),
                          _buildProfileItem(Icons.verified_user_rounded, texts.statusLabel, texts.verifiedMember, isDarkMode, iconColor: Colors.teal),
                          _buildDivider(isDarkMode),
                          _buildProfileItem(Icons.calendar_month_rounded, texts.joinedDate, "Januari 2026", isDarkMode, iconColor: Colors.orange),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- PENGATURAN ---
                    _buildSectionTitle(texts.settingsTitle, isDarkMode),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (!isDarkMode)
                            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1), 
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
                        ),
                        title: Text(
                          texts.logout, 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16)
                        ), 
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
                        onTap: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: cardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(texts.confirmTitle, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                              content: Text(texts.logoutConfirm, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: Text(texts.cancel)), 
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () => Navigator.pop(context, true), 
                                  child: Text(texts.logout),
                                ), 
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await FirebaseService().logout();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title, 
        style: TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.w900, 
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, 
          letterSpacing: 1.0
        )
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value, bool isDarkMode, {Color iconColor = const Color(0xFFd99de9)}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1), 
          borderRadius: BorderRadius.circular(12)
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          value, 
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: isDarkMode ? Colors.white : const Color(0xFF2D3142)
          )
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1, 
      thickness: 0.5, 
      indent: 76, 
      endIndent: 20, 
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200
    );
  }
}