import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../global_files/Colors.dart';

CustomColors color = CustomColors();

class Helpers {
  TextStyle mainHeading = GoogleFonts.arvo();

  ///--> The below widget functions are used in approvals screen <--///



  showInfoAlert(BuildContext context, String msg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Info...',
      text: msg,
    );
  }

  showQuickAlert(BuildContext context, String msg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Alert',
      text: msg,
    );
  }

  showErrorAlert(BuildContext context, String msg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Warning',
      text: msg,
    );
  }

  showConfirmationAlert(BuildContext context, String msg,
      void Function() onConfirm, void Function() onCancel) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: msg,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onCancelBtnTap: onCancel,
      onConfirmBtnTap: onConfirm,
    );
  }
}

///------------------------------------------> The End <------------------------------------------///
