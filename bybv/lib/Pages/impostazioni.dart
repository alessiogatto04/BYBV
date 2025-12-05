import 'package:bybv/Pages/modifica.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bybv/Theme/ThemeProvider.dart';


class Settings_Page extends StatelessWidget {
  const Settings_Page({super.key});
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

  @override
  Widget build(BuildContext context) {
    //Ottengo il provider e prelevo il tema in formato stringa e lo inserisco in label
    final themeProvider = Provider.of<ThemeProvider>(context);
    final label = getThemeLabel(themeProvider.themeMode);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Impostazioni",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

        ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Profilo", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Modifica()),
              );
            },
        ),

          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text("Lingua", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              
            ),
          ),

          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.white),
              title: Text("Tema", style: TextStyle(color: Colors.white)),
              subtitle: Text(label, style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.grey[900], // Sfondo scuro del BottomSheet
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
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          
                          // Titolo
                          Text(
                            "Seleziona il tema",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Opzione Sistema
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Sistema",
                                style: TextStyle(
                                  color: Colors.white,
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
                              activeColor: Colors.blue,
                            ),
                          ),
                          
                          // Opzione Scuro
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Scuro",
                                style: TextStyle(
                                  color: Colors.white,
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
                              activeColor: Colors.blue,
                            ),
                          ),
                          
                          // Opzione Chiaro
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: RadioListTile<ThemeMode>(
                              title: Text(
                                "Chiaro",
                                style: TextStyle(
                                  color: Colors.white,
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
                              activeColor: Colors.blue,
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
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text(
                "Guida Introduttiva",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              //  onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => GuidaIntroduttiva()),
              //   );
              // }, //ALTRA PAGINA CHIAMATA "GUIDA INTRODUTTIVA" DOVE CI SCRIVIAMO LO SCOPO DELL'APP, COME REGISTRARE ALLENAMENTI MA NON TROPPO CHE SE POI FACCIAMO FOTO E ALTRO PERDIAMO TANTO TANTO TEMPO
            ),
          ),
          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.question_mark_rounded, color: Colors.white),
              title: Text("Chi siamo?", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
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
