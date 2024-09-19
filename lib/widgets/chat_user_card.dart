import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/chat_screen.dart';

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
      child: SizedBox(
        height: mq.height * 0.1, // Adjust the height of the card
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: mq.width * 0.04,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.05),
                child: CachedNetworkImage(
                  height: mq.height * 0.075, // Adjust height of the image
                  width: mq.height *
                      0.075, // Adjust width to match height if needed
                  fit: BoxFit.cover,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(width: mq.width * 0.02), // Space between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                      widget.user.about,
                      maxLines: 1, // Limit the number of lines
                      overflow: TextOverflow.ellipsis, // Add ellipsis if needed
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: mq.width *
                      0.02), // Space between text and trailing widget
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: mq.width * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
