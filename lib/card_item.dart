import 'package:flutter/material.dart';

class CardItem extends StatefulWidget {
  final CardModel model;
  final Function(bool isOpened, int id) onFlipCard;

  CardItem({Key key, this.model, this.onFlipCard})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardItemState();
  }
}

class CardItemState extends State<CardItem> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> frontScale;
  Animation<double> backScale;
  String imagePrimary, imageSecondary;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    frontScale = new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    backScale = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );


    if (widget.model.status == ECardStatus.None) {
      imagePrimary = widget.model.image;
      imageSecondary = 'asset/00.jpg';
    } else {
      imagePrimary = 'asset/00.jpg';
      imageSecondary = widget.model.image;
    }

    if (widget.model.isNeedCloseEffect) {
      controller.reverse(from: 1.0);
      widget.model.isNeedCloseEffect = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Center(
          child: widget.model.status == ECardStatus.Win
              ? buildImage(widget.model.image)
              : Stack(
                  children: <Widget>[
                    buildCardLayout(backScale, imagePrimary),
                    buildCardLayout(frontScale, imageSecondary),
                  ],
                ),
        ),
        onTap: flipCard);
  }

  Widget buildCardLayout(Animation<double> animation, String image) {
    return AnimatedBuilder(
      child: buildImage(image),
      animation: animation,
      builder: (BuildContext context, Widget child) {
        final Matrix4 transform = new Matrix4.identity()
          ..scale(animation.value, 1.0, 1.0);
        return new Transform(
          transform: transform,
          alignment: FractionalOffset.center,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void flipCard() {
    if (widget.model.status != ECardStatus.Win) {
      setState(() {
        if (controller.isCompleted || controller.velocity > 0) {
          controller
              .reverse()
              .then((v) => widget.onFlipCard(false, widget.model.id));
        } else {
          controller.forward().then((v) => widget.onFlipCard(
              widget.model.status == ECardStatus.None, widget.model.id));
        }
      });
    }
  }

  Widget buildImage(String image) {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Image.asset(image),
    );
  }
}

enum ECardStatus { None, Win, Opened }

class CardModel {
  String image;
  int id;
  ECardStatus status;
  bool isNeedCloseEffect;
  Key key;

  CardModel(
      {this.key,
      this.image,
      this.id,
      this.isNeedCloseEffect = false,
      this.status = ECardStatus.None});
}
