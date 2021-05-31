import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';

class BotonesCategorias extends StatelessWidget {
  final Function onPressedPeaton;
  final Function onPressedTransporte;

  const BotonesCategorias({
    this.onPressedPeaton, this.onPressedTransporte
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: state.peaton ? Colors.blue[300] : Colors.white,
              maxRadius: 25,
              child: IconButton(
                icon: Icon(Icons.people, color: state.peaton ? Colors.white : Colors.black87), 
                onPressed: onPressedPeaton
                ),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              backgroundColor: state.transporte ? Colors.blue[300] : Colors.white,
              maxRadius: 25,
              child: IconButton(
                icon: Icon(Icons.commute, color: state.transporte ? Colors.white : Colors.black87), 
                onPressed: onPressedTransporte
              ),
            )
          ],
        );
      },
    );
  }
}