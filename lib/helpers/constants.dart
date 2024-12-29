import 'package:communico_frontend/config.dart';
import 'package:socket_io_client/socket_io_client.dart';

const localUrl = "http://localhost:5000";
const baseUrl = Config.baseUrl;
const baseApiUrl = "$baseUrl/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
  'debug': true,
  'path': '/socket.io/',
});
