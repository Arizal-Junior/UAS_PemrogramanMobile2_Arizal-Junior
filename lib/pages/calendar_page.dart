import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; 
import '../models/schedule.dart';
import '../services/api_service.dart';
import 'detail_schedule_page.dart';
import '../l10n/app_localizations.dart'; 

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ApiService api = ApiService();
  
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Schedule> _allSchedules = [];
  List<Schedule> _selectedDaySchedules = [];
  bool _isLoading = true;

  final List<Color> pastelColors = [const Color(0xFFE3F2FD), const Color(0xFFFFF3E0), const Color(0xFFF3E5F5), const Color(0xFFE8F5E9)];
  final List<Color> darkPastelColors = [const Color(0xFF1A2A3A), const Color(0xFF3A2A1A), const Color(0xFF3A1A1A), const Color(0xFF1A3A2A)];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchSchedules();
  }

  // [LOGIKA LOADING 1 DETIK]
  void _fetchSchedules() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        api.getSchedules(),
        Future.delayed(const Duration(seconds: 1)),
      ]);

      if (mounted) {
        setState(() {
          _allSchedules = results[0] as List<Schedule>;
          if (_selectedDay != null) {
            _selectedDaySchedules = _getSchedulesForDay(_selectedDay!);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Schedule> _getSchedulesForDay(DateTime day) {
    String dateString = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    return _allSchedules.where((s) => s.date == dateString).toList();
  }

  int _getScheduleColorIndex(Schedule s) {
    List<Schedule> categorySchedules = _allSchedules.where((item) => (item.category.isEmpty ? "Umum" : item.category.toUpperCase()) == (s.category.isEmpty ? "Umum" : s.category.toUpperCase())).toList();
    int index = categorySchedules.indexWhere((item) => item.id == s.id);
    return index != -1 ? index : 0;
  }

  String _formatDisplayTime(String rawTime, String locale) {
    try {
      String normalizedTime = rawTime.replaceAll('.', ':').trim();
      TimeOfDay time;
      if (normalizedTime.toUpperCase().contains("AM") || normalizedTime.toUpperCase().contains("PM")) {
        final parts = normalizedTime.split(" ");
        final timeParts = parts[0].split(":");
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);
        if (parts[1].toUpperCase() == "PM" && hour != 12) hour += 12;
        if (parts[1].toUpperCase() == "AM" && hour == 12) hour = 0;
        time = TimeOfDay(hour: hour, minute: minute);
      } else {
        final parts = normalizedTime.split(":");
        time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
      if (locale == 'id') {
        return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      } else {
        return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}";
      }
    } catch (e) {
      return rawTime; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final String currentLocale = Localizations.localeOf(context).languageCode;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFd99de9);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(texts.calendarPageTitle, style: TextStyle(fontWeight: FontWeight.w800, color: isDarkMode ? Colors.white : Colors.black87)),
        centerTitle: true, 
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: TableCalendar(
              locale: currentLocale, 
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedDaySchedules = _getSchedulesForDay(selectedDay);
                  });
                }
              },
              onFormatChanged: (format) { if (_calendarFormat != format) setState(() => _calendarFormat = format); },
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false, titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDarkMode ? Colors.white : Colors.black87),
                leftChevronIcon: Icon(Icons.chevron_left_rounded, color: isDarkMode ? Colors.white : Colors.black54),
                rightChevronIcon: Icon(Icons.chevron_right_rounded, color: isDarkMode ? Colors.white : Colors.black54),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
                weekendTextStyle: TextStyle(color: isDarkMode ? Colors.redAccent.shade100 : Colors.redAccent),
                todayDecoration: BoxDecoration(color: primaryColor.withOpacity(0.2), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(12)),
                todayTextStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                selectedDecoration: BoxDecoration(color: primaryColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(12)),
                markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle), 
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400, fontSize: 12),
                weekendStyle: TextStyle(color: isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5), fontSize: 12),
              ),
              eventLoader: _getSchedulesForDay,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Text("${texts.scheduleList} (${_selectedDaySchedules.length})", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: isDarkMode ? Colors.white : const Color(0xFF2D3142))),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _selectedDaySchedules.isEmpty
                    ? Center(
                        key: ValueKey("empty-${_selectedDay.toString()}"),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_note_rounded, size: 60, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                            const SizedBox(height: 10),
                            Text(texts.emptyScheduleDay, style: TextStyle(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400)), 
                          ],
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey(_selectedDay), 
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                        itemCount: _selectedDaySchedules.length,
                        itemBuilder: (context, index) {
                          final s = _selectedDaySchedules[index];
                          int categoryIndex = _getScheduleColorIndex(s);
                          Color baseColor = isDarkMode ? darkPastelColors[categoryIndex % 4] : pastelColors[categoryIndex % 4];
                          Color finalBackgroundColor = s.isCompleted ? (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100) : baseColor;
                          Color badgeColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
                          String displayTime = _formatDisplayTime(s.time, currentLocale);

                          // --- LOGIKA KATEGORI KAPITAL (UPDATED) ---
                          String categoryDisplay = s.category.isNotEmpty ? s.category : "Umum";
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: finalBackgroundColor, borderRadius: BorderRadius.circular(20)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => DetailSchedulePage(schedule: s, backgroundColor: finalBackgroundColor))).then((_) => _fetchSchedules()); 
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // [FIX] Menggunakan toUpperCase() agar semua kapital
                                            Text(
                                              categoryDisplay.toUpperCase(), 
                                              style: TextStyle(
                                                fontSize: 12, 
                                                color: isDarkMode ? Colors.white54 : Colors.black45, 
                                                fontWeight: FontWeight.w800, // Sedikit ditebalkan agar lebih jelas
                                                letterSpacing: 1.0 // Tambahkan spasi antar huruf agar rapi
                                              )
                                            ),
                                            const SizedBox(height: 4),
                                            Text(s.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: s.isCompleted ? TextDecoration.lineThrough : null, color: s.isCompleted ? Colors.grey : (isDarkMode ? Colors.white : const Color(0xFF2D3142)))),
                                            if (s.isCompleted)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Row(children: [const Icon(Icons.check_circle, size: 14, color: Colors.green), const SizedBox(width: 4), Text(texts.statusDone, style: const TextStyle(fontSize: 12, color: Colors.green))]),
                                              )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
                                        child: Text(displayTime, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white70 : Colors.black54)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}