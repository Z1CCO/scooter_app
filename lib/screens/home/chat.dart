// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooter_app/screens/adminchat.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scooter_app/user.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ChatScreen({required this.user, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _showAlertDialog(messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).ochirish),
          content: Text(translation(context).rostdanHamXabarniOchirmoqchimisiz),
          actions: <Widget>[
            TextButton(
              child: Text(
                translation(context).yoq,
                style: TextStyles.s17w500kanitblack,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                translation(context).ha,
                style: TextStyles.s17w500kanitred,
              ),
              onPressed: () => _deleteMessage(messageId),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(messageId)
          .delete();
    // ignore: empty_catches
    } catch (e) {
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('reports').add({
        'description': _messageController.text,
        'userId': currentUser()!.uid,
        'name': widget.user['name'],
        'email': widget.user['email'],
        'admin': widget.user['admin'],
        'timestamp': Timestamp.now(),
      });
      _messageController.clear();
    }
  }

  Widget _buildMessage(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final isMyMessage = data['userId'] == currentUser()!.uid;
    final backgroundColor =
        isMyMessage ? AppColors.deepBlue : Colors.grey.shade300;
    final textColor = isMyMessage ? Colors.white : Colors.black;
    final List<String?> imageUrls = [data['image1'], data['image2']];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.deepBlue,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: GestureDetector(
                    onLongPress: isMyMessage
                        ? () => _showAlertDialog(document.id)
                        : () {},
                    child: Text(
                      data['description'] ?? '',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                if (imageUrls[0] != null || imageUrls[1] != null)
                  Row(
                    mainAxisAlignment: isMyMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.end,
                    children: [
                      for (var i = 0; i < imageUrls.length; i++)
                        if (imageUrls[i] != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                        iconTheme: const IconThemeData(
                                            color: AppColors.white),
                                        backgroundColor: AppColors.black),
                                    body: PhotoViewGallery(
                                      pageOptions: [
                                        PhotoViewGalleryPageOptions(
                                          imageProvider:
                                              NetworkImage(imageUrls[i]!),
                                          heroAttributes:
                                              PhotoViewHeroAttributes(
                                            tag: 'image$i',
                                          ),
                                        ),
                                      ],
                                      backgroundDecoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrls[i]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.user['admin']
        ? Scaffold(
            backgroundColor: AppColors.grey,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: AppColors.white),
              backgroundColor: AppColors.deepBlue,
              title: Text(
                translation(context).yozishmalar,
                style: TextStyles.s25w500kanitwhite,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('reports')
                  .orderBy('timestamp', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child:
                        Text(translation(context).hozirchahechqandaymalumotyoq),
                  );
                }
                final reports = snapshot.data!.docs;

                // Unikal foydalanuvchilar ro'yxatini olish
                final uniqueUsers = <String, Map<String, dynamic>>{};
                for (var report in reports) {
                  final data = report.data() as Map<String, dynamic>;
                  final userId = data['userId'];
                  if (!uniqueUsers.containsKey(userId)) {
                    uniqueUsers[userId] = data;
                  }
                }

                return ListView.builder(
                  itemCount: uniqueUsers.length,
                  itemBuilder: (context, index) {
                    final userId = uniqueUsers.keys.elementAt(index);
                    final userData = uniqueUsers[userId]!;

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.white,
                        backgroundImage: NetworkImage(
                            'https://icons.veryicon.com/png/o/miscellaneous/two-color-icon-library/user-286.png'),
                      ),
                      title:
                          Text(userData['name'] ?? 'Noma\'lum foydalanuvchi'),
                      subtitle: Text(userData['email'] ?? 'Noma\'lum email'),
                      onTap: () {
                        // Bosilganda foydalanuvchining xabarlarini ko'rsatish
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserMessagesScreen(userData: userData),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.grey,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: AppColors.white),
              backgroundColor: AppColors.deepBlue,
              title: Text(
                translation(context).yozishmalar,
                style: TextStyles.s25w500kanitwhite,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('reports')
                        .where('email', isEqualTo: currentUser()!.email)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            translation(context).hozirchahechqandaymalumotyoq,
                          ),
                        );
                      }
                      final reports = snapshot.data!.docs;

                      return ListView.builder(
                        reverse: true,
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(reports[index]);
                        },
                      );
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
          );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: translation(context).xabarYozing,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
