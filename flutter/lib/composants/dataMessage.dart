import 'package:flutter/material.dart';

class DataMessage extends StatefulWidget {
  const DataMessage({super.key, required this.message, required this.rUid , required this.currentUid });
  final String message;
  final String rUid;
  final String currentUid;

  @override
  State<DataMessage> createState() => _MessageState();
}

class _MessageState extends State<DataMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
       mainAxisAlignment:widget.currentUid == widget.rUid? MainAxisAlignment.end: MainAxisAlignment.start,
      children: [

        Container(
          margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
          padding:EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.currentUid == widget.rUid? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Text(widget.message),
        )
      ],
    );
  }
}