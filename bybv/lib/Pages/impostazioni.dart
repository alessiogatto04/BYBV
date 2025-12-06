import 'package:bybv/Pages/modifica.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bybv/Theme/ThemeProvider.dart';
import 'package:bybv/Geolocalization/ricerca_palestra_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Settings_Page extends StatefulWidget { //L'ho dovuta mettere statefull la pagina di impostazioni perchè mi serve il setstate() nella ricerca della palestra
  const Settings_Page({super.key});

  @override
  State<Settings_Page> createState() => _Settings_PageState();
}
class _Settings_PageState extends State<Settings_Page> { 
  // MI creo questa funzione helper per la conversione in stringa dello stato attuale cosi da visualizzarlo nel riga del tema il tema attuale
  String getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Chiaro';
      case ThemeMode.dark:
        return 'Scuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }
  // Questa funzione mostra quale palestra è salvata
  Widget _buildSelectedGymSubtitle() {
    return FutureBuilder<String?>(
      // FutureBuilder permette di eseguire codice asincrono
      
      future: _getSelectedGymName(),
      // Chiama la funzione che legge la palestra salvata
      
      builder: (context, snapshot) {
        // snapshot contiene il risultato della Future
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se ancora sta caricando
          return const SizedBox.shrink();
          // Non mostrare niente
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          // Se ha trovato una palestra salvata
          return Text(
            snapshot.data!,
            // Mostra il nome della palestra
            
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // Se il nome è troppo lungo, taglia e metti "..."
          );
        }
        
        // Se non c'è nessuna palestra salvata
        return Text(
          'Nessuna palestra scelta',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
          ),
        );
      },
    );
  }

  // Questa funzione legge la palestra salvata da SharedPreferences
  Future<String?> _getSelectedGymName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // prefs accede ai dati salvati nel telefono
      
      final gymJson = prefs.getString('selected_gym'); // è come un dizionario il sharedPreferences quindi ci accede tramite questa stringa e legge la chiave
      // Leggi la palestra salvata
      
      if (gymJson != null) {
        // Se c'è una palestra salvata
        final gymData = jsonDecode(gymJson);
        // Trasforma il JSON in un Map
        
        return gymData['nome'] as String;
        // Restituisci il nome della palestra
      }
      
      return null;
      // Se non c'è nessuna palestra, ritorna null
      
    } catch (e) {
      return null;
      // Se c'è un errore, ritorna null
    }
  }


  @override
  Widget build(BuildContext context) {
    //Ottengo il provider e prelevo il tema in formato stringa e lo inserisco in label
    final themeProvider = Provider.of<ThemeProvider>(context);
    final label = getThemeLabel(themeProvider.themeMode);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Impostazioni",
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

        ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
            title: Text("Profilo", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Modifica()),
              );
            },
        ),

          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
              title: Text("Lingua", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
              
            ),
          ),

          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.dark_mode, color: Theme.of(context).iconTheme.color),
              title: Text("Tema", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              subtitle: Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    final themeProvider = Provider.of<ThemeProvider>(context); // IMPORTANTE: aggiungi questa riga
                    
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.03,
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Barretta grigia in alto
                          Container(
                            width: screenWidth * 0.12,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          
                          // Titolo
                          Text(
                            "Seleziona il tema",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Opzione Sistema
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor, 
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor,
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Sistema",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontFamily: 'Poppins',
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              value: ThemeMode.system,
                              groupValue: themeProvider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themeProvider.setThemeMode(value);
                                  Navigator.pop(context);
                                }
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          
                          // Opzione Scuro
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor, 
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor,
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Scuro",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontFamily: 'Poppins',
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              value: ThemeMode.dark,
                              groupValue: themeProvider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themeProvider.setThemeMode(value);
                                  Navigator.pop(context);
                                }
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          
                          // Opzione Chiaro
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor, 
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor,
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Chiaro",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontFamily: 'Poppins',
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              value: ThemeMode.light,
                              groupValue: themeProvider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themeProvider.setThemeMode(value);
                                  Navigator.pop(context);
                                }
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.fitness_center, color: Theme.of(context).iconTheme.color),
              // ^ Cambio icona da "help" a "fitness_center" (più appropriata)
              
              title: Text(
                "Palestra",
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              
              subtitle: _buildSelectedGymSubtitle(),
              //Mostra quale palestra è salvata
              
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
              
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GymSearchPage()),
                  // ^ Naviga a GymSearchPage quando clicchi
                ).then((_) {
                  // then() si chiama quando torni indietro
                  setState(() {});
                  // setState() aggiorna la pagina per mostrare la nuova palestra salvata se viene cambiata
                });
              }, 
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.help, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Guida Introduttiva",
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
              //  onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => GuidaIntroduttiva()),
              //   );
              // }, //ALTRA PAGINA CHIAMATA "GUIDA INTRODUTTIVA" DOVE CI SCRIVIAMO LO SCOPO DELL'APP, COME REGISTRARE ALLENAMENTI MA NON TROPPO CHE SE POI FACCIAMO FOTO E ALTRO PERDIAMO TANTO TANPO TEMPO
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.question_mark_rounded, color: Theme.of(context).iconTheme.color),
              title: Text("Chi siamo?", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.grey),
              //onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ChiSiamo()),
              //   );
              // }, //STESSA COSA DI SOPRA, AL MASSIMO NELLA PAGINA "CHI SIAMO" CI METTIAMO GIUSTO LA DESCRIZIONE DEI SOGGETTI 
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
//prova prova