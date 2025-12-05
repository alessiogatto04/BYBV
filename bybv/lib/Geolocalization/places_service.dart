
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bybv/Geolocalization/place.dart';

class PlacesService {
  final String apiKey;
  PlacesService(this.apiKey);

  // Cerca palestre (type=gym) vicino a lat/lng, raggio in metri
  Future<List<Place>> nearbyGyms({
    required double lat,
    required double lng,
    int radius = 3000, // 3km, puoi aumentare o diminuire
    String? keyword,   // es. "nome palestra", se usi la barra di ricerca
  }) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/place/nearbysearch/json', {
      'key': apiKey,
      'location': '$lat,$lng',
      'radius': '$radius',
      'type': 'gym',
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Errore Places: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    final results = (data['results'] as List<dynamic>? ?? []);
    return results.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
  }
}