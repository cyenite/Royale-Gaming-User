import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            // onPressed: () async {
            //   final FirebaseFirestore _db = FirebaseFirestore.instance;
            //   User user = FirebaseAuth.instance.currentUser!;
            //   String uid = user.uid;
            //   final DocumentReference ref1 =
            //       _db.collection('authors').doc('admin');
            //   DocumentSnapshot snap2 = await ref1.get();
            //   List authors = snap2['authors'].map((e) {
            //     return e['id'];
            //   }).toList();
            //   if (authors.contains(uid)) {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       return const AuthorScreen();
            //     }));
            //   }
            // },
            onPressed: () {},
            child: const Text('This app is under dev.')),
      ), 
    );
  }
}
