import 'dart:convert';

import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

typedef OnboardCallBack = void Function(CloudOnboard concession);

class OnboardOwner extends StatelessWidget {
  final Iterable<CloudOnboard> concessions;
  final OnboardCallBack onDeleteOnboard;
  final OnboardCallBack onTap;

  const OnboardOwner({
    super.key,
    required this.concessions,
    required this.onDeleteOnboard,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: concessions.length,
          itemBuilder: (context, index) {
            final concession = concessions.elementAt(index);
            final keyBytes2 = base64.decode(concession.key);
            final ivBytes2 = base64.decode(concession.iv);

            final key2 = encrypt.Key(keyBytes2);
            final iv2 = encrypt.IV(ivBytes2);
            final encrypter2 = encrypt.Encrypter(encrypt.AES(key2));

            final decryptedName =
                encrypter2.decrypt64(concession.name, iv: iv2);
            final decryptedSurname =
                encrypter2.decrypt64(concession.surname, iv: iv2);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    final shouldDelete = await showDeleteDialogOnboard(context);
                    if (shouldDelete) {
                      onDeleteOnboard(concession);
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/icon/delete.svg',
                    height: 22,
                    width: 22,
                  ),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    onTap(concession);
                  },
                  title: Text(
                    '$decryptedName $decryptedSurname',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1e1e1e)),
                  ),
                  leading: SvgPicture.asset(
                    'assets/images/icon/person.svg',
                    width: 36,
                  ),
                  trailing: InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffff8c00),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text('Registered',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: Color(0xff979797),
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}
