import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/views/onboard/onboard_owner.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final FirebaseCloudStorageOnboard _onboardingService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _onboardingService = FirebaseCloudStorageOnboard();
    super.initState();
  }

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
            'Welcome',
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
        body: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: _onboardingService.allOnboard(userId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allOnboards =
                            snapshot.data as Iterable<CloudOnboard>;
                        if (allOnboards.isNotEmpty) {
                          return Column(
                            children: [
                              OnboardOwner(
                                concessions: allOnboards,
                                onDeleteOnboard: (concession) async {
                                  await _onboardingService.deleteOnboard(
                                      documentOnboardId:
                                          concession.documentOnboardId);
                                },
                                onTap: (concession) {
                                  Navigator.of(context).pushNamed(
                                    step2,
                                    arguments: concession,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'You may proceed to the next step to complete the kyc',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  'You have not registered for the kyc yet!'),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    onboardingRegister,
                                    (route) => true,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffff8c00),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    'Register for Kyc',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Container();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ));
  }
}
