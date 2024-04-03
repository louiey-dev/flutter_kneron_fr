import 'dart:typed_data';

import 'package:flutter_kneron_fr/utils.dart';

class RxMsg {
  List<int> data = [];
  bool bIng = false;
  bool isSyncFound = false;
  int length = 0;
  int response = 0;
  int offset = 0;
}

bool parseMsg() {
  return true;
}

bool clearRxMsg() {
  rx.data.clear();
  rx.isSyncFound = false;
  rx.length = rx.response = rx.offset = 0;

  return true;
}

RxMsg rx = RxMsg();

bool makeMessage(Uint8List buf, int len) {
  List<int> b = List.from(buf);

  if (rx.isSyncFound == false) {
    if ((len >= 5) && (rx.length == 0)) {
      // got header information at first packet
      if ((b[0] == 0xEF) && (b[1] == 0xAA)) {
        rx.isSyncFound = true;
        rx.response = b[2];
        rx.length = b[3] << 8 | b[4];
        rx.offset += len;

        rx.data.addAll(b);

        if (rx.offset == rx.length) {
          parseMsg();
        }
        log("sync found, ${rx.isSyncFound}, ${rx.length}, ${rx.offset}, $len");
      } else {
        log("sync error, ${rx.isSyncFound}, ${rx.length}, ${rx.offset}, $len");
      }
    } else {
      rx.data.addAll(b);
      rx.offset += len;

      if (rx.offset >= 5) {
        // here we got header packet
        if ((rx.data[0] == 0xEF) && (rx.data[1] == 0xAA)) {
          rx.isSyncFound = true;
          rx.response = rx.data[2];
          rx.length = rx.data[3] << 8 | rx.data[4];
          rx.offset += len;

          rx.data.addAll(b);

          if (rx.offset == rx.length) {
            parseMsg();
          }
          log(rx.toString());
        }
      }

      log("partial buffering, ${rx.isSyncFound}, ${rx.length}, ${rx.offset}, $len");
    }
  } else {
    rx.data.addAll(b);
    rx.offset += len;

    if (rx.offset == rx.length) {
      parseMsg();
    }
    log("filling, ${rx.isSyncFound}, ${rx.length}, ${rx.offset}, $len");
  }

  return true;
}
