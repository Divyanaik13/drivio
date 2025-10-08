/*
// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  late IO.Socket socket;

  SocketService._internal();

  void initSocket() {
    socket = IO.io('https://docapi.nuke.co.in/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
///
    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket Server');
    });

    socket.onConnectError((data) {
      print('Socket Connection Error: $data');
    });

  */
/*  socket.onDisconnect((_) {
      print('Disconnected from socket');
    });*//*

  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void listenEvent(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void dispose() {
    socket.dispose();
  }
}
*/
// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;
  bool _isInitialized = false;

  SocketService._internal();

  void initSocket({required String baseUrl}) {
    if (_isInitialized) return;

    _socket = IO.io(
      'https://docapi.nuke.co.in', // e.g. 'https://docapi.nuke.co.in'
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        // 'extraHeaders': {'Authorization': 'Bearer <token>'},
      },
    );

    // Helpful global logging
    _socket.onAny((event, data) => print('[SOCKET] $event -> $data'));

    _socket.onConnect((_) {
      print('[SOCKET] Connected');
    });

    _socket.onConnectError((data) {
      print('[SOCKET] Connect Error: $data');
    });

    _socket.onDisconnect((_) {
      print('[SOCKET] Disconnected');
    });

    _isInitialized = true;
  }

  void connect() {
    _socket.connect();
  }

  void joinBookingRoom({required int bookingId}) {
    // This tells backend which room to put you in
    _socket.emit('joinBooking', {'bookingId': bookingId});
  }

  // Listen for when a driver is assigned
  void onDriverAssigned(Function(Map<String, dynamic>) handler) {
    _socket.on('bookingAccepted', (data) {
      if (data is Map<String, dynamic>) {
        handler(data);
      } else if (data is List && data.isNotEmpty && data.first is Map) {
        handler(Map<String, dynamic>.from(data.first));
      } else {
        print('[SOCKET] Unexpected payload for bookingAccepted: $data');
      }
    });
  }

  // (Optional) If backend also emits intermediate statuses:
  void onBookingStatus(Function(Map<String, dynamic>) handler) {
    _socket.on('bookingStatus', (data) {
      if (data is Map<String, dynamic>) handler(data);
    });
  }

  void emit(String event, dynamic data) => _socket.emit(event, data);

  void dispose() {
    _socket.dispose();
    _isInitialized = false;
  }
}
