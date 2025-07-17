import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/pages/src_member_profile.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

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


// generate book id as random number
  static Future<void> addBookIdGenerate(
      BuildContext context, Function(String) bookidGenerate) async {
    final String bookId =
        'R${Random().nextInt(9)}SH${Random().nextInt(20)}BOK${Random().nextInt(999)}';
    bookidGenerate(bookId);
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
