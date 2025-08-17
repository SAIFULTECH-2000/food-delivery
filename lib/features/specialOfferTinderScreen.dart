import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

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
      {
        'name': 'Agathiyan Kitchen',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM.jpeg?alt=media&token=4cf11977-a9d7-4def-b29f-37327d07b1b2',
        'percent': '20% OFF',
        'text': 'Get 20% off on all Tamil Nadu meals above RM40.',
      },
      {
        'name': 'Jaya Catering',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.50%20PM.jpeg?alt=media&token=6c9fd1ae-80c4-4a7c-aaf4-4a9c5638ced6',
        'percent': 'Buy 1 Get 1 Free',
        'text': 'BOGO deal on selected South Indian dishes.',
      },
      {
        'name': 'Kopitiam',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(1).jpeg?alt=media&token=581b1175-c70a-40b1-b801-73c066c50c0f',
        'percent': '15% OFF',
        'text': 'Enjoy traditional Malaysian breakfast with 15% off.',
      },
    ],
    'ms': [
      {
        'name': 'Dapur Agathiyan',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM.jpeg?alt=media&token=4cf11977-a9d7-4def-b29f-37327d07b1b2',
        'percent': 'Diskaun 20%',
        'text':
            'Dapatkan diskaun 20% untuk semua hidangan Tamil Nadu bernilai lebih RM40.',
      },
      {
        'name': 'Katering Jaya',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.50%20PM.jpeg?alt=media&token=6c9fd1ae-80c4-4a7c-aaf4-4a9c5638ced6',
        'percent': 'Beli 1 Percuma 1',
        'text':
            'Promosi beli satu percuma satu untuk hidangan India Selatan terpilih.',
      },
      {
        'name': 'Kopitiam',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(1).jpeg?alt=media&token=581b1175-c70a-40b1-b801-73c066c50c0f',
        'percent': 'Diskaun 15%',
        'text': 'Nikmati sarapan tradisional Malaysia dengan diskaun 15%.',
      },
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
          local.specialOffer,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
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
                    padding: const EdgeInsets.all(20),
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
                        // Vendor Logo
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(offer['logoUrl']!),
                        ),
                        const SizedBox(height: 16),

                        // Vendor Name
                        Text(
                          offer['name']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Percent
                        Text(
                          offer['percent']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          offer['text']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
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
