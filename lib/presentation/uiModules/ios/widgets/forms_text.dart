import 'package:flutter/cupertino.dart';

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
          for (var form in ['мн.', 'дв.', 'ж.', 'м.', 'стр.', 'см.'])
            if (content.contains(form))
              TextSpan(
                text: '$form ',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                  fontFamily: AppConstraints.fontSFProRegular,
                ),
              ),
          TextSpan(
            text: content.replaceAll(RegExp('мн.|дв.|ж.|м.|стр.|см.ّّّّ'), ''),
            style: const TextStyle(
              fontSize: 22,
              color: CupertinoColors.systemGrey,
              fontFamily: AppConstraints.fontUthmanic,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
