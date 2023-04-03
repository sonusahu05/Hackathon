import 'package:flutter/material.dart';
import 'package:onboardpro/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboardpro/services/auth/bloc/auth_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

// Define a function to show the dialog
void _showVerifyEmailFunctionalityDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(
          color: Color(0xff15001C),
          fontSize: 16,
        ),
        title: const Text("Verify Email Functionality",
            style: TextStyle(fontSize: 20, color: Color(0xff15001C))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
                "To complete your account registration, you need to verify your email address."),
            SizedBox(height: 16),
            Text(
                "Please check your email and click on the verification link sent to your email address."),
            SizedBox(height: 16),
            Text(
                "If you do not receive the email within a few minutes, please check your spam folder or contact support for assistance."),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff15001C),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 26,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon/back_arrow.svg',
                    color: Colors.white,
                    width: 19,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 26,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon/help.svg',
                    color: Colors.white,
                    width: 19,
                  ),
                  onPressed: () {
                    _showVerifyEmailFunctionalityDialog(context);
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Verify Email Id',
                    style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "We sent a verification code to ",
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'your ',
                              style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Email id.',
                              style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0bfeef),
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ]),
                  const SizedBox(
                    height: 34,
                  ),
                  InkWell(
                    onTap: () async {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xff0bfeef),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Resend link',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff141414),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xff141414),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
