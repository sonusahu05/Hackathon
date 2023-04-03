import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef ConcessionCallBack = void Function(CloudConcession concession);

class AdminOwner extends StatelessWidget {
  final Iterable<CloudConcession> concessions;
  final ConcessionCallBack onTap;

  const AdminOwner({
    super.key,
    required this.concessions,
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
            return ListTile(
              dense: true,
              onTap: () {
                onTap(concession);
              },
              title: Text(
                concession.name,
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
                  child: const Text('View Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 2,
          ),
        ),
      ],
    );
  }
}
