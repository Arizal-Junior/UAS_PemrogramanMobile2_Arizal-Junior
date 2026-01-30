import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // Import Bahasa

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Warna Utama (Ungu Pastel)
    final Color primaryColor = const Color(0xFFd99de9);
    // Warna background logo (Ungu sangat muda atau ungu gelap transparan)
    final Color logoBgColor = isDarkMode ? const Color(0xFF2A1A3A) : const Color(0xFFF3E5F5);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      
      // AppBar Minimalis
      appBar: AppBar(
        title: Text(
          texts.aboutApp, 
          style: TextStyle(fontWeight: FontWeight.w800, color: isDarkMode ? Colors.white : Colors.black87)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 1. LOGO DALAM KOTAK PASTEL
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: logoBgColor,
                borderRadius: BorderRadius.circular(30), // Rounded Besar
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.calendar_today_rounded, 
                  size: 60, 
                  color: primaryColor
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 2. NAMA APLIKASI
            Text(
              "PLANNO",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900, 
                color: isDarkMode ? Colors.white : const Color(0xFF2D3142),
                letterSpacing: 2.0
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${texts.version}",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 3. KARTU DESKRIPSI (Menggunakan teks dari Localizations)
            _buildInfoCard(
              title: texts.aboutDescTitle, // [UPDATED]
              content: texts.aboutDescContent, // [UPDATED]
              icon: Icons.info_outline_rounded,
              isDarkMode: isDarkMode,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 16),

            // 4. KARTU DEVELOPER (Menggunakan teks dari Localizations)
            _buildInfoCard(
              title: texts.devTitle, // [UPDATED]
              content: texts.devContent, // [UPDATED]
              icon: Icons.code_rounded,
              isDarkMode: isDarkMode,
              primaryColor: primaryColor,
            ),
            
            const SizedBox(height: 40),
            
            // COPYRIGHT
            Text(
              "© 2026 Planno App", 
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Kartu Info
  Widget _buildInfoCard({
    required String title, 
    required String content, 
    required IconData icon, 
    required bool isDarkMode, 
    required Color primaryColor
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold, 
                  color: primaryColor,
                  letterSpacing: 1.0
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15, 
              height: 1.5,
              color: isDarkMode ? Colors.grey.shade300 : const Color(0xFF4A4A4A)
            ),
          ),
        ],
      ),
    );
  }
}