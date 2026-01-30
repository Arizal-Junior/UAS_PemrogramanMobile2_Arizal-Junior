import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../models/todo.dart'; 
import '../services/todo_service.dart'; 
import '../l10n/app_localizations.dart'; 

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TodoService _todoService = TodoService();
  
  // State Data Lokal
  List<TodoCategory> categories = [];
  bool _isFirstLoad = true; 

  final TextEditingController _categoryCtrl = TextEditingController();
  final Map<String, TextEditingController> _itemControllers = {};

  // Palette Warna
  final List<Color> pastelColors = [
    const Color(0xFFE3F2FD), const Color(0xFFFFF3E0), 
    const Color(0xFFF3E5F5), const Color(0xFFE8F5E9),
  ];
  final List<Color> darkPastelColors = [
    const Color(0xFF1A2A3A), const Color(0xFF3A2A1A), 
    const Color(0xFF3A1A1A), const Color(0xFF1A3A2A),
  ];
  final Color primaryColor = const Color(0xFFd99de9);
  final Color fabColor = const Color(0xFFd99de9); 

  @override
  void initState() {
    super.initState();
    _fetchData(); 
  }

  // Fetch Data Diam-diam
  Future<void> _fetchData() async {
    try {
      final data = await _todoService.getCategories();
      if (mounted) {
        setState(() {
          categories = data;
          _isFirstLoad = false; 
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isFirstLoad = false);
    }
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    for (var ctrl in _itemControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  // --- LOGIKA DATABASE (OPTIMISTIC UI) ---

  Future<void> _addCategory() async {
    if (_categoryCtrl.text.trim().isNotEmpty) {
      String title = _categoryCtrl.text;
      Navigator.pop(context); 
      
      final user = FirebaseAuth.instance.currentUser;
      final String uid = user?.uid ?? '';

      // 1. Update UI Langsung
      setState(() {
        categories.add(TodoCategory(
          id: "temp-${DateTime.now().millisecondsSinceEpoch}", 
          userId: uid, 
          title: title, 
          items: []
        ));
      });

      // 2. Kirim ke Server
      try {
        await _todoService.addCategory(title);
        _categoryCtrl.clear();
        _fetchData(); 
      } catch (e) {
        _fetchData(); 
      }
    }
  }

  Future<void> _deleteCategory(TodoCategory cat, AppLocalizations texts) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(texts.deleteListTitle), 
        content: Text(texts.deleteListContent(cat.title)), 
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text(texts.cancelButton, style: const TextStyle(color: Colors.grey)) 
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              
              setState(() {
                categories.removeWhere((c) => c.id == cat.id);
              });

              try {
                await _todoService.deleteCategory(cat.id);
              } catch (e) {
                _fetchData(); 
              }
            },
            child: Text(texts.deleteButton), 
          ),
        ],
      ),
    );
  }

  Future<void> _addItem(TodoCategory cat, String value) async {
    if (value.trim().isNotEmpty) {
      setState(() {
        cat.items.add(TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(), 
          title: value,
        ));
      });
      _itemControllers[cat.id]?.clear();
      await _todoService.updateCategory(cat);
    }
  }

  Future<void> _deleteItem(TodoCategory cat, TodoItem item) async {
    setState(() {
      cat.items.remove(item);
    });
    await _todoService.updateCategory(cat);
  }

  Future<void> _toggleItem(TodoCategory cat, TodoItem item) async {
    setState(() {
      item.isCompleted = !item.isCompleted;
    });
    await _todoService.updateCategory(cat);
  }

  void _toggleExpand(TodoCategory cat) {
    setState(() {
      cat.isExpanded = !cat.isExpanded;
    });
  }

  // --- UI ---

  void _showAddCategoryModal(bool isDarkMode, AppLocalizations texts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.createListTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87)), 
                const SizedBox(height: 16),
                TextField(
                  controller: _categoryCtrl,
                  autofocus: true,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: texts.createListHint, 
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _addCategory(),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _addCategory,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(texts.createButton), 
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final texts = AppLocalizations.of(context)!; 
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: null, 

      // [ANIMASI TAMBAHAN] Efek Scale Elastic pada FAB
      floatingActionButton: TweenAnimationBuilder<double>(
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
          onPressed: () => _showAddCategoryModal(isDarkMode, texts), 
          backgroundColor: fabColor,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),

      body: SafeArea(
        bottom: false, 
        child: _isFirstLoad 
            ? const SizedBox.shrink() 
            : categories.isEmpty 
                ? _buildEmptyState(isDarkMode, texts) 
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
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
                        child: _buildCategoryCard(categories[index], index, isDarkMode, texts),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode, AppLocalizations texts) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add_check_rounded, size: 80, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(texts.emptyList, style: TextStyle(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400)), 
        ],
      ),
    );
  }

  Widget _buildCategoryCard(TodoCategory cat, int index, bool isDarkMode, AppLocalizations texts) {
    int completedCount = cat.items.where((i) => i.isCompleted).length;
    int totalCount = cat.items.length;

    if (!_itemControllers.containsKey(cat.id)) {
      _itemControllers[cat.id] = TextEditingController();
    }

    Color baseColor = isDarkMode ? darkPastelColors[index % 4] : pastelColors[index % 4];
    Color textColor = isDarkMode ? Colors.white : const Color(0xFF2D3142);
    Color secondaryTextColor = isDarkMode ? Colors.white60 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              onTap: () => _toggleExpand(cat),
              onLongPress: () => _deleteCategory(cat, texts), 
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        cat.isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded,
                        key: ValueKey(cat.isExpanded),
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(cat.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                      child: Text("$completedCount / $totalCount", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: cat.isExpanded ? 0.5 : 0.0, 
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.keyboard_arrow_down_rounded, color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: cat.isExpanded 
              ? Column(
                  children: [
                    Divider(height: 1, indent: 20, endIndent: 20, color: textColor.withOpacity(0.1)),
                    if (cat.items.isEmpty)
                      Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(texts.emptySubTask, style: TextStyle(color: secondaryTextColor, fontSize: 13, fontStyle: FontStyle.italic)))) 
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cat.items.length,
                        itemBuilder: (context, idx) {
                          final item = cat.items[idx];
                          return Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _deleteItem(cat, item),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red.withOpacity(0.2),
                              child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            ),
                            child: CheckboxListTile(
                              value: item.isCompleted,
                              activeColor: textColor,
                              checkColor: baseColor,
                              side: BorderSide(color: secondaryTextColor, width: 1.5),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(item.title, style: TextStyle(fontSize: 15, decoration: item.isCompleted ? TextDecoration.lineThrough : null, color: item.isCompleted ? secondaryTextColor : textColor)),
                              onChanged: (val) => _toggleItem(cat, item),
                            ),
                          );
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: TextField(
                        controller: _itemControllers[cat.id],
                        style: TextStyle(fontSize: 14, color: textColor),
                        cursorColor: textColor,
                        decoration: InputDecoration(
                          hintText: texts.addSubTaskHint, 
                          hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.6), fontSize: 13),
                          prefixIcon: Icon(Icons.add_rounded, size: 20, color: secondaryTextColor),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          isDense: true,
                        ),
                        onSubmitted: (val) => _addItem(cat, val),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}