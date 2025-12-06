import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bybv/Geolocalization/place.dart';
import 'package:bybv/Geolocalization/location_service.dart';
import 'package:bybv/Geolocalization/places_service.dart';

// ============================================
// GYM SEARCH PAGE - PAGINA RICERCA PALESTRE
// ============================================
// Questa pagina permette all'utente di:
// 1. Cercare palestre vicine alla sua posizione
// 2. Vedere i risultati in una lista
// 3. Selezionare una palestra e salvarla


// ============================================
// CLASSE PRINCIPALE: GymSearchPage (StatefulWidget)
// ============================================
// StatefulWidget significa che la pagina può cambiare stato
// (es: da "caricamento" a "risultati trovati")
// Se usassimo StatelessWidget, non potremmo aggiornare la UI

class GymSearchPage extends StatefulWidget {
  const GymSearchPage({Key? key}) : super(key: key);

  @override
  State<GymSearchPage> createState() => _GymSearchPageState();
}

// ============================================
// CLASSE DI STATO: _GymSearchPageState
// ============================================
// Contiene la logica e i dati che cambiano nel tempo

class _GymSearchPageState extends State<GymSearchPage> {
  // ============================================
  // VARIABILI DI STATO
  // ============================================
  // Queste variabili tengono traccia dello stato della pagina

  // Istanze dei servizi che usiamo
  final LocationService _locationService = LocationService();
  // ^ Usato per ottenere la posizione GPS dell'utente
  
  final PlacesService _placesService = PlacesService();
  // ^ Usato per cercare le palestre

  // Lista delle palestre trovate
  List<Place> _gyms = [];
  // Inizialmente vuota, si riempirà quando cerchiamo

  // Flag per sapere se stiamo caricando
  bool _isLoading = false;
  // true = mostra spinner di caricamento
  // false = mostra risultati o errore

  // Messaggio di errore (se c'è un problema)
  String? _errorMessage;
  // null = nessun errore
  // "Messaggio" = c'è un errore da mostrare

  // ============================================
  // LIFECYCLE: initState()
  // ============================================
  // Questa funzione si chiama UNA SOLA VOLTA quando la pagina nasce
  // La usiamo per avviare la ricerca automaticamente

  @override
  void initState() {
    super.initState();
    // Quando la pagina si apre, cerca le palestre subito
    _searchNearbyGyms();
  }

  // ============================================
  // FUNZIONE: _searchNearbyGyms()
  // ============================================
  // Questa è la funzione principale che:
  // 1. Ottiene la tua posizione
  // 2. Cerca le palestre vicine
  // 3. Aggiorna la UI con i risultati
  //
  // È asincrona (Future) perché fa richieste HTTP che impiegano tempo

  Future<void> _searchNearbyGyms() async {
    // ============================================
    // STEP 1: Imposta lo stato di caricamento
    // ============================================
    // setState() dice a Flutter "aggiorna la UI"
    // Mostriamo uno spinner e nascondiamo gli errori precedenti

    setState(() {
      _isLoading = true;
      // true = mostra lo spinner CircularProgressIndicator
      
      _errorMessage = null;
      // Pulisci gli errori precedenti
    });

    try {
      // ============================================
      // STEP 2: Ottieni la posizione GPS dell'utente
      // ============================================
      // LocationService.getCurrentLocation() fa tutto:
      // - Controlla se GPS è acceso
      // - Chiede i permessi se necessario
      // - Restituisce latitudine e longitudine

      final position = await _locationService.getCurrentPosition();
      // position contiene:
      // - position.latitude (es: 38.1234)
      // - position.longitude (es: 13.3621)

      // ============================================
      // STEP 3: Cerca le palestre vicine
      // ============================================
      // Usiamo PlacesService per interrogare OpenStreetMap
      // Passiamo la posizione che abbiamo appena ottenuto

      final gyms = await _placesService.getNearbyGyms(
        position.latitude,
        position.longitude,
      );
      // gyms è una List<Place> con tutte le palestre trovate!

      // ============================================
      // STEP 4: Aggiorna la UI con i risultati
      // ============================================
      // setState() dice a Flutter di ridisegnare la pagina
      // Aggiorniamo _gyms con le palestre trovate
      // Fermiamo il caricamento

      setState(() {
        _gyms = gyms;
        // Salva le palestre trovate
        
        _isLoading = false;
        // Ferma lo spinner (abbiamo finito di caricare)
      });

    } catch (e) {
      // ============================================
      // SE C'È UN ERRORE
      // ============================================
      // Se succede qualcosa di male (GPS spento, no internet, ecc)
      // salviamo il messaggio di errore e lo mostriamo all'utente

      setState(() {
        _errorMessage = e.toString();
        // Salva il messaggio di errore
        // toString() trasforma l'eccezione in testo leggibile
        
        _isLoading = false;
        // Ferma lo spinner (non stiamo più caricando)
      });
    }
  }

  // ============================================
  // FUNZIONE: _selectGym()
  // ============================================
  // Questa funzione si chiama quando l'utente clicca su una palestra
  // Salva la palestra scelta e torna indietro
  //
  // INPUT:
  //   - gym: l'oggetto Place della palestra selezionata

  Future<void> _selectGym(Place gym) async {
    try {
      // ============================================
      // STEP 1: Ottieni accesso a SharedPreferences
      // ============================================
      // SharedPreferences è come un piccolo database sul telefono
      // Salva piccoli dati in modo permanente (anche quando chiudi l'app)

      final prefs = await SharedPreferences.getInstance();
      // prefs è l'istanza di SharedPreferences

      // ============================================
      // STEP 2: Converti la palestra in JSON
      // ============================================
      // SharedPreferences salva solo stringhe, non oggetti
      // Usiamo gym.toJson() per trasformare l'oggetto Place in testo JSON
      // jsonEncode() trasforma il Map in una stringa JSON
      //
      // ESEMPIO:
      // Place object → gym.toJson() → Map → jsonEncode() → Stringa JSON
      // {"id":"123","nome":"Fit Plus","indirizzo":"Via Roma 42", ...}

      await prefs.setString('selected_gym', jsonEncode(gym.toJson()));
      // ^ Salva la palestra con la chiave 'selected_gym'
      // Ora è salvata nel telefono e persisterà anche dopo chiusura!

      // ============================================
      // STEP 3: Mostra una conferma all'utente
      // ============================================
      // SnackBar è il messaggio che appare in basso
      // Comunica all'utente che tutto è andato bene

      if (mounted) {
        // "mounted" verifica che la pagina è ancora visibile
        // (serve per evitare errori se l'utente torna indietro troppo velocemente)
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${gym.nome} salvata come palestra!'),
            // Mostra il nome della palestra salvata
            
            duration: const Duration(seconds: 2),
            // Lo SnackBar scompare dopo 2 secondi
          ),
        );
      }

      // ============================================
      // STEP 4: Torna alla pagina precedente
      // ============================================
      // Navigator.pop() chiude questa pagina e torna indietro
      // La pagina Settings_Page si aggiornerà per mostrare la palestra salvata

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {
      // Se succede un errore durante il salvataggio,
      // mostra un messaggio di errore all'utente

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel salvataggio: $e')),
        );
      }
    }
  }

  // ============================================
  // BUILD: Costruisce la UI della pagina
  // ============================================
  // Qui definiamo come appare la pagina

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold è la struttura base di una pagina (AppBar, body, ecc)
      
      appBar: AppBar(
        // La barra in alto della pagina
        title: const Text('Cerca Palestre'),
        elevation: 0,
      ),

      body: _buildBody(),
      // _buildBody() è la funzione qui sotto che costruisce il corpo
      // Cambia a seconda dello stato (caricamento, errore, risultati, vuoto)

      floatingActionButton: FloatingActionButton(
        // Bottone rotondo in basso a destra
        onPressed: _searchNearbyGyms,
        // Quando clicchiamo, ricerchiamo di nuovo
        
        tooltip: 'Ricerca di nuovo',
        // Testo che appare se tieni premuto il bottone
        
        child: const Icon(Icons.refresh),
        // Icona di refresh
      ),
    );
  }

  // ============================================
  // FUNZIONE: _buildBody()
  // ============================================
  // Costruisce il corpo della pagina in base allo stato
  // Ci sono 4 possibili stati:
  // 1. Caricamento → mostra spinner
  // 2. Errore → mostra messaggio di errore
  // 3. Nessun risultato → mostra "non trovate"
  // 4. Risultati → mostra lista di palestre

  Widget _buildBody() {
    // ============================================
    // STATO 1: CARICAMENTO
    // ============================================
    if (_isLoading) {
      // Se _isLoading è true, mostra lo spinner
      return const Center(
        child: CircularProgressIndicator(),
        // CircularProgressIndicator è lo spinne rotante
      );
    }

    // ============================================
    // STATO 2: ERRORE
    // ============================================
    if (_errorMessage != null) {
      // Se c'è un messaggio di errore, mostralo

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona di errore rossa
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),

            // Titolo "Errore"
            Text(
              'Errore',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Messaggio di errore dettagliato
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                // ! significa "so che non è null"
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Bottone "Riprova"
            ElevatedButton(
              onPressed: _searchNearbyGyms,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    // ============================================
    // STATO 3: NESSUN RISULTATO
    // ============================================
    if (_gyms.isEmpty) {
      // Se la lista di palestre è vuota, mostra messaggio

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona di "nessun risultato"
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),

            // Titolo
            Text(
              'Nessuna palestra trovata',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Sottotitolo
            Text(
              'Prova a cercare di nuovo o spostati in un\'altra zona',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    // ============================================
    // STATO 4: MOSTRA I RISULTATI
    // ============================================
    // Se arriviamo qui, vuol dire che _gyms non è vuota
    // Mostriamo una lista di palestre

    return ListView.builder(
      // ListView.builder crea una lista scrollabile
      // È "builder" perché costruisce solo gli elementi visibili
      // (efficiente anche con migliaia di elementi)

      itemCount: _gyms.length,
      // Quanti elementi ha la lista? Tanti quanti sono _gyms

      itemBuilder: (context, index) {
        // itemBuilder è la funzione che costruisce ogni elemento
        // context: il contesto
        // index: l'indice dell'elemento (0, 1, 2, ...)

        final gym = _gyms[index];
        // Ottieni la palestra all'indice corrente

        return _buildGymTile(gym);
        // Costruisci il tile (elemento) per questa palestra
      },
    );
  }

  // ============================================
  // FUNZIONE: _buildGymTile()
  // ============================================
  // Costruisce un singolo elemento della lista (tile)
  // Mostra: icona, nome, indirizzo, e una freccia
  //
  // INPUT:
  //   - gym: l'oggetto Place da mostrare

  Widget _buildGymTile(Place gym) {
    return Card(
      // Card è un rettangolo con ombra
      // Fa parte di Material Design
      
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Spazio attorno al card

      child: ListTile(
        // ListTile è l'elemento standard per liste
        // Ha leading (sinistra), title, subtitle, trailing (destra)

        leading: const Icon(Icons.fitness_center, color: Colors.orange),
        // Icona a sinistra (simbolo palestra)

        title: Text(gym.nome),
        // Titolo: il nome della palestra
        // Es: "Palestra Fit Plus"

        subtitle: Text(gym.indirizzo),
        // Sottotitolo: l'indirizzo della palestra
        // Es: "Via Roma, 42"

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // Icona a destra (freccia) per indicare che è cliccabile

        onTap: () => _selectGym(gym),
        // Quando clicchi su questo tile, chiama _selectGym()
        // che salva la palestra e torna indietro
      ),
    );
  }
}

// ============================================
// FLUSSO COMPLETO DELLA PAGINA
// ============================================
//
// 1. PAGINA APRE
//    → initState() viene chiamato
//    → _searchNearbyGyms() viene chiamato automaticamente
//
// 2. _searchNearbyGyms() ESEGUE
//    → setState() mostra lo spinner
//    → Ottiene la posizione GPS
//    → Cerca le palestre con Overpass API
//    → setState() aggiorna _gyms con i risultati
//
// 3. LA UI SI AGGIORNA
//    → _buildBody() viene chiamato
//    → Se c'è caricamento → mostra spinner
//    → Se c'è errore → mostra errore
//    → Se _gyms è vuota → mostra "nessun risultato"
//    → Se _gyms ha elementi → mostra lista
//
// 4. UTENTE CLICCA SU UNA PALESTRA
//    → _selectGym(gym) viene chiamato
//    → La palestra viene salvata in SharedPreferences
//    → SnackBar mostra "Salvata!"
//    → Navigator.pop() torna alla pagina precedente
//    → La pagina Settings_Page si aggiorna e mostra la palestra