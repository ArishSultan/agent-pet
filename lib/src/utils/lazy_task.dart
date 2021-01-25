import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedantic/pedantic.dart';


Future<dynamic> performLazyTask(
  BuildContext context,
  Future<dynamic> Function() task, {
  String message = 'Please Wait',
  bool persistent = true,
}) async {
  if (persistent) {
    unawaited(openLoadingDialog(context, message));
  } else {
    unawaited(openLoadingDialog(context, message));
  }

  final result = await task();
  Navigator.of(context).pop();

  return result;
}
