import 'package:flutter/material.dart';

import '../../core/styles/size_config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: SizeConfig.blockSizeHorizontal(70),
        decoration: const BoxDecoration(
          color: Color.fromARGB(195, 217, 217, 217),
          borderRadius: BorderRadius.all(Radius.circular(20))

        ),
        height: SizeConfig.blockSizeVertical(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text('Cargando...')
          ],
        ),
      ),
    );
  }
}
