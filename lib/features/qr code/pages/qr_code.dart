import 'package:flutter/material.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(appBarTitle: 'QR Code', navToBorrow: false,),
      
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;
        return Center(
          child: Container(
            width: isWeb ? 800 : 400,
            height: isWeb ? 800 : 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: Image.asset(
              'assets/qr code.jpeg',
             fit: BoxFit.cover,
            ),
          ),
        );
      }),
    );
  }
}
