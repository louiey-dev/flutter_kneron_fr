import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/message/fr_api.dart';
import 'package:flutter_kneron_fr/message/fr_kid_message.dart';
import 'package:flutter_kneron_fr/message/fr_msg.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';
import 'package:flutter_kneron_fr/widget/my_widget.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:cp949_codec/cp949_codec.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool m_admin = false;
String m_userName = "";
SerialPort? sp;

final printProvider = Provider<String>((ref) {
  return "";
});

List<Uint8List> receiveDataList = [];

class ComPort extends StatefulWidget {
  const ComPort({super.key});

  @override
  State<ComPort> createState() => _ComPortState();
}

class _ComPortState extends State<ComPort> {
  List<SerialPort> portList = [];

  final textInputCtrl = TextEditingController();
  final adminInputCtrl = TextEditingController();
  final userNameInputCtrl = TextEditingController();

  bool _adminChecked = true;

  bool _middleFace = true;
  bool _leftFace = false;
  bool _rightFace = false;
  bool _upFace = false;
  bool _downFace = false;

  int _faceDir = FACE_DIRECTION_MIDDLE;

  List<int> baudRate = [3800, 9600, 115200, 1500000];
  int menuBaudrate = 115200;
  String openButtonText = 'N/A';

  @override
  void initState() {
    super.initState();
    _initPort();
  }

  @override
  void dispose() {
    if (sp != null) sp?.close();

    super.dispose();
  }

  _initPort() {
    setState(() {
      var i = 0;

      portList.clear();

      for (final name in SerialPort.availablePorts) {
        final sp = SerialPort(name);
        if (kDebugMode) {
          print('${++i}) $name');
          print('\tDescription: ${cp949.decodeString(sp.description ?? '')}');
          print('\tManufacturer: ${sp.manufacturer}');
          print('\tSerial Number: ${sp.serialNumber}');
          print('\tProduct ID: 0x${sp.productId?.toRadixString(16) ?? 00}');
          print('\tVendor ID: 0x${sp.vendorId?.toRadixString(16) ?? 00}');
        }
        portList.add(sp);
      }
      if (portList.isNotEmpty) {
        sp = portList.first;
      }
    });
  }

  void changedDropDownItem(SerialPort sps) {
    setState(() {
      sp = sps;
    });
  }

  @override
  Widget build(BuildContext context) {
    openButtonText = sp == null
        ? 'N/A'
        : sp!.isOpen
            ? 'Close'
            : 'Open';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Kneron FR Module"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            // const SizedBox(width: 10),
            _comPort(),
            _commandList(),
            _userInputSend(),
            _userRcvScreen()
          ],
        ),
      ),
    );
  }

  _comPort() {
    return Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton(
              value: sp,
              items: portList.map((item) {
                return DropdownMenuItem(
                    value: item, child: Text("${item.name}"));
                // "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  changedDropDownItem(e as SerialPort);
                });
              },
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: DropdownButton(
              value: menuBaudrate,
              items: baudRate.map((value) {
                return DropdownMenuItem(
                    value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  menuBaudrate = e!;
                  utils.showSnackbar(context, menuBaudrate.toString());
                  utils.log("Baudrate set to $menuBaudrate");
                });
              },
            ),
          ),
          const SizedBox(width: 20.0),
          ExpElevatedButton(
            onPressed: () {
              _initPort();
            },
            title: "COM",
          ),
          const SizedBox(width: 20.0),
          ExpElevatedButton(
            onPressed: () {
              if (sp == null) {
                return;
              }
              if (sp!.isOpen) {
                sp!.close();
                utils.log('${sp!.name} closed!');
              } else {
                if (sp!.open(mode: SerialPortMode.readWrite)) {
                  SerialPortConfig config = sp!.config;
                  // https://www.sigrok.org/api/libserialport/0.1.1/a00007.html#gab14927cf0efee73b59d04a572b688fa0
                  // https://www.sigrok.org/api/libserialport/0.1.1/a00004_source.html
                  // config.baudRate = 115200;
                  config.baudRate = menuBaudrate;
                  config.parity = 0;
                  config.bits = 8;
                  config.cts = 0;
                  config.rts = 0;
                  config.stopBits = 1;
                  config.xonXoff = 0;
                  sp!.config = config;

                  utils.log("baudrate : $menuBaudrate");
                  if (sp!.isOpen) {
                    utils.log('${sp!.name} opened!');
                    utils.showSnackbar(
                        context, "Serial port opened, ${sp!.name}");
                  }
                  final reader = SerialPortReader(sp!);
                  reader.stream.listen((data) {
                    if (makeMessage(context, data, data.length) == true) {
                      setState(() {});
                    }
                    // log('received: ${data.length}, ${String.fromCharCodes(data)}');
                    // receiveDataList.add(data);
                    // setState(() {});
                  }, onError: (error) {
                    if (error is SerialPortError) {
                      utils.log(
                          'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                    }
                  });
                }
              }
              setState(() {});
            },
            title: openButtonText,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  _commandList() {
    return Expanded(
      flex: 0,
      child: Column(
        children: [
          // utils.divider(thickness: 2.0),
          Row(
            children: [
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Power Down",
                onPressed: () {
                  sendPowerDown(context, sp);
                },
              ),
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Verify",
                onPressed: () {
                  sendVerify(context, sp);
                },
              ),
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Get Status",
                onPressed: () {
                  sendGetStatus(context, sp);
                },
              ),
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Reset",
                onPressed: () {
                  sendReset(context, sp);
                  m_userName = userNameInputCtrl.text;
                  m_admin = _adminChecked;
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              ExpElevatedButton(
                  onPressed: () {
                    sendDelAllUser(context, sp);
                  },
                  title: "Del All"),
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Version",
                onPressed: () {
                  sendVersion(context, sp);
                },
              ),
              const SizedBox(width: 10),
              ExpElevatedButton(
                title: "Device Info",
                onPressed: () {
                  sendDeviceInfo(context, sp);
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          // utils.divider(thickness: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              ExpElevatedButton(
                  title: "Enroll Single",
                  onPressed: () {
                    sendEnrollSingle(
                        context, sp, userNameInputCtrl.text, _adminChecked);
                  }),
              const SizedBox(width: 10),
              ExpElevatedButton(
                  title: "Enroll",
                  onPressed: () {
                    sendEnroll(context, sp, userNameInputCtrl.text,
                        _adminChecked, _faceDir);
                  }),
              const SizedBox(width: 10),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    enabled: true,
                    controller: userNameInputCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "input user name here",
                    ),
                  ),
                ),
              ),
              ExpCheckBox(
                  value: _adminChecked,
                  onChange: () {
                    setState(() {
                      _adminChecked = !_adminChecked;
                    });
                    utils.log(
                        "enroll admin ${_adminChecked ? "checked" : "unchecked"}");
                  },
                  title: "admin"),
              const SizedBox(width: 20),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              ExpCheckBox(
                value: _middleFace,
                onChange: () {
                  setState(() {
                    _leftFace = _rightFace = _upFace = _downFace = false;
                    _middleFace = true;
                    _faceDir = FACE_DIRECTION_MIDDLE;
                  });
                  utils.log("enroll middle face checked");
                },
                title: "Mid",
              ),
              const SizedBox(width: 20),
              const SizedBox(width: 20),
              ExpCheckBox(
                  value: _leftFace,
                  onChange: () {
                    setState(() {
                      _middleFace = _rightFace = _upFace = _downFace = false;
                      _leftFace = true;
                      _faceDir = FACE_DIRECTION_LEFT;
                    });
                    utils.log("enroll left face checked");
                  },
                  title: "Left"),
              ExpCheckBox(
                title: "Right",
                value: _rightFace,
                onChange: () {
                  setState(() {
                    _middleFace = _leftFace = _upFace = _downFace = false;
                    _rightFace = true;
                    _faceDir = FACE_DIRECTION_RIGHT;
                  });
                  utils.log("enroll right face checked");
                },
              ),
              const SizedBox(width: 20),
              ExpCheckBox(
                title: "Up",
                value: _upFace,
                onChange: () {
                  setState(() {
                    _middleFace = _leftFace = _rightFace = _downFace = false;
                    _upFace = true;
                    _faceDir = FACE_DIRECTION_UP;
                  });
                  utils.log("enroll up face checked");
                },
              ),
              const SizedBox(width: 20),
              ExpCheckBox(
                title: "Down",
                value: _downFace,
                onChange: () {
                  setState(() {
                    _middleFace = _leftFace = _rightFace = _upFace = false;
                    _downFace = true;
                    _faceDir = FACE_DIRECTION_DOWN;
                  });
                  utils.log("enroll down face checked");
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  _userInputSend() {
    return Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                enabled: (sp != null && sp!.isOpen) ? true : false,
                controller: textInputCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Flexible(
            child: TextButton.icon(
              onPressed: (sp != null && sp!.isOpen)
                  ? () {
                      if (sp!.write(Uint8List.fromList(
                              textInputCtrl.text.codeUnits)) ==
                          textInputCtrl.text.codeUnits.length) {
                        setState(() {
                          textInputCtrl.text = '';
                        });
                      }
                    }
                  : null,
              icon: const Icon(Icons.send),
              label: const Text("Send"),
            ),
          ),
          Flexible(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  receiveDataList.clear();
                });
              },
              icon: const Icon(Icons.cleaning_services),
              label: const Text("Log Clear"),
            ),
          ),
        ],
      ),
    );
  }

  _userRcvScreen() {
    return Expanded(
      flex: 1,
      child: SizedBox(
        child: Card(
          margin: const EdgeInsets.all(15.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: receiveDataList.length,
              itemBuilder: (context, index) {
                /*
                        OUTPUT for raw bytes
                        */
                // rxEx.clear();
                // var rxEx = List.from(receiveDataList[index]);
                // for (int i = 0; i < rxEx.length; i++) {
                //   for (int j = 0; j < rxEx[i].length; j++) {
                //     log("Rx 0x${rxEx[i][j].toRadixString(16)}");
                //   }
                // }
                // for (int i = 0; i < rxEx.length; i++) {
                //   log("Rx 0x${rxEx[i].toRadixString(16)}");
                // }

                // receiveDataList.clear();
                // if (rxEx.isEmpty) {
                //   log("rx is empty");
                //   return const Text("@");
                // } else {
                //   log("ret $rxEx)");
                //   return Text(rxEx[index].toString());
                // }
                // log("Rx length ${receiveDataList[index].length}");
                // return Text(receiveDataList[index].toString());
                /* output for string */
                return Text(String.fromCharCodes(receiveDataList[index]));
              }),
        ),
      ),
    );
  }
}
