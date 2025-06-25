import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_datetime_picker/awesome_datetime_picker.dart';

class TimePickers extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final ValueChanged<DateTime> onStartTimeChanged;
  final ValueChanged<DateTime> onEndTimeChanged;

  final DateFormat hourFormat = DateFormat('HH:mm');

  TimePickers({
    Key? key,
    this.startTime,
    this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  }) : super(key: key);

  Future<void> _pickTime(BuildContext context, DateTime? currentTime, ValueChanged<DateTime> onChanged) async {
    AwesomeTime? pickedTime = AwesomeTime(
      hour: currentTime?.hour ?? TimeOfDay.now().hour,
      minute: currentTime?.minute ?? TimeOfDay.now().minute,
    );

    final result = await showDialog<AwesomeTime>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: 360,
          height: 200,
          child: AwesomeTimePicker(
            initialTime: pickedTime!,
            timeFormat: AwesomeTimeFormat.Hm,
            onChanged: (time) {
              pickedTime = time;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, pickedTime), child: const Text('Confirmar')),
        ],
      ),
    );

    if (result != null) {
      final now = DateTime.now();
      onChanged(DateTime(now.year, now.month, now.day, result.hour, result.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _pickTime(context, startTime, onStartTimeChanged),
          child: Text(startTime == null ? 'Selecionar hora de partida' : 'Partida: ${hourFormat.format(startTime!)}'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _pickTime(context, endTime, onEndTimeChanged),
          child: Text(endTime == null ? 'Selecionar hora de chegada' : 'Chegada: ${hourFormat.format(endTime!)}'),
        ),
      ],
    );
  }
}
