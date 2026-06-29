// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:driver/core/bloc/connection/cubit/connection_cubit.dart';
// import 'package:driver/core/bloc/connection/cubit/connection_state.dart'
//     as connection;

// class ConnectionOverlay extends StatelessWidget {
//   final Widget child;

//   const ConnectionOverlay({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ConnectionCubit, connection.ConnectionState>(
//       builder: (context, state) {
//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             child,

//             if (state is connection.ConnectionDisconnected)
//               Positioned.fill(child: _buildOfflineOverlay(context)),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildOfflineOverlay(BuildContext context) {
//     return Container(
//       color: Colors.black.withOpacity(0.95),
//       child: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 60),

//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 0),
//                 padding: const EdgeInsets.all(40),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 30,
//                       offset: const Offset(0, -10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Icon
//                     Container(
//                       padding: const EdgeInsets.all(30),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.wifi_off,
//                         size: 80,
//                         color: Colors.red,
//                       ),
//                     ),

//                     const SizedBox(height: 40),

//                     // Title
//                     const Text(
//                       'لا يوجد اتصال بالإنترنت',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 20),

//                     // Message
//                     const Text(
//                       'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey,
//                         height: 1.6,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 50),

//                     // Retry Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           context.read<ConnectionCubit>().checkConnection();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 8,
//                         ),
//                         child: const Text(
//                           'إعادة المحاولة',
//                           style: TextStyle(
//                             color: Colors.white,
//                             // fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
