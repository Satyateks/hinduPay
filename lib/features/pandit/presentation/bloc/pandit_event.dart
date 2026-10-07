abstract class PanditEvent {}

class FetchPanditsEvent extends PanditEvent {
  final String? poojaFilter;
  FetchPanditsEvent({this.poojaFilter});
}

class BookPanditEvent extends PanditEvent {
  final String panditId;
  final String poojaName;
  final DateTime date;
  BookPanditEvent({required this.panditId, required this.poojaName, required this.date});
}