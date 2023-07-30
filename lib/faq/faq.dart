import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../services/firestore.dart';
import '../services/models.dart';
import '../shared/error.dart';
import '../ui/gradient/text_gradient.dart';
import '../ui/theme/buttons/buttons.dart';
import '../ui/theme/theme_provider.dart';
import '../ui/widgets/animate_shimmer.dart';
import '../ui/widgets/not_found_animate.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);

    ConnectionState refreshIndicator = ConnectionState.waiting;
    Future retry() async {
      setState(() {
        refreshIndicator = ConnectionState.waiting;
      });
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 2,
          title: const TextGradient(
              text: 'Frequently Asked Questions', appbarfontsize: 16)),
      body: RefreshIndicator(
        strokeWidth: 1.5,
        onRefresh: () async {
          await retry();
        },
        child: FutureBuilder<List<FAQModel>>(
          future: FirestoreService().streamFAQ(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != refreshIndicator) {
              if (snapshot.data!.isEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      NotFoundAnimation(
                        text: 'No FAQs Yet',
                        color:
                            darkModeProvider.isDarkTheme ? Colors.white : null,
                      ),
                      const SizedBox(height: 30),
                      DesignButtons.icon(
                        onPressed: () async {
                          await retry();
                        },
                        textLabel: 'Retry ',
                        colorText:
                            darkModeProvider.isDarkTheme ? Colors.white : null,
                        icon: const Icon(Ionicons.refresh_circle_outline),
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                );
              }
            }
            if (snapshot.connectionState == refreshIndicator) {
              return const AnimateShimmer();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(message: snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              List<FAQModel> streamFAQ = snapshot.data!;
              return ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                primary: false,
                padding: const EdgeInsets.all(6.0),
                children: streamFAQ.map((streamFAQ) {
                  return FAQ(
                    question: streamFAQ.question,
                    queStyle: TextStyle(
                        color: darkModeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                    ansStyle: TextStyle(
                        color: darkModeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                    answer: streamFAQ.answer,
                    ansDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    queDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  );
                }).toList(),
              );
            } else {
              return const Text('Not Found');
            }
          },
        ),
      ),
    );
  }
}
