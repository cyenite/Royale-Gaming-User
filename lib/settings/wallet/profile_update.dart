import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/progress_circle.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> with WidgetsBindingObserver {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _profile = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      inputFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: loading
            ? const ProgressAwesome()
            : FloatingActionButton.extended(
                onPressed: _uploadFirestore,
                label: Row(
                  children: [
                    const Icon(
                      Ionicons.cloud_upload,
                      color: Colors.white,
                      size: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: const Text(
                        "Update",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
        appBar: AppBar(
          elevation: 0.6,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: darkModeProvider.isDarkTheme ? Colors.white : null,
            ),
          ),
          title: DesignText(
            "Update Profile",
            color: darkModeProvider.isDarkTheme ? Colors.white : null,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            primary: false,
            children: [
              const SizedBox(height: 6),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _userName,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (_userName.text != value.toUpperCase()) {
                    _userName.value = _userName.value.copyWith(text: value);
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Username",
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: EdgeInsets.all(16),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                textCapitalization: TextCapitalization.characters,
                controller: _profile,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Avatar Link",
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: EdgeInsets.all(16),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              DesignText.bold2(
                'Paste your avatar link or choose any of the following defaults.',
                color: darkModeProvider.isDarkTheme ? Colors.white : null,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: DesignButtons.customRadius(
                        color: DesignColor.blueSmart,
                        elevated: true,
                        pdbottom: 0,
                        pdleft: 2,
                        pdright: 2,
                        pdtop: 0,
                        bottomRight: 0,
                        topRight: 0,
                        onPressed: () async {
                          FlutterClipboard.paste().then((value) {
                            // Do what ever you want with the value.
                            setState(() {
                              _profile.text = AppInformation.profile1;
                            });
                          });
                        },
                        textLabel: 'Animate',
                        icon: const Icon(
                          Ionicons.person_circle_outline,
                          size: 18,
                        )),
                  ),
                  Expanded(
                    child: DesignButtons.customRadius(
                        color: Colors.blueAccent,
                        elevated: true,
                        pdbottom: 0,
                        pdleft: 2,
                        pdright: 2,
                        pdtop: 0,
                        bottomRight: 0,
                        topRight: 0,
                        bottomLeft: 0,
                        topLeft: 0,
                        onPressed: () async {
                          FlutterClipboard.paste().then((value) {
                            // Do what ever you want with the value.
                            setState(() {
                              _profile.text = AppInformation.profile2;
                            });
                          });
                        },
                        textLabel: 'Butterfly',
                        icon: const Icon(
                          Ionicons.people_circle_outline,
                          size: 18,
                        )),
                  ),
                  Expanded(
                    child: DesignButtons.customRadius(
                        color: Colors.lightBlueAccent,
                        elevated: true,
                        pdbottom: 0,
                        pdleft: 2,
                        pdright: 2,
                        pdtop: 0,
                        bottomLeft: 0,
                        topLeft: 0,
                        onPressed: () async {
                          FlutterClipboard.paste().then((value) {
                            // Do what ever you want with the value.
                            setState(() {
                              _profile.text = AppInformation.profile3;
                            });
                          });
                        },
                        textLabel: 'Simple',
                        icon: const Icon(
                          Ionicons.walk_outline,
                          size: 18,
                        )),
                  ),
                ],
              ),
              DesignButtons.icon(
                onPressed: () {
                  FlutterClipboard.paste().then((value) {
                    setState(() {
                      _profile.text = value;
                    });
                  });
                },
                textLabel: 'Custom Avatar Link',
                colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                icon: const Icon(Ionicons.clipboard_outline, size: 18),
              ),
              const SizedBox(height: 4),
              DesignText(
                'Note:',
                color: darkModeProvider.isDarkTheme ? Colors.white : null,
              ),
              DesignText.bold2(
                'Also you can upload GIF image link. \nUse github for Images Storage',
                color: darkModeProvider.isDarkTheme ? Colors.white : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadFirestore() async {
    if (_userName.text.isEmpty || _userName.text.isEmpty || _userName.text.isEmpty) {
      return formSnackbar();
    } else {
      setState(() {
        loading = true;
      });

      final usernameData = _db.collection('usersdata').where('name', isEqualTo: _userName.text).get();

      usernameData.then((value) async {
        if (value.docs.isEmpty) {
          final User user = AuthService().user!;
          _db
              .collection('usersdata')
              .doc(user.uid)
              .set({'name': _userName.text, 'profile': _profile.text}, SetOptions(merge: true)).whenComplete(() => Navigator.pop(context));
          await Future.delayed(const Duration(milliseconds: 1000));
          setState(() {
            loading = false;
          });
          successSnackbar();
        } else {
          userNameUnavailableSnackbar();
          await Future.delayed(const Duration(milliseconds: 1000));
          setState(() {
            loading = false;
          });
        }
      });
    }
  }

  void successSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text(
          "Success",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void userNameUnavailableSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text(
          "Username is taken. Try another username",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void formSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text(
          "Pleae complete form Field",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
