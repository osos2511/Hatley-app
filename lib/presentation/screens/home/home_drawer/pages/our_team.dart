import 'package:flutter/material.dart';
import 'package:hatley/l10n/app_localizations.dart';

class OurTeam extends StatelessWidget {
  const OurTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.our_team);
  }
}
