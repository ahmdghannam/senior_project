import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/Chat/ChatData.dart';
import 'package:flutter_course_project/view/ChatPage.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double _preferredHeight = 110;
  final bool isTyping;

  ChatAppBar({
    required this.isTyping,
    super.key,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(ChatAppBar._preferredHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 204, 204, 204),
                width: 0.5,
              ),
            ),
          ),
          height: ChatAppBar._preferredHeight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 58,
              left: 12,
              right: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.person,
                  size: 36,
                  color: Theme.of(context).primaryColor,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your AI assistant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Visibility(
                          visible: widget.isTyping,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CupertinoActivityIndicator(
                              color: Theme.of(context).primaryColor,
                              radius: 7,
                            ),
                          ),
                        ),
                        Text(
                          widget.isTyping ? 'typing' : 'online',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showCancelDialog(context),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext pageContext) =>
      showCupertinoModalPopup<CupertinoActionSheet>(
        context: pageContext,
        builder: (context) => CupertinoActionSheet(
          message: const Text(
            'Are you want to clear history?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => clearMessagesAndPopDialog(context, pageContext),
              child: const Text(
                'Clear',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: CupertinoColors.systemRed,
                ),
              ),
            )
          ],
        ),
      );

  void clearMessagesAndPopDialog(
    BuildContext context,
    BuildContext pageContext,
  ) {
    ChatData.dummyChat = [];

    Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ChatPage()));
  }
}
