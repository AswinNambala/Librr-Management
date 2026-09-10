import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/pages/src_edit_members.dart';
import 'package:librrr_management/features/members/providers/member_providers.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/features/members/widget/members_profile_container.dart';

class MemebersProfileScreen extends ConsumerStatefulWidget {
  final MemberClass memberDetails;
  final int membersKey;
  const MemebersProfileScreen(
      {super.key, required this.memberDetails, required this.membersKey});

  @override
  ConsumerState<MemebersProfileScreen> createState() => _MemebersProfileScreenState();
}

class _MemebersProfileScreenState extends ConsumerState<MemebersProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberId = widget.memberDetails.mMembersId;
    final booksInHandAsync = ref.watch(memberBooksInHandProvider(memberId));
    final finishedBooksAsync = ref.watch(memberFinishedBooksProvider(memberId));
    final booksInHandList = booksInHandAsync.asData?.value ?? const [];
    final finishedBookList = finishedBooksAsync.asData?.value ?? const [];
    final fineBookList = memberFineOnlyBooks(finishedBookList);
    final totalFine = memberTotalFine(finishedBookList);
    final remainingDays = memberRemainingDays(widget.memberDetails.mExpireDate);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            clearNavigateToHome(const DashboardScreen(), context);
          }),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface
            ])),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30)),
                    IconButton(
                        onPressed: () {
                          navigateTo(
                              EditMemberScreen(
                                  memberEditDetails: widget.memberDetails,
                                  index: widget.membersKey),
                              context);
                        },
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).colorScheme.primary, size: 25))
                  ],
                ),
                const SizedBox(height: 20),
                MemberProfileDetialsSection(
                  isWeb: isWeb,
                  memberDetails: widget.memberDetails,
                  membersKey: widget.membersKey,
                  remainingDays: remainingDays,
                  booksInHand: booksInHandList,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CountContainerMember(
                          icon: Icons.book,
                          iconColor: Colors.blue,
                          count:
                              "${booksInHandList.length} / ${widget.memberDetails.mBooksPerMonth}",
                          head: 'Reading'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CountContainerMember(
                          iconColor: Colors.yellow,
                          icon: Icons.bookmark,
                          count: finishedBookList.length.toString(),
                          head: 'Borrowed'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CountContainerMember(
                          iconColor: Colors.red,
                          icon: Icons.account_balance_wallet_rounded,
                          count: '₹$totalFine',
                          head: 'Total Fine'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MemberProfileTabBar(tabControl: tabBarController),
                Expanded(
                  child: TabBarView(controller: tabBarController, children: [
                    MembersProfileCurrentTab(currentBooks: booksInHandList),
                    MembersProfileHistoryTab(finishedBooks: finishedBookList),
                    MembersProfileLateFinesTab(fineBooks: fineBookList),
                  ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}