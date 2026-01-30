import 'package:flutter/material.dart';
import '../main.dart'; 
import '../l10n/app_localizations.dart'; 
import 'about_page.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _changeLanguage() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.language, 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87
                )
              ),
              const SizedBox(height: 20),
              
              _buildLanguageOption("Bahasa Indonesia", const Locale('id'), isDarkMode),
              const SizedBox(height: 10),
              _buildLanguageOption("English", const Locale('en'), isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String label, Locale locale, bool isDarkMode) {
    bool isSelected = languageNotifier.value == locale;
    Color primaryColor = const Color(0xFFd99de9);
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected 
            ? primaryColor.withOpacity(0.1) 
            : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: primaryColor) : null,
      ),
      child: ListTile(
        title: Text(
          label, 
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isDarkMode ? Colors.white : Colors.black87
          )
        ),
        trailing: isSelected ? Icon(Icons.check_circle_rounded, color: primaryColor) : null,
        onTap: () {
          languageNotifier.value = locale; 
          Navigator.pop(context); 
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        bool isDarkMode = (mode == ThemeMode.dark); 
        if (mode == ThemeMode.system) {
          isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
        }

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA), 
          
          appBar: AppBar(
            title: Text(
              texts.settings, 
              style: TextStyle(fontWeight: FontWeight.w800, color: isDarkMode ? Colors.white : Colors.black87)
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: isDarkMode ? Colors.white : Colors.black87,
            elevation: 0,
            automaticallyImplyLeading: false, 
          ),
          
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // [ANIMASI 1] Slide Up Kartu Pertama
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(texts.appearance, isDarkMode), 
                    _buildSettingsCard(
                      isDarkMode,
                      children: [
                        SwitchListTile(
                          activeColor: const Color(0xFFd99de9),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          // [ANIMASI] Ikon berubah halus
                          secondary: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
                            child: _buildIcon(
                              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded, 
                              isDarkMode ? Colors.purple : Colors.orange, 
                              isDarkMode,
                              key: ValueKey(isDarkMode),
                            ),
                          ),
                          title: Text(
                            texts.darkMode, 
                            style: TextStyle(fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black87)
                          ),
                          value: isDarkMode,
                          onChanged: (val) {
                            themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          },
                        ),
                        _buildDivider(isDarkMode),
                        
                        _buildListTile(
                          icon: Icons.language_rounded,
                          iconColor: Colors.blue,
                          title: texts.language, 
                          subtitle: languageNotifier.value.languageCode == 'id' ? "Indonesia" : "English",
                          onTap: _changeLanguage, 
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // [ANIMASI 2] Slide Up Kartu Kedua (Sedikit delay agar efek air terjun)
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 40 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(texts.information, isDarkMode), 
                    _buildSettingsCard(
                      isDarkMode,
                      children: [
                        _buildListTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: Colors.orange,
                          title: texts.aboutApp,
                          isDarkMode: isDarkMode,
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (_) => const AboutPage())
                            );
                          },
                        ),
                        _buildDivider(isDarkMode),

                        _buildListTile(
                          icon: Icons.verified_rounded,
                          iconColor: Colors.teal,
                          title: texts.appVersion,
                          trailingText: texts.version,
                          isDarkMode: isDarkMode,
                          onTap: () {}, 
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Center(
                      child: Text(
                        "Planno App © 2026",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- HELPER WIDGETS ---
  
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.w900, 
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, 
          letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildSettingsCard(bool isDarkMode, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.grey.withOpacity(0.05), 
              blurRadius: 20, 
              offset: const Offset(0, 5)
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildIcon(icon, iconColor, isDarkMode),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w600, 
          fontSize: 15,
          color: isDarkMode ? Colors.white : const Color(0xFF2D3142)
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500))
          : null,
      trailing: trailingText != null
          ? Text(trailingText, style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13))
          : Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildIcon(IconData icon, Color color, bool isDarkMode, {Key? key}) {
    return Container(
      key: key,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1, 
      thickness: 0.5, 
      indent: 70, 
      endIndent: 20,
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
    );
  }
}