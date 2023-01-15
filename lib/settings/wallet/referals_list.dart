import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../services/models.dart';
import '../../ui/theme/text.dart';
import '../../ui/theme/theme_provider.dart';
import '../../ui/widgets/animate_shimmer.dart';

class ReferalListScreen extends StatefulWidget {
  const ReferalListScreen({Key? key}) : super(key: key);

  @override
  State<ReferalListScreen> createState() => _ReferalListScreenState();
}

class _ReferalListScreenState extends State<ReferalListScreen> {
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);

    CollectionReference userRef =
        FirebaseFirestore.instance.collection("userData");

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.blueAccent,
          elevation: 1,
          title: DesignText(
            'Referals',
            color: darkModeProvider.isDarkTheme ? Colors.white : null,
          ),
        ),
        body: FutureBuilder(
          future: userRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DataTable(
                columns: [
                  DataColumn(
                    label: DesignText(
                      'Username',
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  ),
                  DataColumn(
                    label: DesignText(
                      'Date',
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  ),
                  DataColumn(
                    label: DesignText(
                      'Amount',
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  )
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: DesignText.bold1(
                            'Kelvin Rono',
                            color: darkModeProvider.isDarkTheme
                                ? Colors.white
                                : null,
                          )),
                          const SizedBox(
                            height: 20,
                            child: VerticalDivider(),
                          )
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DesignText.bold2(
                              'Jan 2, 2023',
                              color: darkModeProvider.isDarkTheme
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                            child: VerticalDivider(),
                          )
                        ],
                      ),
                    ),
                    DataCell(
                      DesignText.bold2(
                        'KES 50',
                        color: darkModeProvider.isDarkTheme
                            ? Colors.greenAccent
                            : null,
                      ),
                    ),
                  ])
                ],
              );
            } else {
              return const AnimateShimmer();
            }
          },
        ));
  }
}
