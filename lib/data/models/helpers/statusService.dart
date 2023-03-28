enum STATUS_SERVICE {
  CREADO(51),
  ASIGNADO(52),
  EN_EJECUCION(53),
  FINALIZADOS(54),
  CANCELADOS(55);

  const STATUS_SERVICE(this.value);
  final num value;
}
