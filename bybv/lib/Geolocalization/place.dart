class Place {

    //questa classe serve per salvare le informazioni di ogni palestra
  final String id; // ID univoco della palestra
  final String nome;  // Indirizzo
  final String indirizzo;
  final double latitudine; // Latitudine (coordinata geografica)
  final double longitudine; // Longitudine (coordinata geografica)

  //Crea un oggetto Place con tutti i dati necessari. required significa che sono obbligatori.
  Place({
    required this.id,
    required this.nome,
    required this.indirizzo,
    required this.latitudine,
    required this.longitudine,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'indirizzo': indirizzo,
      'latitudine': latitudine,
      'longitudine': longitudine,
    };
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      nome: json['nome'] as String,
      indirizzo: json['indirizzo'] as String,
      latitudine: json['latitudine'] as double,
      longitudine: json['longitudine'] as double,
    );
  }
}