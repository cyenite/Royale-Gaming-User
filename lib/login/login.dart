import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/login/login_widget.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneCountry = '254';
  Country countryDetails = Country.worldWide;
  String defaultCountryFlag = '🇰🇪';
  String defaultCountryName = 'Kenya';
  bool isPhoneSignin = false;
  String? verificationCodeID;
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  countryListTheme: CountryListThemeData(borderRadius: BorderRadius.circular(6)),
                  onSelect: (Country country) {
                    setState(() {
                      phoneCountry = country.phoneCode;
                      countryDetails = country;
                    });
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DesignText(countryDetails.name == 'World Wide' ? defaultCountryFlag : countryDetails.flagEmoji),
                    const SizedBox(width: 4),
                    DesignText(
                      countryDetails.name == 'World Wide' ? defaultCountryName : countryDetails.name,
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Lottie.asset(
                    'assets/winner_games.json',
                  ),
                  if (darkModeProvider.isDarkTheme)
                    Container(
                      color: DesignColor.blackBackground.withOpacity(0.2),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  DesignText.bold1(
                    AppInformation().appMainTitle,
                    fontSize: 32,
                    fontWeight: 700,
                    color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    textAlign: TextAlign.center,
                  ),
                  DesignText.bold1(
                    AppInformation().appSmallTitle,
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    fontWeight: 600,
                  ),
                ],
              ),
            ),
            TextField(
              controller: _phoneNumber,
              onChanged: (f) {
                setState(() {
                  isPhoneSignin = true;
                });
              },
              style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                fontSize: 22.0,
              )),
              decoration: InputDecoration(
                prefixText: "+$phoneCountry" ' ',
                prefixStyle: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                  fontSize: 20.0,
                )),
                labelText: '+$phoneCountry 000 000000',
                filled: true,
                fillColor: Colors.transparent,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            // Please Remove or Comment if you don't want google Sign-in and Skip Sign-in
            // Start remove ---
            const SizedBox(height: 6),
            !isPhoneSignin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: LoginButton(
                          bottomRight: 0,
                          topRight: 0,
                          text: 'Sign In',
                          icon: Ionicons.logo_google,
                          color: const Color.fromARGB(255, 225, 105, 6),
                          loginMethod: AuthService().googleLogin,
                        ),
                      ),
                      Expanded(
                        child: LoginButton(
                          bottomLeft: 0,
                          topLeft: 0,
                          icon: Ionicons.id_card,
                          text: 'Skip',
                          loginMethod: AuthService().anonLogin,
                          color: const Color.fromARGB(255, 0, 213, 11),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: LoginButton(
                          bottomRight: 0,
                          topRight: 0,
                          text: 'Send OTP',
                          icon: Ionicons.phone_portrait_outline,
                          color: const Color.fromARGB(255, 2, 162, 11),
                          loginMethod: () async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: "+$phoneCountry${_phoneNumber.text}",
                              verificationCompleted: (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent: (String verificationId, int? resendToken) {
                                setState(() {
                                  verificationCodeID = verificationId;
                                });
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {},
                            );

                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: SizedBox(
                                      height: 170,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: ListView(
                                          children: [
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: _otp,
                                              decoration: const InputDecoration(
                                                labelText: 'OTP',
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
                                              keyboardType: TextInputType.number,
                                            ),
                                            const SizedBox(height: 20),
                                            DesignButtons.icon(
                                              icon: const Icon(Ionicons.phone_portrait_outline),
                                              textLabel: 'Submit',
                                              onPressed: () {
                                                FirestoreService().phoneAuthProvider(_otp.text, verificationCodeID!);
                                                Navigator.pop(context);
                                              },
                                              colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                      Expanded(
                        child: LoginButton(
                          bottomLeft: 0,
                          topLeft: 0,
                          icon: Ionicons.arrow_back_circle_outline,
                          text: 'Cancel',
                          loginMethod: () {
                            setState(() {
                              isPhoneSignin = false;
                            });
                          },
                          color: const Color.fromARGB(255, 199, 5, 5),
                        ),
                      ),
                    ],
                  ),
            // End remove ---
          ],
        ),
      ),
    );
  }
}
