import 'package:socket_io_client/socket_io_client.dart';

// final baseUrl = dotenv.env['base_url'].toString();
const baseUrl = "https://communico.as3hr.dev/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io("https://communico.as3hr.dev", {
  'transports': ['websocket'],
  'autoConnect': true,
  'debug': true,
});
