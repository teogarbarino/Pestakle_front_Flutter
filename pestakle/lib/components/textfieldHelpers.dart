import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget pour un TextField classique (texte)
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final TextStyle? style;
  final InputBorder? border;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.style,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: border ?? const OutlineInputBorder(),
      ),
    );
  }
}

/// Widget pour un TextField destiné aux chiffres
class CustomNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final TextStyle? style;
  final InputBorder? border;

  const CustomNumberField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.style,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir des formatters par défaut pour n'autoriser que les chiffres,
    // si aucun n'est passé en argument.
    final defaultFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
    ];

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: obscureText,
      inputFormatters: inputFormatters ?? defaultFormatters,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: border ?? const OutlineInputBorder(),
      ),
    );
  }
}
