import 'package:flutter/material.dart';

class LevelList extends StatefulWidget {
  final Function(String?) onChanged; // Callback function

  const LevelList({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<LevelList> createState() => _LevelListState();
}

class _LevelListState extends State<LevelList> {
  String? chosenLevel;
  List levelList = ['level 1', 'level 2', 'level 3', 'level 4']; // list

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60,
          padding: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Color(0xffE7E0EC),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButton(
            style: TextStyle(
              color: Color(0xff49454F),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            hint: Text('Select level'),
            dropdownColor: Color(0xffE7E0EC),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: SizedBox(),
            value: chosenLevel,
            onChanged: (newValue) {
              setState(() {
                chosenLevel = newValue;
                widget.onChanged(chosenLevel); // Notify parent widget
              });
            },
            items: levelList.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
