// ignore_for_file: constant_identifier_names

enum FeedbackEnum {
  INSCRIPCION,
  ESTRUCTURA,
  PREMIOS,
  INSTALACIONES,
  PERSONAL,
  OTROS,
}

extension FeedbackEnumExtension on FeedbackEnum {
  static List<FeedbackEnum> get values => FeedbackEnum.values;

  String get displayName {
    switch (this) {
      case FeedbackEnum.INSCRIPCION:
        return 'Inscripción';
      case FeedbackEnum.ESTRUCTURA:
        return 'Estructura';
      case FeedbackEnum.PREMIOS:
        return 'Premios';
      case FeedbackEnum.INSTALACIONES:
        return 'Instalaciones';
      case FeedbackEnum.PERSONAL:
        return 'Personal';
      case FeedbackEnum.OTROS:
        return 'Otros';
      default:
        return '';
    }
  }
}
