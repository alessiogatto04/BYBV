import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bybv/Geolocalization/place.dart';

// ============================================
// PLACES SERVICE - GOOGLE PLACES API
// ============================================
// Questo file si occupa di cercare le palestre vicino a te
// usando Google Places API (accurata e affidabile!)
//
// COME FUNZIONA?
// 1. Ricevi latitudine e longitudine dalla LocationService
// 2. Costruisci un URL con i parametri di ricerca
// 3. Fai una richiesta HTTP a Google Places API
// 4. Ricevi i dati delle palestre in formato JSON
// 5. Trasformi i dati JSON in oggetti Place
// 6. Restituisci la lista di palestre

class PlacesService {
  // ============================================
  // CHIAVE API DI GOOGLE
  // ============================================
  // Questa chiave viene da Google Cloud Console
  // Domani la genererai e la inserirai qui
  // IMPORTANTE: Non condividere questa chiave con nessuno!
  
  final String apiKey = 'TUA_CHIAVE_API_GOOGLE_QUI';
  // ^ Sostituisci con la vera chiave quando l'avrai
  // Esempio: 'AIzaSyD5Nnk8mV7pQ9xL2wB4cJ6kM3nO0pR1sT'

  // ============================================
  // METODO PRINCIPALE: getNearbyGyms()
  // ============================================
  // Questa funzione cerca tutte le palestre vicino a una posizione
  // usando Google Places API
  //
  // INPUT:
  //   - latitude: la tua latitudine GPS (es: 39.2842 per Cosenza)
  //   - longitude: la tua longitudine GPS (es: 16.2591 per Cosenza)
  //
  // OUTPUT:
  //   - List<Place>: una lista di palestre trovate
  //
  // È asincrono (Future) perché fa una richiesta HTTP
  // che potrebbe impiegare tempo a ricevere risposta

  Future<List<Place>> getNearbyGyms(double latitude, double longitude) async {
    // ============================================
    // STEP 1: Costruisci l'URL della richiesta
    // ============================================
    // Google Places API ha questo formato:
    // https://maps.googleapis.com/maps/api/place/nearbysearch/json
    // ?location=LATITUDINE,LONGITUDINE
    // &radius=RAGGIO_IN_METRI
    // &type=TYPE
    // &key=LA_TUA_CHIAVE
    
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$latitude,$longitude'
        '&radius=50000'  // 50 km di raggio (puoi aumentare se serve)
        '&type=gym'      // Cerca specificamente "gym" (palestre)
        '&key=$apiKey';
    // ^ Questo è l'URL completo che manderemo a Google

    try {
      // ============================================
      // STEP 2: Fai la RICHIESTA HTTP a Google
      // ============================================
      // http.get() manda una richiesta GET a Google Places API
      // Uri.parse() trasforma la stringa in un URL valido
      // await aspetta che la risposta arrivi dal server

      final response = await http.get(Uri.parse(url));
      // response contiene:
      // - statusCode: 200 se tutto è andato bene, altrimenti un errore
      // - body: il testo della risposta (in formato JSON)

      // ============================================
      // STEP 3: Controlla se la richiesta è andata a buon fine
      // ============================================
      // 200 = successo
      // 400+ = errore (chiave errata, API non abilitata, limite superato, ecc)

      if (response.statusCode == 200) {
        
        // ============================================
        // STEP 4: DECODIFICA il JSON ricevuto da Google
        // ============================================
        // Google ritorna un JSON come questo:
        // {
        //   "results": [
        //     {
        //       "name": "Palestra Fit Plus",
        //       "vicinity": "Via Roma 42, Cosenza",
        //       "geometry": {
        //         "location": {
        //           "lat": 39.2842,
        //           "lng": 16.2591
        //         }
        //       },
        //       "place_id": "ChIJ..."
        //     },
        //     ...
        //   ]
        // }
        
        final json = jsonDecode(response.body);
        // jsonDecode trasforma la stringa JSON in un Map (dizionario) Dart
        
        final List<dynamic> results = json['results'] ?? [];
        // Estraiamo l'array "results" che contiene tutte le palestre trovate
        // ?? [] significa: se 'results' non esiste, usa una lista vuota

        // ============================================
        // STEP 5: Trasforma ogni risultato in un oggetto Place
        // ============================================
        // Google ritorna dati "grezzi", noi li trasformiamo in oggetti Place
        // così da poterli usare in tutta l'app

        return results.map((place) {
          // place è un singolo elemento della lista di risultati
          
          return Place(
            // place_id è l'ID univoco della palestra su Google
            id: place['place_id'],
            
            // name è il nome della palestra (es: "Palestra Fit Plus")
            nome: place['name'],
            
            // vicinity è l'indirizzo approssimativo della palestra
            // (es: "Via Roma 42, Cosenza")
            indirizzo: place['vicinity'],
            
            // geometry.location contiene le coordinate GPS
            // 'lat' = latitudine (nord/sud)
            // 'lng' = longitudine (est/ovest)
            latitudine: place['geometry']['location']['lat'],
            longitudine: place['geometry']['location']['lng'],
          );
          
        }).toList();
        // toList() trasforma il risultato del map() in una List<Place>

      } else {
        // Se la risposta non è 200, c'è stato un errore
        // Possibili errori:
        // - 400: richiesta malformata
        // - 403: chiave API non autorizzata per questa API
        // - 429: hai superato il limite di richieste al mese
        // - 500: errore server di Google
        
        throw Exception(
          'Errore Google Places API (${response.statusCode}). '
          'Corpo della risposta: ${response.body}'
        );
        // Mostriamo il codice errore e il corpo della risposta per debuggare

      }

    } catch (e) {
      // Se succede qualcosa di inaspettato (es: no internet, timeout)
      // catchiamo l'eccezione e la rilancia con un messaggio chiaro
      
      throw Exception('Errore nella ricerca: $e');
    }
  }
}

// ============================================
// COME SI USA QUESTO FILE?
// ============================================
//
// Nel gym_search_page.dart:
// 
// final placesService = PlacesService();
// final gyms = await placesService.getNearbyGyms(39.2842, 16.2591);
// // gyms è una lista di oggetti Place pronti per usare!
//
// Adesso puoi accedere ai dati di ogni palestra:
// for (var gym in gyms) {
//   print(gym.nome);        // es: "Palestra Fit Plus"
//   print(gym.indirizzo);   // es: "Via Roma 42, Cosenza"
//   print(gym.latitudine);  // es: 39.2842
//   print(gym.longitudine); // es: 16.2591
// }
