import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_game/card_item.dart';

class CardBoard extends StatefulWidget {
  final Function() onWin;

  const CardBoard({Key key, this.onWin}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardBoardState();
  }
}

class CardBoardState extends State<CardBoard> {
  List<int> openedCards = [];
  List<CardModel> cards;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cards = createCards();
  }

  List<CardModel> createCards() {
    List<String> asset = [];
    List(20).forEach((f) => asset.add('0${(asset.length + 1)}.jpg'));
    List(20).forEach((f) => asset.add('0${(asset.length - 20 + 1)}.jpg'));
    return List(40).map((f) {
      int index = Random().nextInt(1000) % asset.length;
      String _image =
          'asset/' + asset[index].substring(asset[index].length - 6);
      asset.removeAt(index);
      return CardModel(
          id: 40 - asset.length - 1, image: _image, key: UniqueKey());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 4,
        childAspectRatio: 322 / 433,
        children: cards
            .map((f) =>
            CardItem(key: f.key, model: f, onFlipCard: handleFlipCard))
            .toList());
  }

  void handleFlipCard(bool isOpened, int id) {
    cards[id].isNeedCloseEffect = false;

    checkOpenedCard(isOpened);

    if (isOpened) {
      setCardOpened(id);
      openedCards.add(id);
    } else {
      setCardNone(id);
      openedCards.remove(id);
    }

    checkWin();
  }

  void checkOpenedCard(bool isOpened) {
    if (openedCards.length == 2 && isOpened) {
      cards[openedCards[0]].isNeedCloseEffect = true;
      setCardNone(openedCards[0]);
      cards[openedCards[1]].isNeedCloseEffect = true;
      setCardNone(openedCards[1]);
      openedCards.clear();
    }
  }

  void checkWin() {
    if (openedCards.length == 2) {
      if (cards[openedCards[0]].image == cards[openedCards[1]].image) {
        setCardWin(openedCards[0]);
        setCardWin(openedCards[1]);
        openedCards.clear();
        widget.onWin();
      }
    }
  }

  void setCardNone(int id) {
    setState(() {
      cards[id].status = ECardStatus.None;
      cards[id].key = UniqueKey();
    });
  }

  void setCardOpened(int id) {
    setState(() {
      cards[id].status = ECardStatus.Opened;
      cards[id].key = UniqueKey();
    });
  }

  void setCardWin(int id) {
    setState(() {
      cards[id].status = ECardStatus.Win;
      cards[id].key = UniqueKey();
    });
  }
}
