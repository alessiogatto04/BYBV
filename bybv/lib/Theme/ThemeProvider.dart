import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // import del provider aggiunto a pusbec.yaml e installato con flutter pub get da terminale



//IL provider è un gestore dello stato. Ad esempio se tipo abbiamo un ' contenitore' che tiene traccia di quale tema è attivo e avvisa tutta l'app quando cambia . In particolare abbiamo che 
//ChangeNotifier è una classe speciale che può notificare i widget quando qualcosa cambia.
class ThemeProvider extends ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.system; // _themeMode è privata per quella cosa di poo , come convenzione e salvo lo stato del tema . Mentre ThemeMode.system significa tipo " usa il tema del dispositivo"(se il telefono è in dark mode , usa dark mode)
  // le altre opzioni che poi avremo sono : themeMode.Ligth e ThemeMode.dark
  ThemeMode get themeMode => _themeMode; // questo è un getter : permmette ad altri file di leggere il valore di _themeMode . Non possono modificarlo direttamente (è privato) ma possono vedere qual'è il tema attuale 


  // Questo metodo è un getter che ho creato perchè ci restituisce false se siamo in modalità scura e false se siamo in modalità chiara. Se l'utente ha scelto "Segui sistema " controlla il tema del telefono e mi è utile poi nelle impostazioni per mostrare uno switch on/of per il tema
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system){
      return WidgetsBinding.instance.window.platformBrightness ==Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  //SharedPreferences è un package che ci permette di salvare dati semplici in modo persistene sul dispositivo ( come le impostazioni dell'utente ). idati rimangono salvati anche quando chiudi e riapri l'app . Può salvare : 
  //stringhe , interi , booleani , double , liste di stringhe 
  //Esempio di utilizzo : 
  // Salvare un valore
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.setString('tema', 'scuro');
  // await prefs.setBool('notifiche', true);
  // Leggere un valore
  // final tema = prefs.getString('tema') ?? 'chiaro'; // valore di default se non esiste
  // final notifiche = prefs.getBool('notifiche') ?? false;
  // per usarlo dobbiamo aggiungere al pusbec.yaml quello che c'ho aggiunto dentro (controlla e capisci)
  //Carica la preferenza salvata 
  Future<void> loadThemePreference() async{
    final prefs = await SharedPreferences.getInstance(); //SharedPreferences è come un piccolo database locale che salva coppie chiave-Valore (tipo un dizionario); mentre getInstance() ottiene l'accesso a questo database 
    // infine l'await aspetta che l'operazione finisca ( perchè deve leggere tipo dal disco e quindi questa cosa ci mette un pò)
    // Qua invece cerchiamo una stringa salvata con la chiave 'theme_mode" , se non trova nulla ( priva volta che apri l'app) usa 'ssytem' come default ( usa il ?? che sarebbe 'se null usa questo valore')
    final savedTheme = prefs.getString('theme_mode') ?? 'system';

    //qua semplicemente invece grazie al valore theme_mode si regola sul valore da impostare 
    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners(); // quando chiamo NotifyListener(), tutti i widget attivi che sono in ascolto di questo provider si ricostruiscono automaticamente (appartiene alla classe ActionListener)
  }

  //Usiamo questa funzione per cambiare il tema in base a quello che abbiamo associato a _themeMode , che viene innanzitutto aggiornata , poi avvisa i widget con notifyListeners()
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance(); //salva la preferenza nel database locale
    String modeString = mode == ThemeMode.light ? 'light' : //converte il themeMode in una stringa da usare dentro il metoodo per il set del tema precedente 
                        mode == ThemeMode.dark ? 'dark' : 'system';
    await prefs.setString('theme_mode', modeString); // set string salva nel dizionario la chiave valore , così quando riapriamo l'app il tema rimane salvato 
  }
}