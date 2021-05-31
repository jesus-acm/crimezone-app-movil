import 'package:flutter/material.dart';

class NavegacionBarService with ChangeNotifier{

  int _paginaActual = 1;
  PageController _pageController = new PageController(initialPage: 1);

  int get paginaActual => this._paginaActual;

  set paginaActual(int valor){
    this._paginaActual = valor;

    _pageController.animateToPage(valor, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }

  PageController get pageController => this._pageController;

}