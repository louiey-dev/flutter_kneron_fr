import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/comport/com_port.dart';
import 'package:flutter_kneron_fr/message/fr_msg.dart';
import 'package:flutter_kneron_fr/message/fr_nid_msg.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';

class NoteData {
  int nid = 0;
  List<int> data = [];
}

bool clearNoteMsg() {
  s_msg_note_data.data.clear();
  s_msg_note_data.nid = 0;

  return true;
}

NoteData s_msg_note_data = NoteData();

bool parseNote(BuildContext context) {
  s_msg_note_data.nid = rx.data[5];

  for (int i = 0; i < (rx.length - 2); i++) {
    s_msg_note_data.data.add(rx.data[i + 7]);
  }
  // utils.log(
  //     "[parseNote] resp 0x${rx.response.toRadixString(16)}, ${s_msg_note_data.data.length}, 0x${s_msg_note_data.nid.toRadixString(16)}");

  switch (s_msg_note_data.nid) {
    case NID_READY:
      receiveDataList.add(utils.stringToUint8List("Module is ready"));
      utils.showSnackbar(context, "Module is Ready");
      utils.log("Module is Ready");
      break;

    case NID_FACE_STATE: // 8 params and 2bytes each
      try {
        int state = s_msg_note_data.data[0] << 8 | s_msg_note_data.data[1];
        // int left = s_msg_note_data.data[2] << 8 | s_msg_note_data.data[3];
        // int top = s_msg_note_data.data[4] << 8 | s_msg_note_data.data[5];
        // int right = s_msg_note_data.data[6] << 8 | s_msg_note_data.data[7];
        // int bottom = s_msg_note_data.data[8] << 8 | s_msg_note_data.data[9];
        // int yaw = s_msg_note_data.data[10] << 8 | s_msg_note_data.data[11];
        // int pitch = s_msg_note_data.data[12] << 8 | s_msg_note_data.data[13];
        // int roll = s_msg_note_data.data[14] << 8 | s_msg_note_data.data[15];
        String faceStatus = "Note => ${noteGetFaceStatus(state)}";
        receiveDataList.add(utils.stringToUint8List(faceStatus));
        utils.log(faceStatus);
        // utils.showSnackbar(context, faceStatus);
      } catch (e) {
        utils.showSnackbarError(context, e.toString());
      }

      break;

    case NID_UNKNOWNERROR:
      receiveDataList.add(utils.stringToUint8List("Unknown error"));
      utils.showSnackbar(context, "Unknown error");
      utils.log("Unknown error");
      break;

    case NID_OTA_DONE:
      receiveDataList.add(utils.stringToUint8List("OTA upgrade completed"));
      utils.showSnackbar(context, "OTA upgrade completed");
      break;

    default:
      break;
  }
  clearNoteMsg();
  return true;
}

String noteGetFaceStatus(int state) {
  String str = "";

  switch (state) {
    case 0:
      str = "Face normal";
      break;

    case 1:
      str = "Face not detected";
      break;

    case 2:
      str =
          "Face is too close to the top edge of the picture and could not be recorded";
      break;

    case 3:
      str =
          "Face is too close to the bottom edge of the picture, failed to record";
      break;

    case 4:
      str =
          "Face is too close to the left edge of the picture, failed to record";
      break;

    case 5:
      str = "Face too close to the right edge of the picture, failed to record";
      break;

    case 6:
      str = "Face too far away, failed to record";
      break;

    case 7:
      str = "Face too close, failed to record";
      break;

    case 8:
      str = "Eyebrows blocked";
      break;

    case 9:
      str = "Eyes blocked";
      break;

    case 10:
      str = "Face blocked";
      break;

    case 11:
      str = "Wrong face orientation";
      break;

    case 12:
      str = "Eyes open detected in eyes closed mode";
      break;

    case 13:
      str = "Eye closed state";
      break;

    case 14:
      str =
          "Unable to determine eye opening and closing status in closed-eye mode detection";
      break;

    default:
      str = "State Error...$state";
      break;
  }

  return str;
}
