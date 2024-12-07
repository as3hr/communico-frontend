import 'package:socket_io_client/socket_io_client.dart';

const appUrl = "https://jsonplaceholder.typicode.com";
const baseUrl = "http://localhost:5000";
const tokenKey = "API_TOKEN_KEY";
var socket = io(baseUrl, {
  'transports': ['websocket'],
  'autoConnect': true,
});
