import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
            leading: CircleAvatar(
              radius: mq.height * 0.0275, // Set a radius for a circular avatar
              // Use CachedNetworkImageProvider for efficient loading
              backgroundImage: CachedNetworkImageProvider(widget.user.image),
              child: null,
            ),

            // leading: CircleAvatar(
            //   child: Image.network(widget.user.image),
            // ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )
            // trailing: const Text(
            //   "12:00 PM",
            //   style: TextStyle(color: Colors.black45, fontSize: 14),
            // ),
            ),
      ),
    );
  }
}
