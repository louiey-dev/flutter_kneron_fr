import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:flutter_kneron_fr/comport/com_port.dart';
import 'package:flutter_kneron_fr/message/fr_kid_message.dart';
import 'package:flutter_kneron_fr/message/fr_note_msg.dart';
import 'package:flutter_kneron_fr/message/fr_reply_msg.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';

const int headerLen = 5;
const int headerSyncHigh = 0xEF;
const int headerSyncLow = 0xAA;
const int msgInfoLen = 6;

class RxMsg {
  List<int> data = [];
  // bool bIng = false;
  bool isHeaderFound = false;
  int length = 0;
  int response = 0;
  int offset = 0;
}

bool parseMsg(BuildContext context) {
  // utils
  //     .log("[parseMsg] resp 0x${rx.response.toRadixString(16)}, ${rx.length}]");

  switch (rx.response) {
    case RID_REPLY:
      parseReply(context);
      break;

    case RID_NOTE:
      parseNote(context);
      break;

    case RID_IMAGE:
      break;

    case RID_ERROR:
      break;

    default:
      break;
  }
  clearRxMsg();
  return true;
}

bool clearRxMsg() {
  rx.data.clear();
  rx.isHeaderFound = false;
  rx.length = rx.response = rx.offset = 0;

  return true;
}

RxMsg rx = RxMsg();

bool makeMessage(BuildContext context, Uint8List buf, int len) {
  // List<int> b = List.from(buf);
  rx.data.addAll(buf);
  rx.offset += len;
  utils.log("[makeMessage] $len");

  if (rx.isHeaderFound == false) {
    if (rx.data.length >= headerLen) {
      // looking for sync
      if (headerFind() == true) {
        rx.isHeaderFound = true;
        rx.response = rx.data[2];
        rx.length = rx.data[3] << 8 | rx.data[4];

        if (rx.data.length == (rx.length + msgInfoLen)) {
          // we got all packets here
          parseMsg(context);
          return true;
        }
      } else {
        utils.log(
            "[makeMessage] hdr finding ${rx.isHeaderFound}, ${rx.response}, ${rx.length}, ${rx.offset}");
      }
    } else {
      utils.log(
          "[makeMessage] rcv hdr ${rx.isHeaderFound}, ${rx.response}, ${rx.length}, ${rx.offset}");
    }
  } else {
    // finish packet receive here
    if (rx.data.length == (rx.length + msgInfoLen)) {
      // we got all packets here
      parseMsg(context);
      return true;
    } else if (rx.data.length < rx.length) {
      // still needs to buffer
      utils.log(
          "[makeMessage] rcv buffer ${rx.isHeaderFound}, ${rx.response}, ${rx.length}, ${rx.offset}");
    } else {
      utils.log(
          "[makeMessage] rcv error ${rx.isHeaderFound}, ${rx.response}, ${rx.length}, ${rx.offset}");
    }
  }

  return false;
}

bool headerFind() {
  int idx = 0;
  while (rx.data.length >= idx) {
    if (rx.data[idx] == headerSyncHigh) {
      if (rx.data[idx + 1] == headerSyncLow) {
        // found magic packet here
        if (idx != 0) {
          // move memory so adjust start packet
          for (int i = 0; i < idx; i++) {
            rx.data.removeAt(i);
          }
          rx.offset -= idx;
        }

        return true;
      } else {
        idx++;
      }
    }
  }
  return false;
}
