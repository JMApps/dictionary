import 'package:flutter/material.dart';

import '../../../../core/strings/app_constraints.dart';

class FormsText extends StatelessWidget {
  const FormsText({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (var form in ['мн.', 'дв.', 'ж.', 'м.', 'стр.', 'см.', '='])
            if (content.contains(form))
              TextSpan(
                text: '$form ',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: AppConstraints.fontSFProRegular,
                ),
              ),
          TextSpan(
            text: content.replaceAll(RegExp('мн.|дв.|ж.|м.|стр.|см.ّ|=|ّّّ'), ''),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontFamily: AppConstraints.fontUthmanic,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
