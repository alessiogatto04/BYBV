// ============================================
// WORKOUT UTILS - FUNZIONI HELPER
// ============================================
// Questo file contiene funzioni semplici per ottenere:
// - Orario attuale
// - Giorno della settimana
// - Stagione (inverno/estate/primavera/autunno)
// 
// Usale nella tua pagina "Avvia Allenamento"

import 'package:intl/intl.dart';
import 'dart:math';

class WorkoutUtils {
  
  // ============================================
  // FUNZIONE 1: Ottieni l'ORARIO ATTUALE
  // ============================================
  // Restituisce l'orario in formato stringa (es: "18:30")
  
  static String getCurrentTime() {
    final now = DateTime.now();
    // DateTime.now() = data e ora attuale del dispositivo
    
    final formatter = DateFormat('HH:mm');
    // HH:mm = formato 24 ore (es: 18:30, non 6:30 PM)
    
    return formatter.format(now);
    // Restituisce qualcosa tipo: "18:30"
  }

  // ============================================
  // FUNZIONE 2: Ottieni il GIORNO DELLA SETTIMANA
  // ============================================
  // Restituisce il giorno in italiano (es: "Lunedì", "Martedì", ecc)
  
  static String getDayOfWeek() {
    final now = DateTime.now();
    // DateTime.now() = data e ora attuale
    
    final days = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica',
    ];
    // Lista dei giorni della settimana in italiano
    // L'indice 0 = Lunedì, 1 = Martedì, ecc
    
    return days[now.weekday - 1];
    // now.weekday ritorna 1-7 (1=lunedì)
    // Sottraiamo 1 per ottenere l'indice della lista (0-6)
    // Restituisce: "Lunedì", "Martedì", ecc
  }

  // ============================================
  // FUNZIONE 3: Ottieni la DATA COMPLETA
  // ============================================
  // Restituisce la data in formato stringa (es: "06/12/2024")
  
  static String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    // dd/MM/yyyy = giorno/mese/anno
    // Es: 06/12/2024
    
    return formatter.format(now);
  }

  // ============================================
  // FUNZIONE 4: Ottieni la STAGIONE
  // ============================================
  // Restituisce la stagione in cui siamo (inverno/primavera/estate/autunno)
  //
  // REGOLE (Emisfero Nord - Italia):
  // - Inverno: 21 dicembre - 20 marzo
  // - Primavera: 21 marzo - 20 giugno
  // - Estate: 21 giugno - 22 settembre
  // - Autunno: 23 settembre - 20 dicembre
  
  static String getSeason() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;
    
    // Controlla il mese e il giorno per determinare la stagione
    if ((month == 12 && day >= 21) || (month <= 3 && day <= 20)) {
      return 'Inverno';
      // Dal 21 dicembre al 20 marzo
    } else if ((month == 3 && day >= 21) || (month <= 6 && day <= 20)) {
      return 'Primavera';
      // Dal 21 marzo al 20 giugno
    } else if ((month == 6 && day >= 21) || (month <= 9 && day <= 22)) {
      return 'Estate';
      // Dal 21 giugno al 22 settembre
    } else {
      return 'Autunno';
      // Dal 23 settembre al 20 dicembre
    }
  }

  // ============================================
  // FUNZIONE 5: OTTIENI CONSIGLIO IN BASE A TUTTO
  // ============================================
  // Questa è la funzione PRINCIPALE che usa le altre
  // Prende orario, giorno, stagione e restituisce un consiglio
  //
  // INPUT: niente (usa tutto automaticamente)
  // OUTPUT: un consiglio in formato stringa
  
  static String getWorkoutAdvice() {
    final time = getCurrentTime();
    // Estrai solo l'ora (primi 2 caratteri)
    final hour = int.parse(time.split(':')[0]);
    // time è "18:30", split(':') lo divide in ["18", "30"]
    // int.parse() trasforma "18" nel numero 18
    
    final day = getDayOfWeek();
    final season = getSeason();
    
    // ============================================
    // SWITCH CASE PER L'ORARIO
    // ============================================
    
    String timeAdvice;
    
    if (hour >= 6 && hour < 12) {
      timeAdvice = '🌅 Mattina: Perfetto per fare cardio e riscaldamento!';
    } else if (hour >= 12 && hour < 17) {
      timeAdvice = '☀️ Pomeriggio: Buon momento per allenamenti intensi!';
    } else if (hour >= 17 && hour < 21) {
      timeAdvice = '🌆 Sera: Ottimo per pesi e forza!';
    } else {
      timeAdvice = '🌙 Notte: Tardi per allenarsi, prova domani mattina!';
    }
    
    // ============================================
    // SWITCH CASE PER LA STAGIONE
    // ============================================
    
    String seasonAdvice;
    
    switch (season) {
      case 'Inverno':
        seasonAdvice = '❄️ Inverno: Riscaldati bene prima di iniziare!';
        break;
      case 'Primavera':
        seasonAdvice = '🌸 Primavera: Perfetto! Corpo ideale per allenarsi!';
        break;
      case 'Estate':
        seasonAdvice = '☀️ Estate: Bevi molta acqua durante l\'allenamento!';
        break;
      case 'Autunno':
        seasonAdvice = '🍂 Autunno: Inizia a riscaldarti più del solito!';
        break;
      default:
        seasonAdvice = '';
    }
    
    // ============================================
    // SWITCH CASE PER IL GIORNO
    // ============================================
    
    String dayAdvice;
    
    switch (day) {
      case 'Lunedì':
        dayAdvice = '💪 Lunedì: Giorno perfetto per iniziare la settimana!';
        break;
      case 'Mercoledì':
        dayAdvice = '🔥 Mercoledì: Sei a metà settimana, dai il massimo!';
        break;
      case 'Sabato':
        dayAdvice = '🎯 Sabato: Buon giorno per allenamenti lunghi!';
        break;
      case 'Domenica':
        dayAdvice = '😴 Domenica: Riposa e recupera per la prossima settimana!';
        break;
      default:
        dayAdvice = '📅 ${day}: Continua con gli allenamenti regolari!';
    }
    
    // ============================================
    // COMBINA TUTTI I CONSIGLI
    // ============================================
    // Ritorna una stringa con tutti i consigli combinati
    
    return '''
$timeAdvice

$seasonAdvice

$dayAdvice

Orario: $time
Data: ${getCurrentDate()}
''';
    // Restituisce un testo formattato con tutti i consigli
  }

  // ============================================
  // FUNZIONE BONUS: SALVA SESSIONE DI ALLENAMENTO
  // ============================================
  // Restituisce un Map con tutti i dati della sessione
  // che puoi salvare in SharedPreferences
  
  static Map<String, String> createWorkoutSession() {
    return {
      'time': getCurrentTime(),
      'date': getCurrentDate(),
      'day': getDayOfWeek(),
      'season': getSeason(),
      'timestamp': DateTime.now().toIso8601String(),
      // timestamp serve per ordinare le sessioni in futuro
    };
  }

  // ============================================
  // FUNZIONE: CONTROLLA SE SEI IN PALESTRA
  // ============================================
  // Verifica se sei vicino alla palestra salvata
  // Ritorna true se sei vicino, false altrimenti
  //
  // INPUT:
  //   - userLat: la tua latitudine attuale
  //   - userLon: la tua longitudine attuale
  //   - gymLat: la latitudine della palestra
  //   - gymLon: la longitudine della palestra
  //   - radiusMeters: quanto vicino devi essere (di default 200 metri)
  //
  // OUTPUT:
  //   - true se sei dentro il raggio, false altrimenti
  
  static bool isNearbyGym(
    double userLat,
    double userLon,
    double gymLat,
    double gymLon,
    {double radiusMeters = 200}
  ) {
    // ============================================
    // CALCOLA LA DISTANZA TRA DUE PUNTI GPS
    // ============================================
    // Usiamo la formula di Haversine
    // (è la formula standard per calcolare distanze GPS)
    
    const double earthRadiusMeters = 6371000;
    // Raggio della Terra in metri
    
    // Converti i gradi in radianti (la formula lavora con radianti)
    final dLat = _toRadians(gymLat - userLat);
    final dLon = _toRadians(gymLon - userLon);
    final lat1 = _toRadians(userLat);
    final lat2 = _toRadians(gymLat);
    
    // Formula di Haversine
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceMeters = earthRadiusMeters * c;
    
    // ============================================
    // CONTROLLA SE LA DISTANZA È DENTRO IL RAGGIO
    // ============================================
    return distanceMeters <= radiusMeters;
    // Restituisce true se sei dentro, false se sei fuori
  }
  
  // ============================================
  // FUNZIONE HELPER: Converti gradi in radianti
  // ============================================
  // (Funzione ausiliaria per la formula di Haversine)
  
  static double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
    // π / 180 = conversione da gradi a radianti
  }
}

