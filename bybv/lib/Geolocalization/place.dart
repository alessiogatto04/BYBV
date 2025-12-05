class Place{
  //questa classe serve per salvare le informazioni di ogni palestra
  final String placeId;      // ID univoco della palestra
  final String name;         // Nome della palestra
  final String address;      // Indirizzo
  final double lat;         // Latitudine (coordinata geografica)
  final double lng;         // Longitudine (coordinata geografica)

  //Crea un oggetto Place con tutti i dati necessari. required significa che sono obbligatori.
  Place({
    required this.placeId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    });
  
  factory Place.fromJson(Map<String, dynamic> json) {
    // 1. Accede alle coordinate geografiche
    final geometry = json['geometry']['location'];
    
    // 2. Crea e restituisce un oggetto Place
    return Place(
      placeId: json['place_id'],  // ID univoco del luogo
      name: json['name'] ?? 'Senza nome',  // Nome, con valore di default
      address: json['vicinity'] ?? json['formatted_address'] ?? '',  // Indirizzo
      lat: (geometry['lat'] as num).toDouble(),  // Converte latitudine
      lng: (geometry['lng'] as num).toDouble(),  // Converte longitudine
    );
  }
}