import 'package:bloc/bloc.dart';

abstract class NavigationEvent {}

class TabTapped extends NavigationEvent {
  final int index;
  TabTapped(this.index);
}

class NavigationState {
  final int selectedIndex;
  const NavigationState(this.selectedIndex);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(0)) {
    on<TabTapped>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
