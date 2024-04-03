import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/utils.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

bool sendVersion(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x30, 0, 0, 0];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  for (int i = 0; i < tx.length; i++) {
    debugPrint("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  }

  serialPort!.write(tx);

  return true;
}

bool sendPowerDown(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0xED, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  for (int i = 0; i < tx.length; i++) {
    debugPrint("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  }

  serialPort!.write(tx);

  return true;
}

int getParity(List<int> buf, int len) {
  int parity = 0;

  for (int i = 2; i < (len - 1); i++) {
    parity ^= buf[i];
  }
  return parity;
}
