import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  FormInput(
      {super.key,
      required this.hintText,
      this.errorText,
      required this.onChanged,
      this.isPassword = false,
      this.validator});
  final String hintText;
  final String? errorText;
  final Function(String) onChanged;
  Function(String)? validator;
  bool isPassword = false;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final TextEditingController controller = TextEditingController();

  bool isError = false;
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isError ? Colors.red : Colors.blueAccent.shade700,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              focusNode: focusNode,
              obscureText: widget.isPassword,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
              controller: controller,
              onChanged: (value) {
                if (widget.validator != null) {
                  if (widget.validator!(value)) {
                    setState(() {
                      isError = false;
                    });
                  } else {
                    setState(() {
                      isError = true;
                    });
                  }
                }
                widget.onChanged(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        if (isError) const SizedBox(height: 5),
        if (isError)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              widget.errorText ?? "Neispravan unos",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.red),
              textAlign: TextAlign.left,
            ),
          ),
      ],
    );
  }
}
