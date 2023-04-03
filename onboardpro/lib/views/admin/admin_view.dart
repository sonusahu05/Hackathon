import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/views/admin/admin_owner.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:onboardpro/services/cloud/concession/firebase_cloud_storage_concession.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late final FirebaseCloudStorageConcession _concessionsService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _concessionsService = FirebaseCloudStorageConcession();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Welcome Admin',
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
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by email',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xff15001C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color(0xff15001C),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              const Text("These are the list of all the applications"),
              StreamBuilder(
                stream: _concessionsService.allTrueConcessions(
                  userId: userId,
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allConcessions =
                            snapshot.data as Iterable<CloudConcession>;
                        final filteredConcessions = allConcessions.where(
                            (concession) => concession.email
                                .contains(_searchController.text));
                        if (filteredConcessions.isNotEmpty) {
                          return AdminOwner(
                            concessions: filteredConcessions,
                            onTap: (concession) {
                              Navigator.of(context).pushNamed(
                                student,
                                arguments: concession,
                              );
                            },
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'No Data found.',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Text("No Data found.");
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
