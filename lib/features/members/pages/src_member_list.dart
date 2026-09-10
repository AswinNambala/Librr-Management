import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/features/members/providers/member_providers.dart';
import 'package:librrr_management/features/members/widget/members_listing.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/core/helpers/search_text_form_field.dart';

class MemberList extends ConsumerStatefulWidget {
  const MemberList({super.key});

  @override
  ConsumerState<MemberList> createState() => _MemberListState();
}

class _MemberListState extends ConsumerState<MemberList> {
  final TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchText.addListener(() {
      ref.read(membersSearchQueryProvider.notifier).state = searchText.text;
    });
  }

  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = ref.watch(filteredMembersProvider);
    final isGridView = ref.watch(membersGridViewProvider);
    final memberCount = filteredMembers.length.toString();

    return Scaffold(
      appBar: const AppBarForAll(appBarTitle: 'Members List', navToBorrow: false),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
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
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                    Text('Library Members', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text("$memberCount Members", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black),
                  child: IconButton(
                      onPressed: () {
                        ref.read(membersGridViewProvider.notifier).state = !isGridView;
                      },
                      icon: Icon(isGridView ? Icons.list : Icons.grid_view,
                          size: 30, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SearchTextFormField(searchString: searchText, hintText: 'Search members name, id....'),
            const SizedBox(height: 10),
            Expanded(
              child: filteredMembers.isEmpty
                  ? const Center(
                      child:
                          Text('No members found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                    )
                  : LayoutBuilder(
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
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.65,
                                ),
                                itemCount: filteredMembers.length,
                                itemBuilder: (context, index) {
                                  final account = filteredMembers[index];
                                  return membersBuildGridViewBuilder(context, account, index);
                                },
                              )
                            : MembersListingSection(filteredMembers: filteredMembers);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}