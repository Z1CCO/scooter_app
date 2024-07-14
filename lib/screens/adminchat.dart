import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';

class UserMessagesScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserMessagesScreen({required this.userData, super.key});

  @override
  State<UserMessagesScreen> createState() => _UserMessagesScreenState();
}

class _UserMessagesScreenState extends State<UserMessagesScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.deepBlue,
        title: Text(
          translation(context).yozishmalar,
          style: TextStyles.s25w500kanitwhite,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('email', isEqualTo: widget.userData['email'])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child:
                        Text(' ${translation(context).xato} ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child:
                        Text(translation(context).hozirchahechqandaymalumotyoq),
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

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance.collection('reports').add({
      'description': _messageController.text,
      'timestamp': Timestamp.now(),
      'name': widget.userData['name'],
      'email': widget.userData['email'],
      'userId': currentUser()!.uid,
      'image1': null, // Agar rasm yuborilsa, shu yerda o'rnatiladi
      'image2': null, // Ikkita rasm uchun boshqa joy
    });

    _messageController.clear();
  }

  void _showDeleteDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translation(context).xabarniOchirish),
          content: Text(translation(context).ushbuXabarniOchirmoqchimisiz),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(translation(context).bekorQilish),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(messageId);
                Navigator.pop(context);
              },
              child: Text(translation(context).ochirish),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance.collection('reports').doc(messageId).delete();
  }

  Widget _buildMessage(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final isMyMessage = data['userId'] == widget.userData['userId'];
    final backgroundColor =
        isMyMessage ? AppColors.deepBlue : Colors.grey.shade300;
    final textColor = isMyMessage ? Colors.white : Colors.black;
    final List<String?> imageUrls = [data['image1'], data['image2']];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage)
            const CircleAvatar(
              backgroundColor: AppColors.deepBlue,
              child: Icon(Icons.person, color: Colors.white),
            ),
          const SizedBox(width: 10.0),
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () => _showDeleteDialog(context, document.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      data['description'] ?? '',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                if (imageUrls.any((url) => url != null))
                  Row(
                    mainAxisAlignment: isMyMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: imageUrls.where((url) => url != null).map((url) {
                      return GestureDetector(
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
                                      imageProvider: NetworkImage(url),
                                      heroAttributes: PhotoViewHeroAttributes(
                                        tag: 'image$url',
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
                              image: NetworkImage(url!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
