import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../services/api_service.dart';
import '../models/schedule.dart';
import '../l10n/app_localizations.dart'; 
import 'add_schedule_page.dart';
import 'detail_schedule_page.dart';
import 'calendar_page.dart';
import 'list_page.dart'; 
import 'profile_page.dart';
import 'settings_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  // [BARU] Variable untuk memaksa HomeContent refresh otomatis
  int _refreshId = 0;

  // Palette 4 Warna
  final List<Color> pastelColors = [
    const Color(0xFFE3F2FD), // Biru
    const Color(0xFFFFF3E0), // Kuning
    const Color(0xFFF3E5F5), // Pink
    const Color(0xFFE8F5E9), // Hijau
  ];
  
  final List<Color> darkPastelColors = [
    const Color(0xFF1A2A3A), 
    const Color(0xFF3A2A1A), 
    const Color(0xFF3A1A1A), 
    const Color(0xFF1A3A2A), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCustomHeader(bool isDarkMode, Color primaryColor, AppLocalizations texts, String name, String initial) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), 
        child: Row(
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial, 
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.hello, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey : Colors.grey.shade600)),
                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87)),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade200, width: 1.5),
                  boxShadow: [
                    if (!isDarkMode)
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
                  ]
                ),
                child: Icon(
                  Icons.person_rounded, 
                  color: isDarkMode ? Colors.white : Colors.black87,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(bool isDarkMode, AppLocalizations texts, Color primaryColor, String name, String initial) {
    switch (_selectedIndex) {
      case 0: 
        return Column(
          children: [
            _buildCustomHeader(isDarkMode, primaryColor, texts, name, initial),
            Expanded(
              // [UPDATE] Tambahkan Key di sini agar widget me-reset diri saat ID berubah
              child: HomeContent(
                key: ValueKey(_refreshId), 
                pastelColors: pastelColors,
                darkPastelColors: darkPastelColors,
                primaryColor: primaryColor,
                isDarkMode: isDarkMode,
                onRefresh: () => setState((){ _refreshId++; }), 
              ),
            ),
          ],
        );
      case 1: return const CalendarPage(); 
      case 2: return const ListPage(); 
      case 3: return const SettingsPage();
      default: return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFd99de9); 

    final User? user = FirebaseAuth.instance.currentUser;
    final String name = user?.displayName ?? "Pengguna";
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: null,
      body: _buildBodyContent(isDarkMode, texts, primaryColor, name, initial),
      
      floatingActionButton: _selectedIndex == 0 
        ? TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: FloatingActionButton(
              onPressed: () async {
                bool? res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSchedulePage()));
                // [UPDATE LOGIKA] Jika berhasil (res == true), ubah _refreshId agar HomeContent reload otomatis
                if (res == true) {
                  setState(() {
                    _refreshId++;
                  });
                }
              },
              backgroundColor: primaryColor,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
            ),
          ) 
        : null,
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
        ),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home_rounded, "Home", primaryColor, isDarkMode),
              _buildNavItem(1, Icons.calendar_month_rounded, "Agenda", primaryColor, isDarkMode),
              _buildNavItem(2, Icons.checklist_rounded, "List", primaryColor, isDarkMode),
              _buildNavItem(3, Icons.settings_rounded, "Setting", primaryColor, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color primary, bool isDarkMode) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : (isDarkMode ? Colors.grey : Colors.grey.shade400), size: 24),
            if (isSelected) 
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              )
          ],
        ),
      ),
    );
  }
}

// --- HOME CONTENT ---
class HomeContent extends StatefulWidget {
  final List<Color> pastelColors;
  final List<Color> darkPastelColors;
  final Color primaryColor;
  final bool isDarkMode;
  final VoidCallback onRefresh;

  const HomeContent({super.key, required this.pastelColors, required this.darkPastelColors, required this.primaryColor, required this.isDarkMode, required this.onRefresh});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ApiService api = ApiService();
  Set<String> _collapsedCategories = {};
  List<Schedule> _schedules = [];
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchData(); 
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        api.getSchedules(),
        Future.delayed(const Duration(seconds: 1)),
      ]);

      if (mounted) {
        setState(() {
          _schedules = results[0] as List<Schedule>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTask(Schedule s) async {
    bool newStatus = !s.isCompleted;
    setState(() {
      int index = _schedules.indexWhere((item) => item.id == s.id);
      if (index != -1) {
        _schedules[index] = Schedule(
          id: s.id, userId: s.userId, title: s.title, date: s.date, time: s.time, 
          description: s.description, category: s.category, isCompleted: newStatus
        );
      }
    });

    try {
      await api.toggleCompletion(s.id, s.isCompleted);
    } catch (e) {
      _fetchData(); 
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_collapsedCategories.contains(category)) {
        _collapsedCategories.remove(category);
      } else {
        _collapsedCategories.add(category);
      }
    });
  }

  Future<void> _deleteCategoryGroup(String category, List<Schedule> tasks) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Hapus Folder '$category'?"),
        content: Text("Semua jadwal (${tasks.length} item) akan dihapus.", style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _schedules.removeWhere((s) => (s.category.isEmpty ? "Umum" : s.category.toUpperCase()) == category);
      });
      try {
        for (var task in tasks) {
          await api.deleteSchedule(task.id);
        }
      } catch (e) {
        _fetchData();
      }
    }
  }

  Map<String, List<Schedule>> _groupSchedules(List<Schedule> list, String general) {
    Map<String, List<Schedule>> grouped = {};
    for (var s in list) {
      String cat = s.category.isEmpty ? general : s.category.toUpperCase();
      if (grouped[cat] == null) grouped[cat] = [];
      grouped[cat]!.add(s);
    }
    return grouped;
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
        final String h = time.hour.toString().padLeft(2, '0');
        final String m = time.minute.toString().padLeft(2, '0');
        return "$h:$m";
      } else {
        final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
        final int h = time.hourOfPeriod;
        final String m = time.minute.toString().padLeft(2, '0');
        return "$h:$m $period";
      }
    } catch (e) {
      return rawTime; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final String currentLocale = Localizations.localeOf(context).languageCode;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: widget.primaryColor),
      );
    }

    if (_schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add_rounded, size: 60, color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(texts.noSchedule, style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final grouped = _groupSchedules(_schedules, texts.general);
    final categories = grouped.keys.toList();

    return RefreshIndicator(
      onRefresh: () async {
        await _fetchData();
        widget.onRefresh();
      },
      color: widget.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String cat = categories[index];
          List<Schedule> tasks = grouped[cat]!;
          bool isCollapsed = _collapsedCategories.contains(cat);

          double topPadding = index == 0 ? 0 : 14;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: topPadding, bottom: 12), 
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleCategory(cat),
                      onLongPress: () => _deleteCategoryGroup(cat, tasks),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: Row(
                          children: [
                            AnimatedRotation(
                              turns: isCollapsed ? -0.25 : 0, 
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: widget.isDarkMode ? Colors.grey : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              cat, 
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: widget.isDarkMode ? Colors.grey : Colors.grey.shade600)
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                              child: Text("${tasks.length}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        bool? res = await Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => AddSchedulePage(initialCategory: cat))
                        );
                        if (res == true) _fetchData(); 
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add_circle_outline_rounded, color: widget.primaryColor, size: 22),
                      ),
                    )
                  ],
                ),
              ),
              
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: isCollapsed 
                  ? const SizedBox.shrink() 
                  : Column(
                      children: tasks.asMap().entries.map((entry) {
                        int idx = entry.key; 
                        Schedule s = entry.value;
                        
                        Color cardColor = widget.isDarkMode 
                            ? widget.darkPastelColors[idx % 4] 
                            : widget.pastelColors[idx % 4];
                        
                        Color iconColor = widget.isDarkMode ? Colors.white10 : Colors.white60;
                        return _buildCard(s, cardColor, iconColor, currentLocale);
                      }).toList(),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(Schedule s, Color bg, Color iconBg, String locale) {
    bool isDone = s.isCompleted;
    String displayTime = _formatDisplayTime(s.time, locale);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)), 
          child: Opacity(
            opacity: value, 
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), 
        decoration: BoxDecoration(
          color: isDone ? (widget.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100) : bg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              bool? res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailSchedulePage(
                    schedule: s,
                    backgroundColor: bg, 
                  ),
                ),
              );
              if (res == true) _fetchData();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(16)),
                    child: Icon(isDone ? Icons.check_circle : Icons.access_time_filled_rounded, color: isDone ? Colors.grey : (widget.isDarkMode ? Colors.white70 : Colors.black54)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: isDone ? TextDecoration.lineThrough : null, color: isDone ? Colors.grey : (widget.isDarkMode ? Colors.white : const Color(0xFF2D3142)))),
                        Text("${s.date} • $displayTime", style: TextStyle(fontSize: 13, color: widget.isDarkMode ? Colors.white38 : Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleTask(s),
                    child: Icon(isDone ? Icons.check_box : Icons.check_box_outline_blank, color: isDone ? Colors.green : (widget.isDarkMode ? Colors.white30 : Colors.grey.shade400)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}