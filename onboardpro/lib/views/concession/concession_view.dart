import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/views/concession/concession_owner.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:onboardpro/services/cloud/concession/firebase_cloud_storage_concession.dart';

class ConcessionView extends StatefulWidget {
  const ConcessionView({super.key});

  @override
  State<ConcessionView> createState() => _ConcessionViewState();
}

class _ConcessionViewState extends State<ConcessionView> {
  late final FirebaseCloudStorageConcession _concessionsService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _concessionsService = FirebaseCloudStorageConcession();
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
                stream: _concessionsService.allConcessions(userId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allConcessions =
                            snapshot.data as Iterable<CloudConcession>;
                        if (allConcessions.isNotEmpty) {
                          return Column(
                            children: [
                              ConcessionOwner(
                                concessions: allConcessions,
                                onDeleteConcession: (concession) async {
                                  await _concessionsService.deleteConcession(
                                      documentConcessionId:
                                          concession.documentConcessionId);
                                },
                                onTap: (concession) {
                                  Navigator.of(context).pushNamed(
                                    concessionStatus,
                                    arguments: concession,
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('You have not registered yet!'),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    concessionRegister,
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
                                    'Register',
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
