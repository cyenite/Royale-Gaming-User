// ignore_for_file: depend_on_referenced_packages

import 'package:app_tournament/services/network.dart';
import 'package:app_tournament/services/services.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/gradient/text_gradient.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentsPage extends StatefulWidget {
  final String accessToken;
  final String phone;
  final int amount;
  const PaymentsPage({
    Key? key,
    required this.accessToken,
    required this.phone,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  PaymentStatus paymentStatus = PaymentStatus.AUTHORIZED;
  String transactionId = '';

  @override
  void initState() {
    initiatePayment();
    super.initState();
  }

  initiatePayment() {
    NetworkService()
        .requestPayment(
            accToken: widget.accessToken,
            phoneNumber: widget.phone,
            amount: widget.amount)
        .then((value) {
      if (value['success']) {
        setState(() {
          paymentStatus = PaymentStatus.NOTIFICATION_SENT;
        });
        verifyPayment(checkoutReqId: value['checkoutRequestId']);
      } else {
        setState(() {
          paymentStatus = PaymentStatus.FAILED;
        });
      }
    });
  }

  verifyPayment({required String checkoutReqId}) {
    NetworkService()
        .verifyPayment(
            checkoutReqId: checkoutReqId, accToken: widget.accessToken)
        .then((value) {
      if (value['paid']) {
        setState(() {
          paymentStatus = PaymentStatus.VERIFIED;
          transactionId = value['tId'];
        });
      } else {
        Future.delayed(const Duration(seconds: 4), () {
          verifyPayment(checkoutReqId: checkoutReqId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const TextGradient(text: 'Deposit Status', appbarfontsize: 24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Visibility(
              visible: paymentStatus != PaymentStatus.AUTHORIZED,
              replacement: Column(
                children: [
                  Lottie.asset('assets/loading.json', height: 100),
                  const DesignText.bold2(
                    'LOADING, PLEASE WAIT.',
                    color: Colors.grey,
                    fontWeight: 800,
                  ),
                ],
              ),
              child: Visibility(
                visible: paymentStatus == PaymentStatus.VERIFIED,
                replacement: Visibility(
                  visible: paymentStatus == PaymentStatus.NOTIFICATION_SENT,
                  replacement: Column(
                    children: [
                      Lottie.asset('assets/error.json', height: 100),
                      const DesignText.bold2(
                        'TRANSACTION FAILED. KINDLY TRY AGAIN.',
                        color: Colors.grey,
                        fontWeight: 800,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DesignText.bold2(
                        'MPESA Notification Sent to 0700001267',
                        color: darkModeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: 800,
                      ),
                      const SizedBox(height: 10),
                      const DesignText.bold2(
                        'Step 1. Enter your MPESA pin to authorize transaction.',
                        color: Colors.grey,
                        fontWeight: 500,
                      ),
                      const DesignText.bold2(
                        'Step 2. Submit.',
                        color: Colors.grey,
                        fontWeight: 500,
                      ),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Lottie.asset('assets/completed.json', height: 100),
                    const DesignText.bold2(
                      'PAYMENT PROCESSED SUCCESDFULLY.',
                      color: Colors.grey,
                      fontWeight: 800,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.2),
                borderRadius: BorderRadius.circular(10.0),
                color: darkModeProvider.isDarkTheme
                    ? DesignColor.blackFront
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.8,
                    blurRadius: 0.8,
                    offset: const Offset(0.5, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 20.0,
                    width: 100.0,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: darkModeProvider.isDarkTheme
                          ? Colors.grey
                          : Colors.grey.shade100,
                    ),
                    child: const Center(
                        child: DesignText.caption(
                      'TILL NUMBER',
                      color: Colors.black,
                      fontWeight: 700,
                    )),
                  ),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.blue.shade100.withOpacity(0.5),
                    ),
                    child: Center(
                        child: DesignText.title(
                      'RT',
                      color: darkModeProvider.isDarkTheme
                          ? Colors.white
                          : Colors.blue,
                      fontSize: 16.0,
                    )),
                  ),
                  const DesignText.bold2(
                    'ROYALE TOURNAMENTS',
                    color: Colors.grey,
                    fontWeight: 800,
                  ),
                  DesignText.bold1(
                    'KSH ${widget.amount}',
                    color: darkModeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black,
                    fontWeight: 800,
                  ),
                  Visibility(
                    visible: paymentStatus == PaymentStatus.VERIFIED,
                    replacement: Flexible(
                      child: Shimmer.fromColors(
                        baseColor: darkModeProvider.isDarkTheme
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey.shade300,
                        highlightColor: darkModeProvider.isDarkTheme
                            ? Colors.green.shade200
                            : Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.green.shade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Center(
                                child: DesignText.caption(
                                  '',
                                  color: Colors.green,
                                  fontWeight: 700,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.copy,
                                color: Colors.green,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                                  ClipboardData(text: transactionId))
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "Reference copied to clipboard.",
                                toastLength: Toast.LENGTH_SHORT);
                          });
                        },
                        child: Container(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.green.shade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: DesignText.caption(
                                  transactionId,
                                  color: Colors.green.shade900,
                                  fontWeight: 700,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Icon(
                                Icons.copy,
                                color: Colors.green,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PaymentDetailWidget(
                            title: 'PHONE NUMBER',
                            value: widget.phone,
                            complete: paymentStatus == PaymentStatus.VERIFIED,
                          ),
                          PaymentDetailWidget(
                            title: 'STATUS',
                            value: paymentStatus != PaymentStatus.VERIFIED
                                ? 'PENDING'
                                : 'COMPLETE',
                            complete: paymentStatus == PaymentStatus.VERIFIED,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                BottomRoundedButtons(icon: Icons.star, subtitle: 'Save'),
                SizedBox(width: 20),
                BottomRoundedButtons(icon: Icons.receipt, subtitle: 'Download'),
                SizedBox(width: 20),
                BottomRoundedButtons(icon: Icons.share, subtitle: 'Share'),
              ],
            ), */
          ],
        ),
      ),
    );
  }
}

class BottomRoundedButtons extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  const BottomRoundedButtons({
    Key? key,
    required this.icon,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30.0,
          width: 30.0,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blue.shade100.withOpacity(0.5),
          ),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 15,
          ),
        ),
        DesignText.caption(
          subtitle,
          color: Colors.grey,
          fontWeight: 400,
        ),
      ],
    );
  }
}

class PaymentDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool complete;
  const PaymentDetailWidget({
    Key? key,
    required this.title,
    required this.value,
    this.complete = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: DesignText.caption(
            '$title:',
            color: Colors.grey,
            fontWeight: 700,
          ),
        ),
        DesignText.caption(
          value,
          color: complete ? Colors.green : Colors.deepOrange,
          fontWeight: 700,
        ),
      ],
    );
  }
}
