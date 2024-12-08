// import 'dart:async';

// import 'package:app_links/app_links.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'app_navigation.dart';
// import 'route_name.dart';

// class DeepLinking {
//   StreamSubscription? sub;
//   final _appLinks = AppLinks();
//   final navigation = AppNavigation();

//   // Handles deep links that come in after the app has been opened
//   void handleIncomingLinks(bool mounted, BuildContext context) {
//     if (!kIsWeb) {
//       sub = _appLinks.uriLinkStream.listen((Uri? uri) {
//         if (!mounted) return;

//         final queryParams = uri?.queryParametersAll.entries.toList();
//         if (queryParams!.first.key == "id") {
//           String id = queryParams.first.value.first;
//           // Navigate to the page using the extracted ID
//           navigation.push(RouteName.home, arguments: {
//             "id": id,
//           });
//         }
//       }, onError: (Object err) {
//         if (!mounted) return;
//       });
//     }
//   }

//   // Handles the deep link if the app was launched from a link
//   Future<void> handleInitialUrl(bool mounted, BuildContext context) async {
//     try {
//       await _appLinks.getInitialLink().then((initialURI) {
//         if (initialURI != null) {
//           final queryParams = initialURI.queryParametersAll.entries.toList();
//           if (queryParams.first.key == "id") {
//             String id = queryParams.first.value.first;
//             navigation.push(RouteName.home, arguments: {
//               "id": id,
//             });
//           }

//           if (!mounted) {
//             return;
//           }
//         }
//         if (!mounted) return;
//       });
//     } on PlatformException {
//       // Platform messages may fail but we ignore the exception
//     } on FormatException {
//       if (!mounted) return;
//     }
//   }
// }
