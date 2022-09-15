import 'package:flutter/material.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  TodoListField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.suffixIconButton,
    this.controller,
    this.validator,
    this.focusNode,
  })  : assert(obscureText == true ? suffixIconButton == null : true,
            'obscureText não pode ser enviado em conjunto com suffixIconButton'),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: obscureTextVN,
        builder: (_, obscureTextValue, __) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            validator: validator,
            obscureText: obscureTextValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              labelText: label,
              labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
              isDense: true,
              suffixIcon: suffixIconButton ??
                  (obscureText == true
                      ? IconButton(
                          onPressed: () {
                            obscureTextVN.value = !obscureTextValue;
                          },
                          icon: Icon(
                            obscureTextValue
                                ? Icons.remove_red_eye
                                : Icons.no_encryption_gmailerrorred_outlined,
                          ),
                        )
                      : null),
            ),
          );
        });
  }
}
