import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:tesapp/pages/importer.dart';
import 'package:tesapp/pages/resultats.dart';
import 'package:tesapp/pages/table.dart';


enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => table();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield Importer();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield table();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield resultats();
        break;
    }
  }
}