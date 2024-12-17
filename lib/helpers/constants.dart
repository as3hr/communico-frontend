import 'package:socket_io_client/socket_io_client.dart';

const baseUrl = "http://localhost:5000";
const baseApiUrl = "$baseUrl/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
  // 'debug': true,
  // 'path': '/socket.io/',
});
