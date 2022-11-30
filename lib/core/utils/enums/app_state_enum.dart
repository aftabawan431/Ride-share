/// These are the current AppState our app supports
enum AppStateEnum {
  none,
  registration,
}

extension AppStateEnumPar on String {
  AppStateEnum toAppStateEnum() {
    return AppStateEnum.values.firstWhere(
      (e) => e.toString().toLowerCase() == 'AppStateEnum.$this'.toLowerCase(),
      orElse: () => AppStateEnum.none,
    ); //return null if not found
  }
}

extension AppStateEnumDePar on AppStateEnum {
  String toStringAppState() {
    return toString().split('.').last; //return null if not found
  }
}
