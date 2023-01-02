// ignore_for_file: avoid_print

void main() {
  // final birthday = DateTime(1998, 02, 02);
  final pDays = DateTime.now();
  // final bonusAdd = pDays.add(const Duration(days: -1));
  final date2 = DateTime.now();
  final difference = date2.difference(pDays).inDays;
  // final amPM = DateFormat.yMMMd().add_jm().format(date2);
  print(date2);
  // print(bonusAdd);
  print(difference);
}
