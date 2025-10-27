import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP', null);
  runApp(const MyDiaryApp());
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDiary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      locale: const Locale('ja', 'JP'), // 日本語表記
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 仮データ（日付と顔文字）
  final Map<DateTime, String> _moodData = {
    DateTime.utc(2025, 2, 1): '🙂',
    DateTime.utc(2025, 2, 2): '😄',
    DateTime.utc(2025, 2, 3): '😴',
  };

  bool _isFuture(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(day.year, day.month, day.day);
    return target.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text(
          'マインドカレンダー',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 500,
          child: TableCalendar(
            locale: 'ja_JP',
            rowHeight: 65,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, // ← ★ これで「2 weeks」などを非表示
              titleCentered: true, // ← タイトル（年月）を中央寄せ
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            enabledDayPredicate: (day) => !_isFuture(day),
            onDaySelected: (selectedDay, focusedDay) {
              if (_isFuture(selectedDay)) return; // 未来日は無効
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day, isToday: false),
              todayBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day, isToday: true),
              selectedBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day, isToday: false, isSelected: true),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade100,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('EntryPage へ移動予定')),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  /// 📅 セルデザイン共通化（右下ボーダー + 日付左上 + 絵文字中央）
  Widget _buildDayCell(BuildContext context, DateTime day,
      {bool isToday = false, bool isSelected = false}) {
    String? mood = _moodData[DateTime.utc(day.year, day.month, day.day)];

    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: isToday
            ? Colors.yellow.shade100
            : isSelected
            ? Colors.green.shade50
            : Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border(
          right: BorderSide(color: Colors.grey.shade400, width: 0.8),
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.8),
        ),
      ),
      child: Stack(
        children: [
          // 📆 日付（左上）
          Positioned(
            top: 4,
            left: 6,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 12,
                color: _isFuture(day) ? Colors.grey : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          // 😄 絵文字（中央）
          if (mood != null)
            Center(
              child: Text(
                mood,
                style: const TextStyle(fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}
