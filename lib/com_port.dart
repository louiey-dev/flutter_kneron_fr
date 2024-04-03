import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/fr_api.dart';
import 'package:flutter_kneron_fr/fr_msg.dart';
import 'package:flutter_kneron_fr/utils.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:cp949_codec/cp949_codec.dart';
import 'package:convert/convert.dart';

class ComPort extends StatefulWidget {
  const ComPort({super.key});

  @override
  State<ComPort> createState() => _ComPortState();
}

class _ComPortState extends State<ComPort> {
  List<SerialPort> portList = [];
  SerialPort? _serialPort;
  List<Uint8List> receiveDataList = [];
  // List<Uint8List> rxEx = [];
  final textInputCtrl = TextEditingController();

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
    if (_serialPort != null) _serialPort?.close();

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
        _serialPort = portList.first;
      }
    });
  }

  void changedDropDownItem(SerialPort sp) {
    setState(() {
      _serialPort = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    openButtonText = _serialPort == null
        ? 'N/A'
        : _serialPort!.isOpen
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
            Expanded(
              flex: 6,
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: receiveDataList.length,
                    itemBuilder: (context, index) {
                      /*
                      OUTPUT for raw bytes
                      */
                      // rxEx.clear();
                      var rxEx = List.from(receiveDataList[index]);
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
                      return Text(receiveDataList[index].toString());
                      /* output for string */
                      // return Text(String.fromCharCodes(receiveDataList[index]));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _comPort() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          DropdownButton(
            value: _serialPort,
            items: portList.map((item) {
              return DropdownMenuItem(value: item, child: Text("${item.name}"));
              // "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
            }).toList(),
            onChanged: (e) {
              setState(() {
                changedDropDownItem(e as SerialPort);
              });
            },
          ),
          const SizedBox(width: 20.0),
          DropdownButton(
            value: menuBaudrate,
            items: baudRate.map((value) {
              return DropdownMenuItem(
                  value: value, child: Text(value.toString()));
            }).toList(),
            onChanged: (e) {
              setState(() {
                menuBaudrate = e!;
                showSnackbar(context, menuBaudrate.toString());
                log("Baudrate set to $menuBaudrate");
              });
            },
          ),
          const SizedBox(width: 20.0),
          OutlinedButton(
            child: const Text("COM"),
            onPressed: () {
              _initPort();
            },
          ),
          const SizedBox(width: 20.0),
          OutlinedButton(
            child: Text(openButtonText),
            onPressed: () {
              if (_serialPort == null) {
                return;
              }
              if (_serialPort!.isOpen) {
                _serialPort!.close();
                log('${_serialPort!.name} closed!');
              } else {
                if (_serialPort!.open(mode: SerialPortMode.readWrite)) {
                  SerialPortConfig config = _serialPort!.config;
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
                  _serialPort!.config = config;

                  log("baudrate : $menuBaudrate");
                  if (_serialPort!.isOpen) {
                    log('${_serialPort!.name} opened!');
                    showSnackbar(
                        context, "Serial port opened, ${_serialPort!.name}");
                  }
                  final reader = SerialPortReader(_serialPort!);
                  reader.stream.listen((data) {
                    makeMessage(data, data.length);
                    // log('received: ${data.length}, ${String.fromCharCodes(data)}');
                    receiveDataList.add(data);
                    setState(() {});
                  }, onError: (error) {
                    if (error is SerialPortError) {
                      log('error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                    }
                  });
                }
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  _commandList() {
    return Expanded(
      flex: 1,
      child: Flexible(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      showSnackbar(context, "sendPowerDown");
                      sendPowerDown(context, _serialPort);
                    },
                    child: const Text("Power Down")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Enroll")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Verify")),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Get Status")),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Del User")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Del All")),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      showSnackbar(context, "sendVersion");
                      sendVersion(context, _serialPort);
                    },
                    child: const Text("Version")),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Device Info")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _userInputSend() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                enabled:
                    (_serialPort != null && _serialPort!.isOpen) ? true : false,
                controller: textInputCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Flexible(
            child: TextButton.icon(
              onPressed: (_serialPort != null && _serialPort!.isOpen)
                  ? () {
                      if (_serialPort!.write(Uint8List.fromList(
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
}
