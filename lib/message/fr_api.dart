import 'dart:typed_data';
import 'package:flutter_kneron_fr/comport/com_port.dart';
import 'package:flutter_kneron_fr/message/fr_kid_message.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

bool sendVersion(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x30, 0, 0, 0];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  sp = serialPort;

  return true;
}

bool sendPowerDown(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0xED, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  serialPort!.write(tx);

  return true;
}

bool sendGetStatus(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x11, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendReset(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x10, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendDeviceInfo(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0xCB, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendDelAllUser(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x21, 0x00, 0x00, 0x00];
  txBuf[5] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendVerify(BuildContext context, SerialPort? serialPort) {
  List<int> txBuf = [0xEF, 0xAA, 0x12, 0x00, 0x02, 0x00, 0x10, 0x00];
  txBuf[7] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendEnroll(BuildContext context, SerialPort? serialPort, String userName,
    bool bAdmin, int faceDir) {
  List<int> txBuf = [
    0xEF,
    0xAA,
    0x13,
    0x00,
    0x23,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  txBuf[5] = bAdmin ? 1 : 0;

  List<int> name = List<int>.filled(32, 0);
  name = utils.stringToListInt(userName);
  for (int i = 0; i < name.length; i++) {
    txBuf[i + 6] = name[i];
  }
  // txBuf[38] = FACE_DIRECTION_LEFT;
  txBuf[38] = faceDir;
  txBuf[39] = 0x14;
  txBuf[40] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendEnrollEx(BuildContext context, int faceDir) {
  List<int> txBuf = [
    0xEF,
    0xAA,
    0x13,
    0x00,
    0x23,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  txBuf[5] = m_admin ? 1 : 0;

  List<int> name = List<int>.filled(32, 0);
  name = utils.stringToListInt(m_userName);
  for (int i = 0; i < name.length; i++) {
    txBuf[i + 6] = name[i];
  }
  // txBuf[38] = FACE_DIRECTION_LEFT;
  txBuf[38] = faceDir;
  txBuf[39] = 0x14;
  txBuf[40] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  sp!.write(tx);

  return true;
}

bool sendEnrollSingle(BuildContext context, SerialPort? serialPort,
    String userName, bool bAdmin) {
  List<int> txBuf = [
    0xEF,
    0xAA,
    0x1D,
    0x00,
    0x23,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  txBuf[5] = bAdmin ? 1 : 0;

  List<int> name = List<int>.filled(32, 0);
  name = utils.stringToListInt(userName);
  for (int i = 0; i < name.length; i++) {
    txBuf[i + 6] = name[i];
  }
  // txBuf[38] = FACE_DIRECTION_LEFT;
  txBuf[38] = FACE_DIRECTION_MIDDLE;
  txBuf[39] = 0x14;
  txBuf[40] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendDbExportRequest(
    BuildContext context, SerialPort? serialPort, int userId) {
  List<int> txBuf = [0xEF, 0xAA, 0x7C, 0x00, 0x02, 0x00, 0x00, 0x00];

  txBuf[5] = userId >> 8;
  txBuf[6] = userId & 0xFF;

  txBuf[7] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendDbImportRequest(BuildContext context, SerialPort? serialPort,
    int userId, int size, int mode) {
  List<int> txBuf = [
    0xEF,
    0xAA,
    0x7E,
    0x00,
    0x07,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00
  ];

  txBuf[5] = userId >> 8;
  txBuf[6] = userId & 0xFF;

  txBuf[7] = size << 24;
  txBuf[8] = size << 16;
  txBuf[9] = size << 8;
  txBuf[10] = size & 0xFF;

  txBuf[11] = mode;

  txBuf[12] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  // for (int i = 0; i < tx.length; i++) {
  //   utils.log("Tx [$i] : 0x${tx[i].toRadixString(16)}");
  // }

  serialPort!.write(tx);

  return true;
}

bool sendUploadData(BuildContext context, SerialPort? serialPort, int offset,
    int size, int dataType) {
  List<int> txBuf = [
    0xEF,
    0xAA,
    0x7D,
    0x00,
    0x09,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00
  ];

  txBuf[5] = (offset & 0xFF000000) >> 24;
  txBuf[6] = (offset & 0x00FF0000) >> 16;
  txBuf[7] = (offset & 0x0000FF00) >> 8;
  txBuf[8] = (offset & 0x000000FF);

  txBuf[9] = (size & 0xFF000000) >> 24;
  txBuf[10] = (size & 0x00FF0000) >> 16;
  txBuf[11] = (size & 0x0000FF00) >> 8;
  txBuf[12] = (size & 0x000000FF);

  txBuf[13] = dataType;

  txBuf[14] = getParity(txBuf, txBuf.length);

  var tx = Uint8List.fromList(txBuf);

  printSendData(tx, tx.length);

  utils.log("request upload data offset $offset, size $size");

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

void printSendData(Uint8List tx, int len) {
  String str = "Tx => ";

  for (int i = 0; i < len; i++) {
    str += "${tx[i].toRadixString(16)}, ";
  }
  utils.log(str);
}
