import 'package:flutter/material.dart';
import 'package:librrr_management/core/const_value.dart';


// add books select language
Future<void> addBookSelectLanguage(
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



// add books select genre sections
   Future<void> addBookSelectGenre(
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

  // book fliter sections of list of books
   Future<Map<String, String?>?> fliterBookByGenre(
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