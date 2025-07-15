import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/models/members/members_class.dart';
import 'package:librrr_management/screens/members/src_member_profile.dart';
import 'package:librrr_management/utilities/const_value.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/snackbar_for_all.dart';

class BooksUtils {
  // every functions for add book
  // add books page pick image photo from gallery 
  static Future<void> addBookPickBookImage(
      BuildContext context, Function(Uint8List?) onPicked) async {
    final image = ImagePicker();
    final pickedFile = await image.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final byte = await pickedFile.readAsBytes();
      onPicked(byte);
      SnackBarForAll.showSuccess(context, 'Image added successfully');
    } else {
      SnackBarForAll.showError(context, 'Failed to add image');
    }
  }

// add books select language
  static Future<void> addBookSelectLanguage(
      BuildContext context, Function(String) onSelected) async {
    bool showTextField = false;
    final TextEditingController langController = TextEditingController();

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: bookLanguage.length + 1,
                        itemBuilder: (context, index) {
                          if (index == bookLanguage.length) {
                            return ListTile(
                              leading: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Add New Language",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onTap: () {
                                setModalState(() {
                                  showTextField = true;
                                });
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                bookLanguage[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                onSelected(bookLanguage[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                    if (showTextField)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: langController,
                              decoration: InputDecoration(
                                labelText: 'Enter New Language',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                final entered = langController.text.trim();
                                if (entered.isNotEmpty) {
                                  bookLanguage.add(entered);
                                  Navigator.pop(context);
                                  onSelected(entered);
                                }
                              },
                              child: Text(
                                "Save",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// generate book id as random number
  static Future<void> addBookIdGenerate(
      BuildContext context, Function(String) bookidGenerate) async {
    final String bookId =
        'R${Random().nextInt(9)}SH${Random().nextInt(20)}BOK${Random().nextInt(999)}';
    bookidGenerate(bookId);
  }

 

// add books select genre sections
  static Future<void> addBookSelectGenre(
      BuildContext context, Function(String) onSelected) async {
   
    bool showTextField = false;
    final TextEditingController genreController = TextEditingController();

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: booksGenres.length + 1,
                        itemBuilder: (context, index) {
                          if (index == booksGenres.length) {
                            return ListTile(
                              leading: const Icon(Icons.add, color: Colors.white,),
                              title:  Text("Add New Genre", style: Theme.of(context).textTheme.bodyLarge),
                              onTap: () {
                                setModalState(() {
                                  showTextField = true;
                                });
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                booksGenres[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                onSelected(booksGenres[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                    if (showTextField)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: genreController,
                              decoration:  InputDecoration(
                                labelText: 'Enter New Genre',
                                labelStyle: Theme.of(context).textTheme.bodyLarge,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {
                                final entered = genreController.text.trim();
                                if (entered.isNotEmpty) {
                                  booksGenres.add(entered);
                                  Navigator.pop(context);
                                  onSelected(entered);
                                }
                              },
                              child:  Text("Save", style: Theme.of(context).textTheme.bodyLarge,),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



// every functions for editing book

// edit books page pick image from gallery if need to change
  static Future<void> editBookImage({
    required BuildContext context,
    required Uint8List? currentImage,
    required int bookIndex,
    required BooksClass bookInfo,
    required Function(Uint8List?) onImageUpdated,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Options'),
        actions: [
          if (currentImage == null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Add'),
            ),
          if (currentImage != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Edit'),
            ),
          if (currentImage != null)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final box = Hive.box<BooksClass>('booksDetials');
      bookInfo.imageBook = null;
      await box.put(bookIndex, bookInfo);
      onImageUpdated(null);
    } else {
      final image = ImagePicker();
      final pickedFile = await image.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final byte = await pickedFile.readAsBytes();
        bookInfo.imageBook = byte;
        onImageUpdated(byte);
        SnackBarForAll.showSuccess(context, 'Image updated');
      }
    }
  }

  // book fliter sections of list of books
  static Future<Map<String, String?>?> fliterBookByGenre(
      BuildContext context) async {
    String? selectedLanguage;
    String? selectedGenre;
    

    return await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filter Books',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  items: bookLanguage
                      .map((lang) =>
                          DropdownMenuItem(value: lang, child: Text(lang)))
                      .toList(),
                  decoration: InputDecoration(
                      labelText: 'Language',
                      labelStyle: Theme.of(context).textTheme.bodyMedium),
                  onChanged: (value) =>
                      setState(() => selectedLanguage = value),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedGenre,
                  items: booksGenres
                      .map((gen) =>
                          DropdownMenuItem(value: gen, child: Text(gen)))
                      .toList(),
                  decoration: InputDecoration(
                      labelText: 'Genre',
                      labelStyle: Theme.of(context).textTheme.bodyMedium),
                  onChanged: (value) => setState(() => selectedGenre = value),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedLanguage = null;
                          selectedGenre = null;
                        });
                      },
                      child: Text("Clear",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.8)),
                      onPressed: () {
                        Navigator.pop(context, {
                          'language': selectedLanguage,
                          'genre': selectedGenre,
                        });
                      },
                      child: Text(
                        "Apply Filter",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

 
// navigate to members profile page function
  static void booksOpenMembersProfile(String membersId, BuildContext context) {
    final box = Hive.box<MemberClass>('members');
    final int index = box.values
        .toList()
        .indexWhere((member) => member.mMembersId == membersId);
    if (index != -1) {
      final MemberClass selectedMembers = box.getAt(index)!;
      navigateTo(
          MemebersProfileScreen(
              memberDetails: selectedMembers, membersKey: index),
          context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member not found')),
      );
    }
  }
}
