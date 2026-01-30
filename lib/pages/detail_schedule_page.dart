import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/api_service.dart';
import 'edit_schedule_page.dart';
import '../l10n/app_localizations.dart';

class DetailSchedulePage extends StatefulWidget {
  final Schedule schedule;
  final Color? backgroundColor;

  const DetailSchedulePage({
    super.key,
    required this.schedule,
    this.backgroundColor,
  });

  @override
  State<DetailSchedulePage> createState() => _DetailSchedulePageState();
}

class _DetailSchedulePageState extends State<DetailSchedulePage> {
  final ApiService api = ApiService();
  bool _isLoading = false;

  // --- Logic Methods ---

  void _onEdit() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditSchedulePage(schedule: widget.schedule),
      ),
    );

    if (result == true) {
      if (mounted) Navigator.pop(context, true);
    }
  }

  void _onDelete() async {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          texts.deleteTitle,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Text(
          texts.deleteConfirm,
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(texts.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(texts.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await api.deleteSchedule(widget.schedule.id);
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(texts.deleteSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${texts.deleteFail}: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  /// Helper Format Waktu: Menangani titik (.) dan titik dua (:)
  String _formatDisplayTime(String rawTime, String locale) {
    try {
      // 1. Normalisasi: Ubah titik menjadi titik dua (untuk menangani "20.00")
      String normalizedTime = rawTime.replaceAll('.', ':').trim();

      TimeOfDay time;

      if (normalizedTime.toUpperCase().contains("AM") ||
          normalizedTime.toUpperCase().contains("PM")) {
        // Format "07:00 AM"
        final parts = normalizedTime.split(" ");
        final timeParts = parts[0].split(":");
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);
        String period = parts[1].toUpperCase();

        if (period == "PM" && hour != 12) hour += 12;
        if (period == "AM" && hour == 12) hour = 0;
        time = TimeOfDay(hour: hour, minute: minute);
      } else {
        // Format "20:00" atau "20.00" (setelah dinormalisasi)
        final parts = normalizedTime.split(":");
        time = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      // Formatting Output sesuai Locale
      if (locale == 'id') {
        // Indo: 24 Jam
        final String h = time.hour.toString().padLeft(2, '0');
        final String m = time.minute.toString().padLeft(2, '0');
        return "$h:$m";
      } else {
        // Inggris: 12 Jam + AM/PM
        final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
        final int h = time.hourOfPeriod;
        final String m = time.minute.toString().padLeft(2, '0');
        return "$h:$m $period";
      }
    } catch (e) {
      return rawTime; // Fallback jika format benar-benar tidak dikenali
    }
  }

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Ambil locale saat ini
    final String currentLocale = Localizations.localeOf(context).languageCode;

    final Color primaryColor = const Color(0xFFd99de9);
    final Color headerColor =
        widget.backgroundColor ??
        (isDarkMode ? const Color(0xFF2A1A3A) : const Color(0xFFF3E5F5));

    // Format waktu sebelum ditampilkan
    String displayTime = _formatDisplayTime(
      widget.schedule.time,
      currentLocale,
    );

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          texts.detailTitle,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            color: primaryColor,
            onPressed: _isLoading ? null : _onEdit,
            tooltip: texts.editPageTitle,
          ),
          IconButton(
            icon:
                _isLoading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2,
                      ),
                    )
                    : const Icon(Icons.delete_rounded, color: Colors.redAccent),
            onPressed: _isLoading ? null : _onDelete,
            tooltip: texts.delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER UTAMA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.schedule.isCompleted)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            texts.statusDone,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Text(
                    widget.schedule.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color:
                          isDarkMode
                              ? Colors.white
                              : const Color(0xFF2D3142),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.schedule.category.isNotEmpty
                        ? widget.schedule.category.toUpperCase()
                        : "UMUM",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. INFO WAKTU
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    Icons.calendar_month_rounded,
                    texts.dateLabel,
                    widget.schedule.date,
                    isDarkMode,
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    Icons.access_time_filled_rounded,
                    texts.timeLabel,
                    displayTime,
                    isDarkMode,
                    primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. DESKRIPSI
            Text(
              texts.descTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDarkMode)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                ],
                border:
                    isDarkMode ? Border.all(color: Colors.grey.shade800) : null,
              ),
              child: Text(
                widget.schedule.description.isEmpty
                    ? "-"
                    : widget.schedule.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF4A4A4A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
        border: isDarkMode ? Border.all(color: Colors.grey.shade800) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }
}