import 'package:flutter/material.dart';

class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final location in locations)
              LocationListItem(
                imageUrl: location.imageUrl,
                name: location.name,
                country: location.place,
              )
          ],
        ),
      ),
    );
  }
}


class LocationListItem extends StatelessWidget {
  final GlobalKey _backgroundImageKey = GlobalKey();

   LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country
  });

  final String imageUrl;
  final String name;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubTitle()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
        delegate: ParallaxFlowDelegate(
            scrollableState: Scrollable.of(context),
          listItemContext: context,
          backgroundImageKey: _backgroundImageKey,
        ),
    children: [
      Image.network(
          key: _backgroundImageKey,
          imageUrl,
          fit: BoxFit.cover
      ),
    ]);
  }

  Widget _buildGradient() {
    return Positioned.fill(
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.6, 0.95],
                )
            )
        )
    );
  }

  Widget _buildTitleAndSubTitle() {
    return Positioned(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Text(country,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                )),

          ],
        )
    );
  }
}


class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollableState,
    required this.listItemContext,
    required this.backgroundImageKey
  }) : super(repaint: scrollableState.position);

  final ScrollableState scrollableState;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;


  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // TODO: implement getConstraintsForChild
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
    final scrollableBox = scrollableState.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox
    );

    final viewportDimension = scrollableState.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);
    
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);
    
    final backgroundSize = (backgroundImageKey.currentContext!.findRenderObject() as RenderBox).size;
    
    final listItemSize = context.size;
    
    final childRect = verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(0, transform: Transform.translate(offset: Offset(0.0, childRect.top)).transform
    );

  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return scrollableState != oldDelegate.scrollableState ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }

}



class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}


const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
Location
(
name: 'Mount Rushmore',
place: 'U.S.A',
imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
),
Location(
name: 'Gardens By The Bay',
place: 'Singapore',
imageUrl: '$urlPrefix/02-singapore.jpg',
),
Location(
name: 'Machu Picchu',
place: 'Peru',
imageUrl: '$urlPrefix/03-machu-picchu.jpg',
),
Location(
name: 'Vitznau',
place: 'Switzerland',
imageUrl: '$urlPrefix/04-vitznau.jpg',
),
Location(
name: 'Bali',
place: 'Indonesia',
imageUrl: '$urlPrefix/05-bali.jpg',
),
Location(
name: 'Mexico City',
place: 'Mexico',
imageUrl: '$urlPrefix/06-mexico-city.jpg',
),
Location(
name: 'Cairo',
place: 'Egypt',
imageUrl: '$urlPrefix/07-cairo.jpg'
)];