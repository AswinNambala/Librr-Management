import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/features/members/controllers/finished_book_utils.dart';
import 'package:librrr_management/data/data_sources/local_data/members_db_utils.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/pages/src_edit_members.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/features/members/widget/members_profile_container.dart';

class MemebersProfileScreen extends StatefulWidget {
  final MemberClass memberDetails;
  final int membersKey;
  const MemebersProfileScreen(
      {super.key, required this.memberDetails, required this.membersKey});

  @override
  State<MemebersProfileScreen> createState() => _MemebersProfileScreenState();
}

class _MemebersProfileScreenState extends State<MemebersProfileScreen>
    with TickerProviderStateMixin {
  int? remainingDays;
  List<BorrowedBookClass> booksInHandList = [];
  List<FinishedBookClass> finishedBookList = [];
  List<FinishedBookClass> fineBookList = [];
  late TabController tabBarController;
  String totalFineAmount = '';
  @override
  void initState() {
    super.initState();
    remainingDateCalculate();
    loadBooksInHand();
    loadFinishedBooks();
    tabBarController = TabController(length: 3, vsync: this);
    fineAmountLoading();
  }

  Future<void> remainingDateCalculate() async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateTime expireDate =
        formatter.parse(widget.memberDetails.mExpireDate);
    final int remainDate = expireDate.difference(DateTime.now()).inDays;
    setState(() {
      remainingDays = remainDate;
    });
  }

  Future<void> loadBooksInHand() async {
    final books = DbMemberUtils.profileMemberGetBooksInHand(
        widget.memberDetails.mMembersId);
    setState(() {
      booksInHandList = books;
    });
  }

  Future<void> fineAmountLoading() async {
    setState(() {
      for (var book in finishedBookList) {
        if (book.fineAmount.isNotEmpty) {
          fineBookList.add(book);
        }
        debugPrint("fine amount ${book.fineAmount}");
      }
    });
    totalFineAmount = FinishedBookUtils.fineAmountCalculate(
        context, widget.memberDetails.mMembersId);
  }

  Future<void> loadFinishedBooks() async {
    final booksDet = DbMemberUtils.profileMemberGetFinishedBooks(
        widget.memberDetails.mMembersId);
    setState(() {
      finishedBookList = booksDet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            setState(() => index);
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
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.surface
                ])),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          navigateTo(
                              EditMemberScreen(
                                  memberEditDetails: widget.memberDetails,
                                  index: widget.membersKey),
                              context);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MemberProfileDetialsSection(
                  isWeb: isWeb, 
                  memberDetails: widget.memberDetails, 
                  membersKey: widget.membersKey, 
                  remainingDays: remainingDays,
                  booksInHand: booksInHandList,
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CountContainerMember(
                        icon: Icons.book,
                        iconColor: Colors.blue,
                        count: "${booksInHandList.length.toString()} / ${widget.memberDetails.mBooksPerMonth}",
                        head: 'Reading'),
                    CountContainerMember(
                        iconColor: Colors.yellow,
                        icon: Icons.bookmark,
                        count: finishedBookList.length.toString(),
                        head: 'Borrowed'),
                    CountContainerMember(
                        iconColor: Colors.red,
                        icon: Icons.account_balance_wallet_rounded,
                        count: totalFineAmount.isEmpty
                            ? '₹0'
                            : "₹ $totalFineAmount",
                        head: 'Total Fine')
                  ],
                ),
                const SizedBox(height: 20),
                MemberProfileTabBar(tabControl: tabBarController),
                Expanded(
                  child: TabBarView(controller: tabBarController, children: [
                    MembersProfileCurrentTab(
                      currentBooks: booksInHandList,
                    ),
                    MembersProfileHistoryTab(
                      finishedBooks: finishedBookList,
                    ),
                    MembersProfileLateFinesTab(
                      fineBooks: fineBookList,
                    )
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
