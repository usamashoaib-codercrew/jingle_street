import 'package:flutter/material.dart';

import '../../res/app_theme.dart';
import 'app_text.dart';

class SettingScreenRow extends StatelessWidget {
  final text;
  final Icon;
  const SettingScreenRow({super.key, this.text, this.Icon});

  @override
  Widget build(BuildContext context) {
    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text,
                          size: 14,
                          color: AppTheme.error,
                        ),
                        Icon(
                          Icon,
                          color: AppTheme.error,
                        )
                      ],
                    );
  }
}