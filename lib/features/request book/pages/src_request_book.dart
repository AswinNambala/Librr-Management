import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/books/widgets/book_add_section.dart';
import 'package:librrr_management/features/request%20book/provider/request_book_provider.dart';
import 'package:librrr_management/features/request%20book/pages/src_list_of_request_book.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class RequestBookScreen extends ConsumerStatefulWidget {
  const RequestBookScreen({super.key});

  @override
  ConsumerState<RequestBookScreen> createState() => _RequestBookScreenState();
}

class _RequestBookScreenState extends ConsumerState<RequestBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController rBookName = TextEditingController();
  final TextEditingController rAuthorName = TextEditingController();
  final TextEditingController rLanguage = TextEditingController();

  @override
  void dispose() {
    rBookName.dispose();
    rAuthorName.dispose();
    rLanguage.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final rbooksInfo = RequestBookClass(
      rBookName.text.trim(),
      rAuthorName.text.trim(),
      rLanguage.text.trim(),
    );

    final error = await ref.read(requestedBooksListProvider.notifier).addRequest(rbooksInfo);
    if (!mounted) return;

    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'Successfully added');
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, anim1, anim2) => const ListOfRequestBook(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(appBarTitle: 'Request Book', navToBorrow: false),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 700;
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AllTextFormField(
                  controller: rBookName,
                  hint: 'Enter book name',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'field is empty';
                    if (value.length < 3) return 'Atleast 3 letter needed';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: rAuthorName,
                  hint: 'Enter author name',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'field is empty';
                    if (value.length < 3) return 'Atleast 3 letter needed';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: rLanguage,
                  hint: 'Enter book language',
                  readOnly: true, 
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Select a language';
                    return null;
                  },
                  onTap: () => addBookSelectLanguage(context, (language) {
                    setState(() {
                      rLanguage.text = language;
                    });
                  }),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: isWeb ? const Size(400, 50) : const Size(170, 40),
                            backgroundColor: Colors.black.withValues(alpha: 0.8)),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: isWeb ? const Size(400, 50) : const Size(140, 30),
                            backgroundColor: Colors.red.withValues(alpha: 0.8)),
                        onPressed: _onSave,
                        child: const Text('save', style: TextStyle(fontSize: 24, color: Colors.white)),
                        ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}