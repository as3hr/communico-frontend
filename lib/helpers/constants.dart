import 'package:socket_io_client/socket_io_client.dart';

const localUrl = "http://localhost:5000";
const baseUrl = localUrl;
// "https://communico.as3hr.dev";
const baseApiUrl = "$baseUrl/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
  // 'debug': true,
  // 'path': '/socket.io/',
});
