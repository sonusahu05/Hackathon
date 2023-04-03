import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late String _imgUrl;
  late String _name;
  late String _designation;
  late String _github;
  late String _linkedin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f4f8),
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
          'Credits',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 31.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      const SizedBox(height: 20),
                      ListTile(
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/icon/sonu.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: const Text("Sonu Sahu"),
                        subtitle: const Text("Developer, Student"),
                        onTap: () {
                          _name = "Sonu Sahu";
                          _designation = "Developer, Student";
                          _imgUrl = "assets/images/icon/sonu.png";
                          _github = "https://github.com/sonusahu05";
                          _linkedin = "https://www.linkedin.com/in/sonu-sahu/";

                          _showBottomSheet(context, _name, _designation,
                              _imgUrl, _github, _linkedin);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/icon/dilip.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: const Text("Dilip Patel"),
                        subtitle: const Text("Developer, Student"),
                        onTap: () {
                          _name = "Dilip Patel";
                          _designation = "Developer, Student";
                          _imgUrl = "assets/images/icon/dilip.png";
                          _github = "https://github.com/dpatel51";
                          _linkedin =
                              "https://www.linkedin.com/in/dilip-patel-53108/";
                          _showBottomSheet(context, _name, _designation,
                              _imgUrl, _github, _linkedin);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/icon/kundan.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: const Text("Kundan Chaoudhary"),
                        subtitle: const Text("UI/UX Developer, Student"),
                        onTap: () {
                          _name = "Kundan Chaoudhary";
                          _designation = "UI/UX Developer, Student";
                          _imgUrl = "assets/images/icon/kundan.png";
                          _github = "https://github.com/archer118x";
                          _linkedin = "";
                          _showBottomSheet(context, _name, _designation,
                              _imgUrl, _github, _linkedin);
                        },
                      ),
                      // const Divider(),
                      // ListTile(
                      //   leading: ClipOval(
                      //     child: Image.asset(
                      //       "assets/images/icon/sonu.png",
                      //       height: 50,
                      //       width: 50,
                      //     ),
                      //   ),
                      //   title: const Text("Teethi Kanthe"),
                      //   subtitle: const Text("Developer, Student"),
                      //   onTap: () {
                      //     _name = "Teethi Kanthe";
                      //     _designation = "Developer, Student";
                      //     _imgUrl = "assets/images/icon/sonu.png";
                      //     _github = " ";
                      //     _linkedin = " ";
                      //     _showBottomSheet(context, _name, _designation,
                      //         _imgUrl, _github, _linkedin);
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, String name, String designation,
    String imgUrl, String github, String linkedin) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 250.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: ClipOval(
                  child: Image.asset(
                    imgUrl,
                    height: 50,
                    width: 50,
                  ),
                ),
                title: Text(name),
                subtitle: Text(designation),
              ),
              const Divider(),
              Row(
                children: [
                  const SizedBox(width: 17),
                  InkWell(
                    child: Row(
                      children: [
                        Image.asset('assets/images/icon/github.png',
                            height: 48.0),
                        const SizedBox(width: 20.0),
                        const Text('View Github Profile',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.blue)),
                      ],
                    ),
                    onTap: () {
                      launchUrlString(github);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  const SizedBox(width: 17),
                  InkWell(
                      child: Row(
                        children: <Widget>[
                          if (linkedin == "")
                            Image.asset('assets/images/icon/behance.png',
                                height: 48.0),
                          if (linkedin != "")
                            Image.asset('assets/images/icon/linkedin.png',
                                height: 48.0),
                          const SizedBox(width: 20.0),
                          if (linkedin != "")
                            const Text('View LinkedIn Profile',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue)),
                          if (linkedin == "")
                            const Text('View Behance Profile',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue)),
                        ],
                      ),
                      onTap: () {
                        if (linkedin != "") {
                          launchUrlString(linkedin);
                        } else {
                          launchUrlString(
                              "https://www.behance.net/motioneyebrow");
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
