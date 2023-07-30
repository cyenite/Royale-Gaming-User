import 'package:app_tournament/services/network.dart';
import 'package:app_tournament/services/services.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/gradient/text_gradient.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WithdrawPage extends StatefulWidget {
  final String accessToken;
  final String phone;
  final String name;
  final int amount;
  const WithdrawPage({
    Key? key,
    required this.accessToken,
    required this.phone,
    required this.amount,
    required this.name,
  }) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  PaymentStatus paymentStatus = PaymentStatus.AUTHORIZED;
  String transactionId = '';

  @override
  void initState() {
    initiatePayment();
    super.initState();
  }

  initiatePayment() {
    NetworkService()
        .withdrawFunds(
            phone: widget.phone,
            accToken: widget.accessToken,
            amount: widget.amount)
        .then((result) {
      if (result['paid']) {
        FirestoreService()
            .updateWallet(
                -widget.amount.abs(),
                'Withdraw',
                DateTime.now().toString(),
                widget.name,
                'MPESA NUMBER',
                widget.phone,
                false)
            .whenComplete(() {
          setState(() {
            paymentStatus = PaymentStatus.VERIFIED;
          });
        });
      } else {
        setState(() {
          paymentStatus = PaymentStatus.FAILED;
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
        title: const TextGradient(text: 'Funds Withdrawal', appbarfontsize: 24),
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
                replacement: Column(
                  children: [
                    Lottie.asset('assets/error.json', height: 100),
                    const DesignText.bold2(
                      'REQUEST FAILED. KINDLY TRY AGAIN LATER.',
                      color: Colors.grey,
                      fontWeight: 800,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Lottie.asset('assets/completed.json', height: 100),
                    const SizedBox(height: 10.0),
                    DesignText.bold2(
                      'WITHDRAWAL TO ${widget.phone} PROCESSED SUCCESSFULLY.',
                      color: Colors.grey,
                      fontWeight: 800,
                      textAlign: TextAlign.center,
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
                      'MPESA',
                      color: Colors.black,
                      fontWeight: 900,
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
                  DesignText.bold2(
                    widget.name.toUpperCase(),
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
                                  'Transaction Successful',
                                  color: Colors.green,
                                  fontWeight: 700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Flexible(
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
                                'Withdawal successful',
                                color: Colors.green.shade900,
                                fontWeight: 700,
                              ),
                            ),
                          ],
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
