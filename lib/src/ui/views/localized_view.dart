import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef LocalizedBuilder = Widget Function(BuildContext, AppLocalizations);
class LocalizedView extends StatelessWidget {
  final LocalizedBuilder builder;
  const LocalizedView({this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, AppLocalizations.of(context));
  }
}
