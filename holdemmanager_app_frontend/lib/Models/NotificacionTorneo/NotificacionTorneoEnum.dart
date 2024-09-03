// ignore_for_file: constant_identifier_names

enum NotificacionTorneoEnum { AGREGADO, EDITADO, ELIMINADO }

extension NotificacionTorneoEnumExtension on NotificacionTorneoEnum {
  static List<NotificacionTorneoEnum> get values =>
      NotificacionTorneoEnum.values;

  String get displayName {
    switch (this) {
      case NotificacionTorneoEnum.AGREGADO:
        return 'agregado';
      case NotificacionTorneoEnum.EDITADO:
        return 'editado';
      case NotificacionTorneoEnum.ELIMINADO:
        return 'eliminado';
      default:
        return '';
    }
  }
}
