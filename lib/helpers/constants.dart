import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';

const localUrl = "http://localhost:5000";
final baseUrl = dotenv.env["base_url"] ?? localUrl;
final baseApiUrl = "$baseUrl/api";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
  'debug': true,
  'path': '/socket.io/',
});
