import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(DividendCalculatorApp());
}

class DividendCalculatorApp extends StatelessWidget {
  const DividendCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dividend Calculator',
      theme: ThemeData(
        fontFamily: 'Sans',
        primaryColor: Colors.brown[700],
        scaffoldBackgroundColor: Colors.brown[50],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown)
            .copyWith(secondary: Colors.brown[300]),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.brown[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Colors.brown[800]),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.brown[900]),
          titleMedium: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fundController = TextEditingController();
  final _rateController = TextEditingController();
  final _monthsController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dividend Calculator'),
        backgroundColor: Colors.brown[700],
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.brown[100],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown[300]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_balance_wallet, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text('Dividend Calculator',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Minimalist Finance Tool', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.brown[800]),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.brown[800]),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _fundController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Investment Amount (\$)',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.brown[800]),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _rateController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Annual Rate (%)',
                  prefixIcon: Icon(Icons.percent, color: Colors.brown[800]),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _monthsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (Months)',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.brown[800]),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateDividend,
                child: Text('Calculate'),
              ),
              SizedBox(height: 24),
              Text(
                _result,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown[700]),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _calculateDividend() {
    final fund = double.tryParse(_fundController.text);
    final rate = double.tryParse(_rateController.text);
    final months = int.tryParse(_monthsController.text);

    if (fund == null || rate == null || months == null) {
      setState(() {
        _result = '⚠ Please enter valid numbers.';
      });
      return;
    }

    if (months < 1 || months > 12) {
      setState(() {
        _result = '⚠ Months must be between 1 and 12.';
      });
      return;
    }

    final monthlyDividend = (rate / 100) / 12 * fund;
    final totalDividend = monthlyDividend * months;

    setState(() {
      _result = '💸 Estimated Dividend: \$${totalDividend.toStringAsFixed(2)}';
    });
  }
}

class AboutPage extends StatelessWidget {
  final String githubUrl = 'https://github.com/yourusername/yourrepository';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.brown[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 80, color: Colors.brown[700]),
            SizedBox(height: 16),
            Text('Author: Nur Aliya Yasmin', style: TextStyle(fontSize: 18)),
            Text('Matric No: 2023103013', style: TextStyle(fontSize: 18)),
            Text('Course: ICT602', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'This app provides a quick estimate of investment dividends based on a monthly compound model.' ,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchURL(githubUrl),
              child: Text(
                'View GitHub Repository',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown[800],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Spacer(),
            Text('©️ 2025 Aliya Yasmin',
                style: TextStyle(fontSize: 14, color: Colors.brown[500])),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}