import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/core/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class SpecialOfferSwiperScreen extends StatefulWidget {
  final String languageCode; // 'en' or 'ms'

  const SpecialOfferSwiperScreen({super.key, required this.languageCode});

  @override
  State<SpecialOfferSwiperScreen> createState() =>
      _SpecialOfferSwiperScreenState();
}

class _SpecialOfferSwiperScreenState extends State<SpecialOfferSwiperScreen> {
  final Map<String, List<Map<String, String>>> localizedOffers = {
    'en': [
      {'percent': '30%', 'text': 'Discount only\nvalid for today!'},
      {'percent': 'Buy 1', 'text': 'Get 1 Free\nOn all snacks!'},
      {'percent': '20%', 'text': 'Off for new\nbreakfast items!'},
    ],
    'ms': [
      {'percent': '30%', 'text': 'Diskaun hanya\nsah untuk hari ini!'},
      {'percent': 'Beli 1', 'text': 'Dapat 1 Percuma\nUntuk semua snek!'},
      {'percent': '20%', 'text': 'Diskaun untuk\nmenu sarapan baru!'},
    ],
  };

  final CardSwiperController _controller = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    final offers =
        localizedOffers[widget.languageCode] ?? localizedOffers['en']!;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          local.specialOffer, // use your localization key
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.iconTheme?.color,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: CardSwiper(
              controller: _controller,
              cardsCount: offers.length,
              allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                horizontal: true,
              ),
              isLoop: true,
              cardBuilder: (context, index, percentX, percentY) {
                final offer = offers[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.8),
                          Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          offer['percent']!,
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          offer['text']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                debugPrint('Swiped from $previousIndex to $currentIndex');
                return true;
              },
              onEnd: () {
                debugPrint('All cards swiped!');
              },
            ),
          ),
        ),
      ),
    );
  }
}
