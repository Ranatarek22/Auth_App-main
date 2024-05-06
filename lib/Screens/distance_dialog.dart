import 'package:flutter/material.dart';

class DistanceDialog extends StatelessWidget {
  final String storeName;
  final double distance;

  const DistanceDialog({
    Key? key,
    required this.storeName,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Distance",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Distance from your location to $storeName:",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            ('${(distance / 1000).toStringAsFixed(2)} km'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
