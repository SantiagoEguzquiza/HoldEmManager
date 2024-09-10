// ignore_for_file: constant_identifier_names

enum NotificacionNoticiaEnum { AGREGADA, EDITADA, ELIMINADA }

extension NotificacionTorneoEnumExtension on NotificacionNoticiaEnum {
  static List<NotificacionNoticiaEnum> get values =>
      NotificacionNoticiaEnum.values;

  String get displayName {
    switch (this) {
      case NotificacionNoticiaEnum.AGREGADA:
        return 'agregada';
      case NotificacionNoticiaEnum.EDITADA:
        return 'editada';
      case NotificacionNoticiaEnum.ELIMINADA:
        return 'eliminada';
      default:
        return '';
    }
  }
}
