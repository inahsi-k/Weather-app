import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const HourlyForecast(
      {super.key, required this.time, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow
                  .ellipsis, //agar text exceeds the range then it is dhown like 123... to make sure it's not over yet
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(value,
                style: const TextStyle(
                  fontSize: 16,
                ))
          ]),
        ),
      ),
    );
  }
}








//  @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 120,
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: const Padding(
//           padding: EdgeInsets.all(11.0),
//           child: Column(children: [
//             Text(
//               "3:00",
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Icon(
//               Icons.cloud,
//               size: 40,
//             ),
//             SizedBox(
//               height: 7,
//             ),
//             Text("300.7",
//                 style: TextStyle(
//                   fontSize: 16,
//                 ))
//           ]),
//         ),
//       ),
//     );
//   }

