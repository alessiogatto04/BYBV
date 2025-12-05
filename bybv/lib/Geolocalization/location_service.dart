// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

// questa classe gestisce l'accesso alla posizione GPS del dispositivo . E' essenziale per alcune funzionalità come quella di trovare le palestre vicine
// Future<Position>: Restituisce una Position (dati GPS) in modo asincrono
class LocationService {
  static Future<Position> getCurrentPosition() async {
    
    //Fase 1 , controlla se il GPS è attivo , se si continua . Se non è attivo lancia un exception
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // AGGIUNTA: Usiamo un'eccezione personalizzata per identificare meglio questo caso specifico
      throw LocationServiceDisabledException(
        'Servizi di localizzazione disabilitati. '
        'Attivali nelle impostazioni del dispositivo.'
      );
    }

    //Fase 2 : controllo dei permessi app. Verifica se l'utente ha già concesso i permessi all'app
    // Possibili stati : 
    // granted → L'utente ha già dato il permesso
    // denied → L'utente non ha ancora deciso → chiede permesso
    // denied di nuovo → L'utente rifiuta → lancia eccezione

    // Schermata che appare all'utente:
    // "BYBV" vuole usare la tua posizione
    // [Consenti solo questa volta] [Consenti mentre usi l'app] [Non consentire]
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permessi di localizzazione negati');
      }
    }

    //Fase 3: controllo permessi negati permanentemente . Verifica se l'utente ha bloccato permanentemente i permessi(cioè nel caso in cui l'utente ha selezionato "Non consentire" , o "NOn chiedere più").
    // Soluzione : l'utente deve andare nelle impostazioni del telefono e abilitare manualmente il permesso.
    if (permission == LocationPermission.deniedForever) {
       // AGGIUNTA: Usiamo un'eccezione personalizzata per questo caso specifico
       throw LocationPermissionPermanentlyDeniedException(
        'Permessi di localizzazione negati permanentemente. '
        'Vai nelle impostazioni dell\'app per abilitarli manualmente.'
      );
    }
    
    //Fase 4: Ottenere la posizione effettiva
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // Cosa fa: Ottiene le coordinate GPS attuali.
    // LocationAccuracy.high: Precisione massima (usa GPS satellitare)
    // Vantaggio: Precisione 5-10 metri
    // Svantaggio: Maggior consumo batteria
    // Alternativa: LocationAccuracy.medium (risparmia batteria)

    // Quando il metodo ha successo, restituisce un oggetto Position con:
    // Position {
    //   latitude: 45.4642,    // Latitudine (Nord/Sud)
    //   longitude: 9.1900,    // Longitudine (Est/Ovest)
    //   altitude: 120.5,      // Altitudine (metri)
    //   accuracy: 10.0,       // Precisione in metri
    //   speed: 5.2,           // Velocità (m/s)
    //   heading: 90.0,        // Direzione (gradi)
    //   timestamp: 2024-01-15 10:30:00.000Z  // Data/ora
    // } Vedi classe place.dart dove ci sono oggetti di questo tipo , formattati in una classe apposita
  }
  
  // AGGIUNTA: Metodo per aprire le impostazioni di localizzazione del dispositivo
  // Questo metodo apre direttamente la schermata delle impostazioni GPS del telefono
  // Dove l'utente può attivare/disattivare la localizzazione
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
  
  // AGGIUNTA: Metodo per aprire le impostazioni specifiche dell'app
  // Questo metodo apre le impostazioni della tua app BYBV nel telefono
  // Dove l'utente può gestire i permessi (Posizione, Fotocamera, etc.)
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

// AGGIUNTA: Eccezione personalizzata per identificare quando i servizi di localizzazione sono disabilitati
// Questa eccezione viene lanciata quando il GPS è spento a livello di sistema
// Esempio: l'utente ha disattivato la localizzazione nelle impostazioni rapide del telefono
class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException(this.message);
  
  @override
  String toString() => 'LocationServiceDisabledException: $message';
}

// AGGIUNTA: Eccezione personalizzata per identificare quando i permessi sono stati negati permanentemente
// Questa eccezione viene lanciata quando l'utente ha selezionato "Non chiedere più"
// o ha bloccato i permessi nelle impostazioni dell'app
class LocationPermissionPermanentlyDeniedException implements Exception {
  final String message;
  LocationPermissionPermanentlyDeniedException(this.message);
  
  @override
  String toString() => 'LocationPermissionPermanentlyDeniedException: $message';
}