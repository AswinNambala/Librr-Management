import 'package:flutter/material.dart';

class SearchTextFormField extends StatefulWidget {
  final TextEditingController searchString;
  final IconData? suffixicons;
  final VoidCallback? suffixOnPress;
  final String? hintText;
  const SearchTextFormField(
      {super.key,
      required this.searchString,
      this.suffixicons,
      this.hintText,
      this.suffixOnPress});

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.searchString,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          prefixIcon: const Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          suffixIcon: widget.suffixicons != null
              ? IconButton(
                  onPressed: widget.suffixOnPress,
                  icon: Icon(
                    widget.suffixicons,
                    color: Colors.white,
                  ))
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}
