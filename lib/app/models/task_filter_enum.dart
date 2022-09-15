enum TaskFilterEnum {
  today(value: 'DE HOJE'),
  tomorrow(value: 'DE AMANHÃ'),
  week(value: 'DA SEMANA');

  final String value;
  const TaskFilterEnum({required this.value});
}
