import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/features/members/controllers/member_utils.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

// member profile count container
class CountContainerMember extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String count;
  final String head;
  const CountContainerMember(
      {super.key,
      required this.iconColor,
      required this.icon,
      required this.count,
      required this.head});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: iconColor,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            count,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            head,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}

// members profile tab bar options
class MemberProfileTabBar extends StatelessWidget {
  final TabController tabControl;
  const MemberProfileTabBar({super.key, required this.tabControl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: TabBar(
          controller: tabControl,
          indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10)),
          unselectedLabelColor: Theme.of(context).colorScheme.surface,
          labelColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.library_books_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Current',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Fine',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            )
          ]),
    );
  }
}

// members profile current books tab section
class MembersProfileCurrentTab extends StatefulWidget {
  final List<BorrowedBookClass> currentBooks;
  const MembersProfileCurrentTab({super.key, required this.currentBooks});

  @override
  State<MembersProfileCurrentTab> createState() =>
      _MembersProfileCurrentTabState();
}

class _MembersProfileCurrentTabState extends State<MembersProfileCurrentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.surface
          ])),
      child: widget.currentBooks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.library_books_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Currently No Borrowed Books',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'This member has returned all books',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                )
              ],
            )
          : ListView.builder(
              itemCount: widget.currentBooks.length,
              itemBuilder: (context, index) {
                final books = widget.currentBooks[index];
                return InkWell(
                  onTap: () {
                    MemberUtils.membersOpenBooksProfile(books.bookId, context);
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      leading: const CircleAvatar(
                        child: ClipRRect(
                          child: Icon(Icons.book),
                        ),
                      ),
                      title: Text(
                        books.bookName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        books.bookId,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}

// members profile history books tab section
class MembersProfileHistoryTab extends StatefulWidget {
  final List<FinishedBookClass> finishedBooks;
  const MembersProfileHistoryTab({super.key, required this.finishedBooks});

  @override
  State<MembersProfileHistoryTab> createState() =>
      _MembersProfileHistoryTabState();
}

class _MembersProfileHistoryTabState extends State<MembersProfileHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.surface
          ])),
      child: widget.finishedBooks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.bookmark,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Reading History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'This member hasn\'t completed any book borrowing yet',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                )
              ],
            )
          : ListView.builder(
              itemCount: widget.finishedBooks.length,
              itemBuilder: (context, index) {
                final books = widget.finishedBooks[index];
                return InkWell(
                  onTap: () {
                    MemberUtils.membersOpenBooksProfile(books.bookId, context);
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      leading: const CircleAvatar(
                        child: ClipRRect(
                          child: Icon(Icons.book),
                        ),
                      ),
                      title: Text(
                        books.bookName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books.memberName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            books.bookReturnedDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}

// members profile late fine books tab section
class MembersProfileLateFinesTab extends StatefulWidget {
  final List<FinishedBookClass> fineBooks;
  const MembersProfileLateFinesTab({super.key, required this.fineBooks});

  @override
  State<MembersProfileLateFinesTab> createState() =>
      _MembersProfileLateFinesTabState();
}

class _MembersProfileLateFinesTabState
    extends State<MembersProfileLateFinesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface
            ])),
        child: widget.fineBooks.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No Fine',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'This member has a clean record with no late fine',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemCount: widget.fineBooks.length,
                itemBuilder: (context, index) {
                  final books = widget.fineBooks[index];
                  return InkWell(
                    onTap: () {
                      MemberUtils.membersOpenBooksProfile(
                          books.bookId, context);
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: const CircleAvatar(
                          child: ClipRRect(
                            child: Icon(Icons.book_sharp),
                          ),
                        ),
                        title: Text(
                          books.bookName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          books.memberName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Text(
                          books.fineAmount,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  );
                }));
  }
}

// member profile view member detials bottom sheet
void memberProfileDetialsBottomSheet(BuildContext context, MemberClass member,
    int keyIndex, String remianingDate, List<BorrowedBookClass> booksInHand) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Member Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: member.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            member.profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${member.mFirstName} ${member.mLastName}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          MemberProfileOptionMenu(
                            account: member,
                            index: keyIndex,
                            box: Hive.box<MemberClass>('members'),
                            booksInHand: booksInHand,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        member.mMembersId,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Phone Number",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                member.mPhoneNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Address",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                member.mAddress,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Pincode",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                member.mPincode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Membership Plan",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                member.mPlan,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Allowed Books",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                "${member.mBooksPerMonth} per month",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Remaining Days",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                "$remianingDate days",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget buildPaymentOptionButton(BuildContext context, String label) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
        )
      ],
    ),
    child: Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  );
}

// members profile page members profile details section
class MemberProfileDetialsSection extends StatefulWidget {
  final bool isWeb;
  final MemberClass memberDetails;
  final int membersKey;
  final int? remainingDays;
  final List<BorrowedBookClass> booksInHand;
  const MemberProfileDetialsSection(
      {super.key,
      required this.isWeb,
      required this.memberDetails,
      required this.membersKey,
      required this.remainingDays,
      required this.booksInHand
      });

  @override
  State<MemberProfileDetialsSection> createState() =>
      _MemberProfileDetialsSectionState();
}

class _MemberProfileDetialsSectionState
    extends State<MemberProfileDetialsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ],
                      shape: BoxShape.circle),
                  child: widget.memberDetails.profileImage == null
                      ? Icon(
                          Icons.person,
                          size: widget.isWeb ? 100 : 60,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.memory(
                            widget.memberDetails.profileImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.memberDetails.mFirstName} ${widget.memberDetails.mLastName}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.memberDetails.mMembersId,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.memberDetails.mPhoneNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 25,
                          decoration: BoxDecoration(
                            color: widget.remainingDays! > 1
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              widget.remainingDays! > 1 ? 'Active ' : 'Expired',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            memberProfileDetialsBottomSheet(
                                context,
                                widget.memberDetails,
                                widget.membersKey,
                                widget.remainingDays.toString(),
                                widget.booksInHand
                                );
                          },
                          child: Container(
                            width: 100,
                            height: 28,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                'Details',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              top: -12,
              right: -8,
              child: MemberProfileOptionMenu(
                  account: widget.memberDetails,
                  index: widget.membersKey,
                  box: Hive.box<MemberClass>('members'),
                  booksInHand: widget.booksInHand,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
