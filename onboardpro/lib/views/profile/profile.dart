import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get userEmail => AuthService.firebase().currentUser!.email;

  Future _mail(
      {required String subject,
      required String body,
      required String recipients}) async {
    final uri =
        "mailto:$recipients?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}";
    if (await canLaunchUrlString(uri)) {
      await launchUrlString(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _showBottomSheet(BuildContext context, String head, String body,
      String subject, String recipients, String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 450.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  head,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Color(0xff15001C),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xff15001C),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15001C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => _mail(
                    body: body,
                    subject: subject,
                    recipients: recipients,
                  ),
                  child: const Text('Send Mail',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f4f8),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionButton(
          elevation: 0, backgroundColor: Colors.transparent, onPressed: null),
      appBar: AppBar(
        backgroundColor: const Color(0xff15001C),
        toolbarHeight: 115,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: const Icon(
        //     Icons.arrow_back_ios,
        //   ),
        // ),
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 31.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF8C00),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icon/profile.svg',
                          color: Colors.black,
                          width: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffe4eaef),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffabc2d4),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.0,
                          blurRadius: 5.0,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // const SizedBox(height: 20),
                        // ListTile(
                        //   leading: const Icon(Icons.color_lens),
                        //   title: const Text("Theme"),
                        //   trailing: Switch(
                        //     value: isDarkModeEnabled,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         isDarkModeEnabled = value;
                        //       });
                        //     },
                        //   ),
                        // ),
                        // const Divider(),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text(
                            "Help",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showBottomSheet(
                                context,
                                "Request Help",
                                "Please provide a brief description of the issue you are experiencing",
                                "Support Request",
                                "sonu.sahu@spit.ac.in",
                                "Dear user,\n\n"
                                    "We're sorry to hear that you're experiencing issues with our app. We're here to help and want to ensure that you have the best possible experience with our product.\n\n"
                                    "Please provide a brief description of the issue you are experiencing, including any error messages or other details that might be relevant. Our team will review your request and get back to you as soon as possible with suggestions or solutions to help resolve the issue.\n\n"
                                    "Thank you for your patience and for choosing our app. We're committed to providing the best possible support to our users and will do everything we can to help you with any issues you may be experiencing.\n\n"
                                    "Best regards,\n"
                                    "devTeam");
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.bug_report),
                          title: const Text(
                            "Report a bug",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showBottomSheet(
                                context,
                                "Report a Bug",
                                "Please describe the bug you found in as much detail as possible",
                                "Bug Report",
                                "sonu.sahu@spit.ac.in",
                                "Dear user,\n\n"
                                    "Thank you for taking the time to report a bug. We appreciate your help in improving our app.\n\n"
                                    "To help us understand the issue better, please provide as much detail as possible about the bug you encountered. This could include what you were doing in the app when the bug occurred, any error messages that were displayed, and any other relevant information.\n\n"
                                    "We will review your report and work to fix the issue as soon as possible. If we need any additional information, we will contact you using the email address you provided.\n\n"
                                    "Thank you again for your help in making our app better!\n\n"
                                    "Best regards,\n"
                                    "devTeam");
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text(
                            "Credits",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              about,
                              (route) => true,
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.web),
                          title: const Text(
                            "Website",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            launchUrlString('https://www.spit.ac.in/');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.code),
                          title: const Text(
                            "Contribute?",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showBottomSheet(
                                context,
                                "Contribute",
                                "Share your resume and let us know about your skills and we will get back to you",
                                "Collaboration Request",
                                "sonu.sahu@spit.ac.in",
                                'Dear potential contributors,\n\n'
                                    'To apply for a position on our app development team, please send us an email with your LinkedIn profile, Github profile, and a brief explanation of why you want to contribute. Additionally, attach your resume to the email.\n\n'
                                    'Once we receive your email, we will review your information and contact you shortly. If your application is successful, we will provide you with instructions on how to get started with our development process.\n\n'
                                    'Thank you for your interest in our project, and we look forward to hearing from you soon!\n\n'
                                    'Best regards,\n'
                                    'devTeam');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
