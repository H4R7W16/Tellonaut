// lib/application/drone/tello_udp.dart

import 'dart:async';
import 'dart:io';
import 'dart:convert'; // für utf8

class TelloUdp {
  // InternetAddress-Konstruktor ist nicht const, daher final statt const
  static final _tello = InternetAddress('192.168.10.1');
  static const _cmdPort = 8889;
  static const _statePort = 8890;

  late RawDatagramSocket _socket;
  final _replyCtrl = StreamController<String>.broadcast();

  Stream<String> get replies => _replyCtrl.stream;

  Future<void> init() async {
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      _statePort,
    );
    _socket.listen((evt) {
      if (evt == RawSocketEvent.read) {
        final datagram = _socket.receive();
        if (datagram != null) {
          _replyCtrl.add(String.fromCharCodes(datagram.data));
        }
      }
    });
  }

  void send(String cmd) {
    final bytes = utf8.encode(cmd.trim());
    _socket.send(bytes, _tello, _cmdPort);
  }

  Future<void> dispose() async {
    // close() liefert void, daher kein await
    _socket.close();
    // StreamController.close() liefert Future<void>, hier awaiten
    await _replyCtrl.close();
  }
}
