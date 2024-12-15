import 'package:socket_io_client/socket_io_client.dart';

// final baseUrl = dotenv.env['base_url'].toString();
const baseUrl = "https://communico.as3hr.dev/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
});
