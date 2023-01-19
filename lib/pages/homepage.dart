import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get; //only get function is needed
import '../model/models.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  late bool _isPortrait;
  final Random _random = Random();
  late String _randomYear;
  String _text = '';
  int? _year;
  bool _isLoading = false;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        appBar: _isPortrait
            ? AppBar(
                title: const Text(
                "Year Trivia Generator",
                style: TextStyle(color: Colors.white),
              ))
            : null,
        floatingActionButton: FloatingActionButton(
          onPressed: generateRandom,
          child: const Icon(Icons.shuffle),
        ),
        body: Stack(children: [_displayWidget(), _loading()]),
      ),
    );
  }

  void generateRandom() async {
    _randomYear = _random.nextInt(2050).toString();
    Uri uri = Uri.parse('http://numbersapi.com/$_randomYear/year?json');
    var response = await get(uri);
    YearModel yearModel = YearModel.named(json.decode(response.body));
    _isLoading = true;
    _year = yearModel.number;

    setState(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _text = yearModel.text;
          _isLoading = false;
        });
      });
    });
  }

  Widget _displayWidget() {
    return Center(
      child: Stack(
        children: [
          _scrollImage(),
          _yearBackgroundWidget(),
          _triviaWidget(),
        ],
      ),
    );
  }

  Widget _scrollImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/scroll.png'),
        ),
      ),
    );
  }

  Widget _triviaWidget() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeIn,
      opacity: !_isLoading ? 1 : 0,
      child: Padding(
        padding: EdgeInsets.all(
            _isPortrait ? _deviceWidth * .1 : _deviceHeight * .2),
        child: Center(
          child: Text(
            _text,
            style: GoogleFonts.jimNightshade(
                fontSize: _text.length > 180
                    ? 25
                    : _text.length > 120
                        ? 30
                        : 35,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _yearBackgroundWidget() {
    return Center(
      child: Text(
        _year == null ? '' : _year.toString(),
        style: GoogleFonts.jimNightshade(
          letterSpacing: 10,
          fontSize: 150,
          color: const Color.fromRGBO(150, 75, 0, .4),
        ),
      ),
    );
  }

  Widget _loading() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Visibility(
        visible: _isLoading,
        child: LoadingAnimationWidget.waveDots(
          color: Colors.brown,
          size: 50,
        ),
      ),
    );
  }
}
