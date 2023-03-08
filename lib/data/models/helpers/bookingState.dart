enum STATUS_BOOKING {
  PENDIENTE("63"),
  APROBADO("64"),
  EN_EJECUCION("65"),
  FINALIZADO("66"),
  RECHAZADO("67"),
  ELIMINADO("68");
  const STATUS_BOOKING(this.value);
  final String value;
}