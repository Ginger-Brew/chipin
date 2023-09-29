// // 휴대폰 본인인증
// // https://be-beee.tistory.com/23
//
// import 'package:chipin/login/registerdetail_over.dart';
// import 'package:chipin/login/registerdetail_under.dart';
// import 'package:flutter/material.dart';
//
// bool _overIsPressed = false;
// bool _underIsPressed = false;
//
// class RegisterPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 1,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child:Container(
//                 margin:EdgeInsets.only(left: 50),
//                 child:const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "회원가입",
//                         style: TextStyle(
//                             fontSize: 30,
//                             fontFamily: "Pretendard",
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         "해당되는 회원가입 유형을 선택해주세요.",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontFamily: "Pretendard",
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black54),
//                       )
//                     ]),
//               )
//             )
//           ),
//           Expanded(flex: 8, child: Center(child:ChoiceRole())),
//           Expanded(
//             flex: 4,
//             child: Container(
//               margin : EdgeInsets.only(bottom:20),
//               child: Align(alignment: Alignment.bottomCenter, child: RegistButton()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChoiceRole extends StatefulWidget {
//   const ChoiceRole({super.key});
//
//   @override
//   _ChoiceRoleState createState() => _ChoiceRoleState();
// }
//
// class _ChoiceRoleState extends State<ChoiceRole> {
//   void _overToggleButton() {
//     setState(() {
//       _overIsPressed = !_overIsPressed;
//       _underIsPressed = false;
//     });
//   }
//
//   void _underToggleButton() {
//     setState(() {
//       _underIsPressed = !_underIsPressed;
//       _overIsPressed = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: ElevatedButton(
//                 onPressed: _overToggleButton,
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.resolveWith<Color>((states) {
//                     if (_overIsPressed) {
//                       return Colors.indigoAccent; // 선택시
//                     }
//                     return Colors.white; // 그 외에는 흰색
//                   }),
//                 ),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         child: Image.asset('images/over.png'),
//                         width: 100,
//                         height: 100,
//                       ),
//                       Text(
//                         "만 14세 이상",
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.fromLTRB(20, 0, 00, 0),
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 3.0,
//                     spreadRadius: 5.0,
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: _underToggleButton,
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.resolveWith<Color>((states) {
//                     if (_underIsPressed) {
//                       return Colors.amber; // 선택시
//                     }
//                     return Colors.white; // 그 외에는 흰색
//                   }),
//                 ),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         child: Image.asset('images/under.png'),
//                         width: 100,
//                         height: 100,
//                       ),
//                       Text(
//                         "만 14세 미만",
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
//
// class RegistButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 450,
//       height: 60,
//       child: ElevatedButton(
//         onPressed: () {
//           if (_overIsPressed) {Navigator.of(context).push(_overRoute());}
//           else if (_underIsPressed) {Navigator.of(context).push(_underRoute());}
//         },
//         style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//         child: Text('회원가입',
//         style:TextStyle(
//             fontSize: 20,
//             fontFamily: "Pretendard",
//             fontWeight: FontWeight.w700,
//             color: Colors.white
//         )),
//       ),
//     );
//   }
// }
//
// Route _overRoute() {
//   return PageRouteBuilder(
//     transitionsBuilder:
//     // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
//     // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
//         (context, animation, secondaryAnimation, child) {
//       // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
//       // 애니메이션이 시작할 포인트 위치를 의미한다.
//       var begin = const Offset(1.0, 0);
//       var end = Offset.zero;
//       // Curves.ease: 애니메이션이 부드럽게 동작하도록 명령
//       var curve = Curves.ease;
//       // 애니메이션의 시작과 끝을 담당한다.
//       var tween = Tween(
//         begin: begin,
//         end: end,
//       ).chain(
//         CurveTween(
//           curve: curve,
//         ),
//       );
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//     // 함수를 통해 Widget을 pageBuilder에 맞는 형태로 반환하게 해야한다.
//     pageBuilder: (context, animation, secondaryAnimation) =>
//     // (RegisterDetailPage은 Stateless나 Stateful 위젯으로된 화면임)
//     RegisterPage(),
//     // 이것을 true로 하면 dialog로 취급한다.
//     // 기본값은 false
//     fullscreenDialog: false,
//   );
// }
//
