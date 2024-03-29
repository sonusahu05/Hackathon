import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/services/auth/firebase_auth_provider.dart';
import 'package:onboardpro/views/common_view.dart';
import 'package:onboardpro/views/onboard/face.dart';
import 'package:onboardpro/views/onboard/good_to_go.dart';
import 'package:onboardpro/views/onboard/onboard.dart';
import 'package:onboardpro/views/onboard/verify.dart';
import 'package:onboardpro/views/onboard/step1.dart';
import 'package:onboardpro/views/onboard/onboard_register.dart';
import 'package:onboardpro/views/onboard/onboarding_form_view.dart';
import 'package:onboardpro/views/onboard/step2.dart';
import 'package:onboardpro/views/profile/about.dart';
import 'package:onboardpro/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/helpers/loading/loading_screen.dart';
import 'package:onboardpro/services/auth/bloc/auth_bloc.dart';
import 'package:onboardpro/services/auth/bloc/auth_event.dart';
import 'package:onboardpro/services/auth/bloc/auth_state.dart';
import 'package:onboardpro/views/forgot_password_view.dart';
import 'package:onboardpro/views/login_view.dart';
import 'package:onboardpro/views/notes/create_update_note_view.dart';
import 'package:onboardpro/views/notes/notes_view.dart';
import 'package:onboardpro/views/register_view.dart';
import 'package:onboardpro/views/verify_email_view.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_page_view/scroll_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;

  runApp(
    MaterialApp(
      // supportedLocales: AppLocalizations.supportedLocales,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'ONBOARD PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xff15001c)),
      home: showHome
          ? BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(FirebaseAuthProvider()),
              child: const HomePage(),
            )
          : OnBoarding(
              showHome: showHome,
            ),
      routes: {
        // eventView: (context) => const EventsView(),
        eventView: (context) => const MyPhone(),
        verify: (context) => const MyVerify(),
        note: (context) => const NotesView(),
        common: (context) => const CommonView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        profile: (context) => const ProfileView(),
        about: (context) => const AboutView(),
        onboardingRegister: (context) => const OnboardRegister(),
        onboarding: (context) => const OnboardingView(),
        // step2: (context) => const Step2(),
        good: (context) => const Good(),
        steps: (context) => const OnboardingSteps(),
        face: (context) => const FaceIO(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  // final bool showHome;
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment',
            );
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            // if (userEmail == adminConcession || userEmail == adminConcession2) {
            //   return const AdminStart();
            // } else if (userEmail == adminEvents) {
            //   return const EventsAdd();
            // } else {
            return const BottomNavBar();
            // }
          } else if (state is AuthStateNeedsVerification) {
            return const VerifyEmailView();
          } else if (state is AuthStateLoggedOut) {
            return const LoginView();
          } else if (state is AuthStateForgotPassword) {
            return const ForgotPasswordView();
          } else if (state is AuthStateRegistering) {
            return const RegisterView();
          } else {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class OnBoarding extends StatefulWidget {
  final bool showHome;
  const OnBoarding({super.key, required this.showHome});
  static List<String> images = [
    'assets/images/icon/svg1.png',
    'assets/images/icon/svg2.png',
    'assets/images/icon/svg3.png',
  ];
  static const titles = [
    'Start Onboarding',
    '100% Secure',
    'Saving Time',
    // 'onboardpro'
  ];

  static const descriptions = [
    'Start the onboarding by filling your personal \ndetails and document verification',
    'Data is encrypted and safe.',
    'We promise it will be Quick.',
  ];
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late final ScrollPageController _controller;
  bool isLastPage = false;
  @override
  void initState() {
    _controller = ScrollPageController();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _controller.controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 200,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 450,
              child: ScrollPageView(
                allowImplicitScrolling: false,
                isTimer: false,
                checkedIndicatorColor: const Color(0xff0bfeef),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  for (var i = 0; i < OnBoarding.titles.length; i++)
                    Column(
                      children: [
                        Image.asset(
                          OnBoarding.images[i],
                          height: 200,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          OnBoarding.titles[i],
                          style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            OnBoarding.descriptions[i],
                            style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            if (isLastPage != true)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.jumpToPage(3);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0bfeef),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff141414)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0bfeef),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff141414),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            'assets/images/icon/arrow_right.svg',
                            height: 13,
                            color: const Color(0xff141414),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (isLastPage == true)
              SizedBox(
                width: 300,
                height: 60,
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("showHome", true);
                    if (!mounted) return;

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => BlocProvider<AuthBloc>(
                                create: (context) =>
                                    AuthBloc(FirebaseAuthProvider()),
                                child: const HomePage(),
                              )),
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xff0bfeef),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get started',
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
              ),
          ],
        ),
      ),
    );
  }
}
