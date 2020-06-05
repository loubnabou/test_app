import 'package:bloc/bloc.dart';
import 'package:tesapp/pages/import.dart';
/*import 'package:tesapp/pages/resultats.dart';
import 'package:tesapp/pages/importFrancais.dart';


enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => Table();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield Importer();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield Table();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield resultats();
        break;
    }
  }
}*/