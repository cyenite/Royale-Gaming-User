// import 'package:app_tournament/services/firestore.dart';
// import 'package:app_tournament/ui/theme/buttons/buttons.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';

// class AddMoney extends StatelessWidget {
//   const AddMoney({
//     Key? key,
//     required TextEditingController addAmount,
//   })  : _addAmount = addAmount,
//         super(key: key);

//   final TextEditingController _addAmount;

//   @override
//   Widget build(BuildContext context) {
//     return DesignButtons.icon(
//       icon: const Icon(Ionicons.wallet_outline),
//       textLabel: 'ADD Money',
//       onPressed: () {
//         // openCheckout
//         showModalBottomSheet(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
//             context: context,
//             builder: (context) {
//               return Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _addAmount,
//                       decoration: const InputDecoration(
//                         labelText: 'Add Amount',
//                         filled: true,
//                         fillColor: Colors.white,
//                         floatingLabelBehavior: FloatingLabelBehavior.auto,
//                         contentPadding: EdgeInsets.all(16),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 2.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 1.0),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 20),
//                     DesignButtons.icon(
//                       icon: const Icon(Ionicons.wallet_outline),
//                       textLabel: 'ADD Money',
//                       onPressed: () {
//                         FirestoreService().updateWallet(
//                           int.parse(_addAmount.text),
//                           'purpose',
//                           DateTime.now().toString(),
//                           '',
//                           '',
//                           '',
//                           true
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               );
//             });
//       },
//     );
//   }
// }
