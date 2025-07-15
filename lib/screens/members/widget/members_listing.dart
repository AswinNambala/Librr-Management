import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/models/members/members_class.dart';
import 'package:librrr_management/screens/members/src_edit_members.dart';
import 'package:librrr_management/screens/members/src_member_profile.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/menu_options.dart';

// members listing page gird view design
Widget membersBuildGridViewBuilder(
    BuildContext context, MemberClass data, int index) {
  return InkWell(
    onTap: () {
      navigateTo(
        MemebersProfileScreen(
          memberDetails: data,
          membersKey: index,
        ),
        context,
      );
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardTheme.color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: data.profileImage == null
                  ? const Icon(Icons.person, size: 30)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        data.profileImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "${data.mFirstName} ${data.mLastName}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(data.mMembersId,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigateTo(
                              EditMemberScreen(
                                  memberEditDetails: data, index: index),
                              context);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class MembersListingSection extends StatefulWidget {
  final List<MemberClass> filteredMembers;
  const MembersListingSection({super.key, required this.filteredMembers});

  @override
  State<MembersListingSection> createState() => _MembersListingSectionState();
}

class _MembersListingSectionState extends State<MembersListingSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.filteredMembers.length,
      itemBuilder: (context, index) {
        final account = widget.filteredMembers[index];
        return Card(
          color: Theme.of(context).cardTheme.color,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              navigateTo(
                MemebersProfileScreen(
                  memberDetails: account,
                  membersKey: index,
                ),
                context,
              );
            },
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: account.profileImage == null
                      ? const Icon(Icons.person)
                      : Image.memory(
                          account.profileImage!,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                ),
              ),
              title: Text(
                account.mFirstName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                account.mMembersId,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: MemberOptionsMenus(
                account: account,
                index: index,
                box: Hive.box<MemberClass>('members'),
              ),
            ),
          ),
        );
      },
    );
  }
}
