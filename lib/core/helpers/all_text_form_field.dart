import 'package:flutter/material.dart';

class AllTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChange;

  const AllTextFormField({
    super.key,
    required this.controller,
    this.hint = "",
    this.validator,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.suffixIcon,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 0.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white.withOpacity(0.4)),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.black,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
