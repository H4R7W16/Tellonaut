// impl. UDP + Video sockets
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class UdpClient {
  UdpClient._();
  static final instance = UdpClient._();

  static const _droneIp = '192.168.10.1';
  static const _cmdPort = 8889;
  static const _statePort = 8890;

  RawDatagramSocket? _cmdSocket;
  RawDatagramSocket? _stateSocket;

  final _stateController = StreamController<String>.broadcast();
  Stream<String> get rawState$ => _stateController.stream;

  Future<void> open() async {
    _cmdSocket ??= await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _stateSocket ??= await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      _statePort,
    );
    _stateSocket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = _stateSocket!.receive();
        if (dg != null) _stateController.add(utf8.decode(dg.data));
      }
    });
    // SDK‑Modus aktivieren
    await send('command');
  }

  Future<void> close() async {
    _cmdSocket?.close();
    _stateSocket?.close();
    await _stateController.close();
    _cmdSocket = _stateSocket = null;
  }

  Future<void> send(String cmd) async {
    final data = utf8.encode(cmd);
    _cmdSocket?.send(data, InternetAddress(_droneIp), _cmdPort);
  }
}
