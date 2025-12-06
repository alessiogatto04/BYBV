
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bybv/Geolocalization/place.dart';
// ============================================
// PLACES SERVICE - RICERCA PALESTRE CON OPENSTREETMAP
// ============================================
// Questo file si occupa di cercare le palestre vicino a te
// usando OpenStreetMap e l'API Overpass (COMPLETAMENTE GRATUITA!)
//
// COME FUNZIONA?
// 1. Ricevi latitudine e longitudine dalla LocationService
// 2. Costruisci una query per Overpass API
// 3. Fai una richiesta HTTP a Overpass
// 4. Ricevi i dati delle palestre in formato JSON
// 5. Trasformi i dati JSON in oggetti Place
// 6. Restituisci la lista di palestre

// ^ Importa il modello Place che hai già creato

class PlacesService {
  // ============================================
  // METODO PRINCIPALE: getNearbyGyms()
  // ============================================
  // Questa funzione cerca tutte le palestre vicino a una posizione
  //
  // INPUT:
  //   - latitude: la tua latitudine GPS (es: 38.1234)
  //   - longitude: la tua longitudine GPS (es: 13.3621)
  //
  // OUTPUT:
  //   - List<Place>: una lista di palestre trovate
  //
  // È asincrono (Future) perché deve fare una richiesta HTTP
  // che potrebbe impiegare tempo

  Future<List<Place>> getNearbyGyms(double latitude, double longitude) async {
    // ============================================
    // STEP 1: Costruisci la QUERY per Overpass
    // ============================================
    // Overpass API è un servizio che interroga OpenStreetMap
    // Scriviamo una query per cercare palestre
    //
    // La query dice:
    // - Cerca nodi (node) o linee (way) con tag leisure="fitness_centre"
    // - Entro 5000 metri dalla mia posizione
    // - Dammi il risultato in JSON

    final String overpassQuery = '''
      [out:json];
      (
        node["leisure"="fitness_centre"](around:5000,$latitude,$longitude);
        way["leisure"="fitness_centre"](around:5000,$latitude,$longitude);
        node["leisure"="sports_centre"](around:5000,$latitude,$longitude);
        way["leisure"="sports_centre"](around:5000,$latitude,$longitude);
      );
      out center;
    ''';
    // ^ Cerchiamo sia "fitness_centre" che "sports_centre"
    //   perché gli edifici possono essere taggati in modo diverso

    // ============================================
    // STEP 2: Costruisci l'URL completo
    // ============================================
    // L'URL ha due parti:
    // 1. L'indirizzo del server Overpass
    // 2. La query codificata (Uri.encodeComponent)
    //
    // Uri.encodeComponent() trasforma spazi e caratteri speciali
    // in un formato che gli URL possono capire
    // Es: "leisure" rimane "leisure", ma gli spazi diventano "%20"

    final String url = 
        'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(overpassQuery)}';
    // ^ Questo è l'URL finale che manderemo al server Overpass

    try {
      // ============================================
      // STEP 3: Fai la RICHIESTA HTTP
      // ============================================
      // http.get() manda una richiesta al server Overpass
      // Uri.parse() trasforma la stringa in un oggetto Uri
      // Aspettiamo la risposta (await)

      final response = await http.get(Uri.parse(url));
      // response contiene:
      // - statusCode: 200 se tutto va bene, 404/500 se errore
      // - body: il testo della risposta (JSON)

      // ============================================
      // STEP 4: Controlla se la richiesta è andata bene
      // ============================================
      // Il codice 200 significa "OK" (successo)
      // Se è diverso (404, 500, ecc) significa che c'è stato un errore

      if (response.statusCode == 200) {
        // ============================================
        // STEP 5: DECODIFICA il JSON
        // ============================================
        // response.body è una stringa JSON
        // jsonDecode() la trasforma in un oggetto Dart che possiamo leggere
        //
        // ESEMPIO DI JSON RICEVUTO:
        // {
        //   "elements": [
        //     {
        //       "type": "node",
        //       "id": 12345,
        //       "lat": 38.1234,
        //       "lon": 13.3621,
        //       "tags": {
        //         "name": "Palestra Fit Plus",
        //         "addr:street": "Via Roma"
        //       }
        //     },
        //     ...
        //   ]
        // }

        final json = jsonDecode(response.body);
        // json è adesso un Map (dizionario) che contiene i dati
        
        final List<dynamic> elements = json['elements'] ?? [];
        // Estraiamo la lista "elements" dal JSON
        // Se non esiste, usiamo una lista vuota ([])
        // "elements" contiene tutte le palestre trovate

        // ============================================
        // STEP 6: Trasforma ogni elemento in un oggetto Place
        // ============================================
        // "elements" è una lista di dati grezzi
        // Dobbiamo trasformare ogni elemento in un oggetto Place
        // che possiamo usare nella nostra app

        List<Place> gyms = [];
        // Creiamo una lista vuota dove aggiungeremo le palestre

        // Cicliamo su ogni elemento della risposta
        for (var element in elements) {
          try {
            // ============================================
            // ESTRAI I DATI DELL'ELEMENTO
            // ============================================

            // Ottieni i tag (metadati) dell'elemento
            final tags = element['tags'] ?? {};
            // tags contiene cose come "name", "addr:street", ecc.

            // Ottieni il nome della palestra
            final name = tags['name'] ?? 'Palestra senza nome';
            // Se non c'è un nome, usiamo "Palestra senza nome"

            // ============================================
            // OTTIENI LE COORDINATE GPS
            // ============================================
            // Ci sono due modi per avere le coordinate:
            // 1. Se è una "way" (area), usa il "center" (centro dell'area)
            // 2. Se è un "node" (punto), usa direttamente lat/lon

            double? lat;  // ? significa "può essere null"
            double? lon;
            
            if (element['center'] != null) {
              // È una way (area), usa il centro
              lat = element['center']['lat'];
              lon = element['center']['lon'];
            } else if (element['lat'] != null) {
              // È un node (punto), usa le coordinate dirette
              lat = element['lat'];
              lon = element['lon'];
            }

            // ============================================
            // COSTRUISCI L'INDIRIZZO
            // ============================================
            // L'indirizzo è composto da più parti
            // che estraiamo dai tags

            final street = tags['addr:street'] ?? '';      // Via/Strada
            final housenumber = tags['addr:housenumber'] ?? ''; // Numero civico
            final city = tags['addr:city'] ?? 'Palermo';   // Città

            // Combina le parti per fare un indirizzo completo
            String indirizzo = street;
            if (housenumber.isNotEmpty) {
              indirizzo += ', $housenumber';
            }
            if (indirizzo.isEmpty) {
              // Se non abbiamo via, usa almeno la città
              indirizzo = city;
            }

            // ============================================
            // CREA L'OGGETTO PLACE SE ABBIAMO COORDINATE VALIDE
            // ============================================
            // Aggiungiamo la palestra solo se abbiamo lat e lon
            // (sono obbligatorie!)

            if (lat != null && lon != null) {
              gyms.add(Place(
                id: element['id'].toString(),  // Converti l'ID in stringa
                nome: name,
                indirizzo: indirizzo.isNotEmpty 
                    ? indirizzo 
                    : 'Indirizzo non disponibile',
                latitudine: lat,
                longitudine: lon,
              ));
              // ^ Abbiamo aggiunto una palestra alla lista!
            }

          } catch (e) {
            // Se c'è un errore mentre processiamo un elemento,
            // lo ignoriamo e continuiamo con il prossimo
            // (continue significa "vai al prossimo elemento del ciclo")
            continue;
          }
        }

        // ============================================
        // RESTITUISCI LA LISTA DI PALESTRE
        // ============================================
        return gyms;
        // La lista è pronta per essere usata nella UI!

      } else {
        // Se lo statusCode non è 200, c'è stato un errore
        throw Exception('Errore nella risposta (${response.statusCode})');
      }

    } catch (e) {
      // Se succede qualcosa di inaspettato (es: no internet)
      // lanciamo un'eccezione con il messaggio di errore
      throw Exception('Errore nella ricerca: $e');
    }
  }
}

// ============================================
// COME SI USA QUESTO FILE?
// ============================================
//
// final placesService = PlacesService();
// final gyms = await placesService.getNearbyGyms(38.1234, 13.3621);
// // gyms è una lista di oggetti Place pronti per usare!
//
// // Adesso puoi accedere ai dati di ogni palestra:
// for (var gym in gyms) {
//   print(gym.nome);        // es: "Palestra Fit Plus"
//   print(gym.indirizzo);   // es: "Via Roma, 42"
//   print(gym.latitudine);  // es: 38.1234
// }