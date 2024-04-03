import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/comport/com_port.dart';
import 'package:flutter_kneron_fr/message/fr_kid_message.dart';
import 'package:flutter_kneron_fr/message/fr_msg.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';

class ReplyData {
  int kid = 0;
  int result = 0;
  List<int> data = [];
}

ReplyData s_msg_reply_data = ReplyData();

bool parseReply(BuildContext context) {
  s_msg_reply_data.kid = rx.data[5];
  s_msg_reply_data.result = rx.data[6];

  for (int i = 0; i < (rx.length - 2); i++) {
    s_msg_reply_data.data.add(rx.data[i + 7]);
  }
  utils.log(
      "[parseReply] resp 0x${rx.response.toRadixString(16)}, ${rx.length}, 0x${s_msg_reply_data.kid.toRadixString(16)}");
  switch (s_msg_reply_data.kid) {
    case KID_GET_VERSION:
      String verStr = utils.listIntToString(s_msg_reply_data.data);
      utils.log("Version : $verStr");
      utils.showSnackbar(context, verStr);
      receiveDataList.add(Uint8List.fromList(s_msg_reply_data.data));
      break;

    case KID_SOFT_RESET:
      utils.showSnackbar(context, "Soft Reset OK");
      break;

    case KID_RESET:
      utils.showSnackbar(context, "Reset OK");
      break;

    case KID_GET_STATUS:
      String strStatus = "";
      switch (s_msg_reply_data.data[0]) {
        case 0:
          strStatus = "Idle Status";
          break;

        case 1:
          strStatus = "Busy Status";
          break;

        case 2:
          strStatus = "Error Status";
          break;

        case 3:
          strStatus = "Invalid Status";
          break;

        default:
          strStatus = "Default Error";
          break;
      }
      utils.showSnackbar(context, strStatus);
      break;

    case KID_VERIFY:
      int userId = s_msg_reply_data.data[0] << 8 | s_msg_reply_data.data[1];
      String userName = String.fromCharCodes(s_msg_reply_data.data, 2, 32);
      userName = utils.removeNullFromString(userName);
      int admin = s_msg_reply_data.data[34];
      int eyeUnlock = s_msg_reply_data.data[35];
      receiveDataList.add(utils.stringToUint8List(
          "id $userId, name $userName, admin $admin, eye $eyeUnlock"));
      utils.showSnackbar(
          context, "id $userId, $userName, admin $admin, eye $eyeUnlock");
      break;

    case KID_ENROLL:
      int enrollId = s_msg_reply_data.data[0] << 8 | s_msg_reply_data.data[1];
      int faceDir = s_msg_reply_data.data[2];
      receiveDataList
          .add(utils.stringToUint8List("Enroll id $enrollId, dir $faceDir"));
      break;

    case KID_KN_DEVICE_INF:
      utils.showSnackbar(context, "Device information OK");
      break;

    case KID_POWERDOWN:
      receiveDataList.add(utils.stringToUint8List("Power down ok"));
      utils.showSnackbar(context, "Power Down OK");
      break;

    default:
      break;
  }
  clearReplyData();
  return true;
}

bool clearReplyData() {
  s_msg_reply_data.kid = s_msg_reply_data.result = 0;
  s_msg_reply_data.data.clear();
  return true;
}
