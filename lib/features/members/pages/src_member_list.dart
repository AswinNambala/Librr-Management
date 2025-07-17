import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/widget/members_listing.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/core/helpers/search_text_form_field.dart';

class MemberList extends StatefulWidget {
  const MemberList({super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  final TextEditingController searchText = TextEditingController();
  final memberBox = Hive.box<MemberClass>('members');
  bool isGridView = true;
  String memberCount = "";
  List<MemberClass> allMembers = [];
  List<MemberClass> filteredMembers = [];

  @override
  void initState() {
    super.initState();
    final box = Hive.box<MemberClass>('members');
    allMembers = box.values.toList();
    filteredMembers = allMembers;
    searchText.addListener(onSearchChanged);
    memberCount = filteredMembers.length.toString();
  }

  void onSearchChanged() {
    final query = searchText.text.toLowerCase();
    setState(() {
      filteredMembers = allMembers.where((member) {
        final name = '${member.mFirstName} ${member.mLastName}'.toLowerCase();
        final id = member.mMembersId;
        return name.contains(query) || id.contains(query);
      }).toList();
    });
    memberCount = filteredMembers.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Members List',
        navToBorrow: false,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          setState(() => index);
          clearNavigateToHome(const DashboardScreen(), context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface
            ])),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library Members',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$memberCount Members",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                      icon: Icon(
                        isGridView ? Icons.list : Icons.grid_view,
                        size: 30,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SearchTextFormField(searchString: searchText, hintText: 'Search members name, id....',),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<MemberClass>('members').listenable(),
                builder: (context, Box<MemberClass> box, _) {
                  allMembers = box.values.toList();
                  filteredMembers = allMembers.where((member) {
                    final query = searchText.text;
                    final name = '${member.mFirstName} ${member.mLastName}'
                        .toLowerCase();
                    final id = member.mMembersId;
                    return name.contains(query) || id.contains(query);
                  }).toList();

                  if (filteredMembers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No members found',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      double width = constraints.maxWidth;

                      if (width > 1200) {
                        crossAxisCount = 5;
                      } else if (width > 800) {
                        crossAxisCount = 4;
                      } else if (width > 600) {
                        crossAxisCount = 3;
                      }

                      return isGridView
                          ? GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                final account = filteredMembers[index];
                                return membersBuildGridViewBuilder(
                                    context, account, index, );
                              },
                            )
                          : MembersListingSection(filteredMembers: filteredMembers,);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchText.removeListener(onSearchChanged);
    searchText.dispose();
    super.dispose();
  }
}
