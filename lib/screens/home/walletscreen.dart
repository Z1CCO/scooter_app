import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final Future<QuerySnapshot<Map<String, dynamic>>> _future;
  List<DocumentSnapshot<Map<String, dynamic>>> posts = [];

  @override
  void initState() {
    super.initState();
    _future = getActivityuser();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getActivityuser() async {
    return await FirebaseFirestore.instance
        .collection('buy')
        .where('get', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.deepBlue,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Xatolik yuz berdi: ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          posts = snapshot.data!.docs;
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppColors.white),
            backgroundColor: AppColors.deepBlue,
            title:
                const Text('Kirim chiqim', style: TextStyles.s25w500kanitwhite),
          ),
          body: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data()!;
              final name = post['name'] ?? 'No name';
              final timestamp = post['timestamp'] != null
                  ? (post['timestamp'] as Timestamp).toDate()
                  : DateTime.now();
              final cost = post['cost'] ?? 'No cost';

              return ListTile(
                leading: Image(image: NetworkImage(post['image'])),
                title: Text(name),
                subtitle: Text(timestamp.toString()),
                trailing: Text(cost.toString()),
              );
            },
          ),
        );
      },
    );
  }
}
