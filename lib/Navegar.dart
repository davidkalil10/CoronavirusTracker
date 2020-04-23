import 'package:coronvavirustracker/LinhadoTempo.dart';
import 'package:coronvavirustracker/ListaPaises.dart';
import 'package:coronvavirustracker/TelaPrincipal.dart';
import 'package:coronvavirustracker/Model/Timeline.dart';
import 'package:coronvavirustracker/Home.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Navegar extends StatefulWidget {
  @override
  _NavegarState createState() => _NavegarState();
}

class _NavegarState extends State<Navegar> {

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white,
            opacity: 1
        ),
        backgroundColor: Color(0xff598747),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("CORONAVÍRUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
            /*Text("//",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Righteous",
                ),
            ),*/
            Icon(Icons.assessment),
            Text("TRACKER",
              style: TextStyle(
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            ListaPaises(),
            TelaPrincipal(),
            LinhadoTempo(),
            LinhadoTempo(),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index){
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text("País"),
            icon: Icon(FontAwesomeIcons.globeAmericas)
          ),
          BottomNavyBarItem(
            title: Text("Dashboard"),
            icon: Icon(FontAwesomeIcons.tachometerAlt)
          ),
          BottomNavyBarItem(
            title: Text("Casos"),
            icon: Icon(FontAwesomeIcons.chartLine)
          ),
          BottomNavyBarItem(
            title: Text("Óbitos"),
            icon: Icon(FontAwesomeIcons.bookDead)
          ),
        ],
      ),
    );
  }
}
