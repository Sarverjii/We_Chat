import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_time.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  // Only one named parameter
  @override
  Widget build(BuildContext context) {
    return APIs.currentUser.uid == widget.message.fromID
        ? _greenConatiner()
        : _blueConatiner();
  }

  Widget _greenConatiner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * 0.03),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all,
                color: Colors.blue,
              ),
            SizedBox(width: mq.width * 0.01),
            Text(
              MyDateTime.formatMilliseconds(
                  context,
                  widget.message.read.isEmpty
                      ? widget.message.sent
                      : widget.message.read),
              style: const TextStyle(color: Colors.black45, fontSize: 13),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen, width: 1.5),
                color: const Color.fromARGB(255, 218, 255, 176),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _blueConatiner() {
    if (widget.message.read.isEmpty) APIs.updateReadStatus(widget.message);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue, width: 1.5),
                color: const Color.fromARGB(255, 221, 245, 255),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              MyDateTime.formatMilliseconds(
                context,
                widget.message.sent,
              ),
              style: const TextStyle(color: Colors.black45, fontSize: 13),
            )),
      ],
    );
  }
}
