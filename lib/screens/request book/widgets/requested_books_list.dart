import 'package:flutter/material.dart';
import 'package:librrr_management/controllers/common%20functions/request_book_utils.dart';
import 'package:librrr_management/models/requested_books/request_book_class.dart';

// requested books list page grid view design
Widget requestedBooksBuildGridViewBuilder(
    BuildContext context, RequestBookClass bookInfo, int index) {
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return RequestBookUtils.requestedBooksAddtoBooksClass(
                context, index, bookInfo);
          });
    },
    child: Container(
      margin: const EdgeInsets.all(8),
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
              child: const Icon(Icons.book, size: 30),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 5, left: 8, right: 8, top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookInfo.rBookName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(bookInfo.rAuthorName,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(bookInfo.rLanguage,
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

// requested books listing section design
class RequestedBooksListingSection extends StatefulWidget {
  final List<RequestBookClass> fliteredRequestedBooks;
  const RequestedBooksListingSection(
      {super.key, required this.fliteredRequestedBooks});

  @override
  State<RequestedBooksListingSection> createState() =>
      _RequestedBooksListingSectionState();
}

class _RequestedBooksListingSectionState
    extends State<RequestedBooksListingSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.fliteredRequestedBooks.length,
        itemBuilder: (context, index) {
          final bookData = widget.fliteredRequestedBooks[index];
          return Card(
            color: Theme.of(context).cardTheme.color,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RequestBookUtils.requestedBooksAddtoBooksClass(
                          context, index, bookData);
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: const CircleAvatar(
                child: Icon(
                  Icons.book,
                  color: Colors.black,
                ),
              ),
              title: Text(
                bookData.rBookName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookData.rAuthorName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    bookData.rLanguage,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          );
        });
  }
}
