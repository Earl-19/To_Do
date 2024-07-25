import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeline extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  CustomDateTimeline({required this.initialDate, required this.onDateSelected});

  @override
  _CustomDateTimelineState createState() => _CustomDateTimelineState();
}

class _CustomDateTimelineState extends State<CustomDateTimeline> {
  late DateTime _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7, // Display 7 days
        itemBuilder: (context, index) {
          final date = widget.initialDate.add(Duration(days: index));
          final isSelected = _selectedDate == date;
          return GestureDetector(
            onTap: () => _selectDate(date),
            child: Container(
              width: 80,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
