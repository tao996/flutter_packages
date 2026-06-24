import 'package:flutter/material.dart';

/// 日期选择伪输入框。
class FakeDateInput extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final DateTime? initialDate;
  final Function(DateTime?) onDateSelected;

  const FakeDateInput({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<FakeDateInput> createState() => _FakeDateInputState();
}

class _FakeDateInputState extends State<FakeDateInput> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String get _formattedDate {
    if (_selectedDate == null) return widget.hintText ?? '选择日期';
    return '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onDateSelected(picked);
    }
  }

  void _clearDate() {
    setState(() => _selectedDate = null);
    widget.onDateSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
            if (_selectedDate != null)
              IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: _clearDate),
            IconButton(icon: const Icon(Icons.calendar_today, size: 20), onPressed: _selectDate),
            const SizedBox(width: 4),
          ]),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Text(_formattedDate, style: TextStyle(
          color: _selectedDate != null ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
        )),
      ),
    );
  }
}

/// 时间选择伪输入框。
class FakeTimeInput extends StatefulWidget {
  final DateTime? initTime;
  final String labelText;
  final Function(DateTime?) onTimeSelected;
  final String? hintText;

  const FakeTimeInput({
    super.key,
    this.initTime,
    required this.labelText,
    required this.onTimeSelected,
    this.hintText,
  });

  @override
  State<FakeTimeInput> createState() => _FakeTimeInputState();
}

class _FakeTimeInputState extends State<FakeTimeInput> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initTime;
  }

  String get _formattedTime {
    if (_selectedDateTime == null) return widget.hintText ?? '选择时间';
    final time = TimeOfDay.fromDateTime(_selectedDateTime!);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openTimeDialog() async {
    final initial = _selectedDateTime != null ? TimeOfDay.fromDateTime(_selectedDateTime!) : TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      final now = DateTime.now();
      final newDateTime = DateTime(
        _selectedDateTime?.year ?? now.year,
        _selectedDateTime?.month ?? now.month,
        _selectedDateTime?.day ?? now.day,
        picked.hour, picked.minute,
      );
      setState(() => _selectedDateTime = newDateTime);
      widget.onTimeSelected(newDateTime);
    }
  }

  void _clearTime() {
    setState(() => _selectedDateTime = null);
    widget.onTimeSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openTimeDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText, hintText: widget.hintText,
          suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
            if (_selectedDateTime != null)
              IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: _clearTime),
            IconButton(icon: const Icon(Icons.access_time, size: 20), onPressed: _openTimeDialog),
            const SizedBox(width: 4),
          ]),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Text(_formattedTime, style: TextStyle(
          color: _selectedDateTime != null ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
        )),
      ),
    );
  }
}
