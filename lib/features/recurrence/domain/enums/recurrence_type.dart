enum RecurrenceType {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  semiannually,
  annually,
}

extension RecurrenceTypeX on RecurrenceType {
  String get label {
    switch (this) {
      case RecurrenceType.daily:
        return 'Diariamente';
      case RecurrenceType.weekly:
        return 'Semanalmente';
      case RecurrenceType.biweekly:
        return 'Quinzenalmente';
      case RecurrenceType.monthly:
        return 'Mensalmente';
      case RecurrenceType.quarterly:
        return 'Trimestralmente';
      case RecurrenceType.semiannually:
        return 'Semestralmente';
      case RecurrenceType.annually:
        return 'Anualmente';
    }
  }

  int get days {
    switch (this) {
      case RecurrenceType.daily:
        return 1;
      case RecurrenceType.weekly:
        return 7;
      case RecurrenceType.biweekly:
        return 15;
      case RecurrenceType.monthly:
        return 30;
      case RecurrenceType.quarterly:
        return 90;
      case RecurrenceType.semiannually:
        return 180;
      case RecurrenceType.annually:
        return 365;
    }
  }
}
