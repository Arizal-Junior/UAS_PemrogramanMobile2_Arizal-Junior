import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart'; 

class AddSchedulePage extends StatefulWidget {
  final String? initialCategory; 

  const AddSchedulePage({super.key, this.initialCategory});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController dateCtrl;
  late TextEditingController timeCtrl;
  late TextEditingController categoryCtrl;

  final ApiService api = ApiService();
  bool _isLoading = false;
  bool _isCategoryLocked = false;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController();
    descCtrl = TextEditingController();
    dateCtrl = TextEditingController();
    timeCtrl = TextEditingController();
    
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      categoryCtrl = TextEditingController(text: widget.initialCategory);
      _isCategoryLocked = true; 
    } else {
      categoryCtrl = TextEditingController();
      _isCategoryLocked = false; 
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode 
              ? const ColorScheme.dark(primary: Color(0xFFd99de9), onPrimary: Colors.white, surface: Color(0xFF1E1E1E))
              : const ColorScheme.light(primary: Color(0xFFd99de9)),
            dialogBackgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Deteksi Format Waktu Berdasarkan Bahasa
  Future<void> _pickTime() async {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode 
              ? const ColorScheme.dark(primary: Color(0xFFd99de9), onPrimary: Colors.white, surface: Color(0xFF1E1E1E))
              : const ColorScheme.light(primary: Color(0xFFd99de9)),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            )
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Cek Bahasa Aplikasi Saat Ini
        final String languageCode = Localizations.localeOf(context).languageCode;

        if (languageCode == 'id') {
          // --- FORMAT 24 JAM (INDONESIA) ---
          final String hour = picked.hour.toString().padLeft(2, '0');
          final String minute = picked.minute.toString().padLeft(2, '0');
          timeCtrl.text = "$hour:$minute"; 
        } else {
          // --- FORMAT 12 JAM + AM/PM (INGGRIS DLL) ---
          final int hour = picked.hourOfPeriod;
          final String minute = picked.minute.toString().padLeft(2, '0');
          final String period = picked.period == DayPeriod.am ? 'AM' : 'PM';
          timeCtrl.text = "$hour:$minute $period"; 
        }
      });
    }
  }

  void _saveSchedule() async {
    final texts = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Gunakan 'Umum' atau 'General' sesuai bahasa jika kosong
        String defaultCat = texts.generalCategory; 
        String finalCategory = categoryCtrl.text.trim().isEmpty ? defaultCat : categoryCtrl.text.trim();

        await api.addSchedule({
          "title": titleCtrl.text,
          "date": dateCtrl.text,
          "time": timeCtrl.text,
          "description": descCtrl.text,
          "category": finalCategory,
          "isCompleted": false,
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(texts.successSave), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          // [LANG] Pesan Error disesuaikan
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${texts.failSave} $e'), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFFd99de9);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      
      appBar: AppBar(
        title: Text(
          texts.addSchedule, 
          style: TextStyle(fontWeight: FontWeight.w800, color: isDarkMode ? Colors.white : Colors.black87)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // FORM CONTAINER
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (!isDarkMode)
                    BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. JUDUL
                    _buildLabel(texts.titleLabel, isDarkMode),
                    _buildTextField(
                      controller: titleCtrl,
                      hint: texts.titleHint, // [LANG]
                      icon: Icons.title_rounded,
                      isDarkMode: isDarkMode,
                      validator: (val) => val!.isEmpty ? texts.titleError : null,
                    ),
                    const SizedBox(height: 20),

                    // 2. KATEGORI
                    _buildLabel(texts.groupLabel, isDarkMode),
                    _buildTextField(
                      controller: categoryCtrl,
                      hint: texts.groupHint, // [LANG]
                      icon: _isCategoryLocked ? Icons.lock_outline_rounded : Icons.category_rounded,
                      isDarkMode: isDarkMode,
                      isReadOnly: _isCategoryLocked,
                      customFillColor: _isCategoryLocked 
                          ? (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100) 
                          : null,
                    ),
                    if (_isCategoryLocked)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          texts.categoryLockedInfo,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                        ),
                      ),
                    const SizedBox(height: 20),
                    
                    // 3. TANGGAL & WAKTU (Row)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(texts.dateLabel, isDarkMode),
                              _buildTextField(
                                controller: dateCtrl,
                                hint: texts.dateHint, // [LANG]
                                icon: Icons.calendar_today_rounded,
                                isDarkMode: isDarkMode,
                                isReadOnly: true,
                                onTap: _pickDate,
                                validator: (val) => val!.isEmpty ? texts.requiredError : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(texts.timeLabel, isDarkMode),
                              _buildTextField(
                                controller: timeCtrl,
                                hint: texts.timeHint, // [LANG]
                                icon: Icons.access_time_rounded,
                                isDarkMode: isDarkMode,
                                isReadOnly: true,
                                onTap: _pickTime,
                                validator: (val) => val!.isEmpty ? texts.requiredError : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 4. DESKRIPSI
                    _buildLabel(texts.descLabel, isDarkMode),
                    _buildTextField(
                      controller: descCtrl,
                      hint: texts.descHint, // [LANG]
                      icon: Icons.notes_rounded,
                      isDarkMode: isDarkMode,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    
                    // TOMBOL SIMPAN
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded),
                                const SizedBox(width: 8),
                                Text(texts.saveSchedule, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  
  Widget _buildLabel(String label, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.w700, 
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDarkMode, 
    bool isReadOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    String? Function(String?)? validator,
    Color? customFillColor, 
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.grey.shade500 : const Color(0xFFd99de9).withOpacity(0.6), size: 22),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, 
        ),
        
        filled: true,
        fillColor: customFillColor ?? (isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF5F7FA)), 
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}