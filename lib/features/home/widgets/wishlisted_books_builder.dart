import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/model/book.dart';
import 'package:flutter_app/core/utils/colors.dart';
import 'package:flutter_app/core/utils/dimens.dart';
import 'package:flutter_app/core/utils/strings.dart';
import 'package:flutter_app/routes/router.gr.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WishListedBooksBuilder extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  WishListedBooksBuilder({this.scaffoldKey});

  @override
  _WishListedBooksBuilderState createState() => _WishListedBooksBuilderState();
}

class _WishListedBooksBuilderState extends State<WishListedBooksBuilder> {
  FirebaseAuth user = FirebaseAuth.instance;
  String userId = "uid";
  @override
  void initState() {
    if (user != null) {
      setState(() {
        userId = user.currentUser.uid;
      });
    }
    super.initState();
  }

  clearAll() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure you want to clear all books',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Warning',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            CupertinoButton(
                child: Text('Yes'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection(UsersCollection)
                      .doc(userId)
                      .collection(WishListCollection)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  });
                  Navigator.pop(context);
                  widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      'Cleared wishlist list',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                    backgroundColor: kDarkBlue,
                    duration: Duration(seconds: 1),
                  ));
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText1;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(userId)
          .collection(WishListCollection)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(top: 1200, left: 30),
            height: booksCardHolderHeight,
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 10, blurRadius: 20)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Wishlisted',
                        style: style.copyWith(
                            fontSize: 30, color: CupertinoColors.black),
                      ),
                      snapshot.data.docs.isEmpty
                          ? Container()
                          : GestureDetector(
                              onTap: clearAll,
                              child: Text(
                                'Clear',
                                style: style.copyWith(color: kDarkBlue),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hunt new books before other bookworms do it',
                    style: style.copyWith(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LimitedBox(
                    maxHeight: booksCardHolderLimitedHeight,
                    child: snapshot.data.docs.isEmpty
                        ? Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(emptyUrl),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Feed this list with books',
                                  style: style.copyWith(color: Colors.black26),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> readingBookData =
                                  snapshot.data.docs[index].data();
                              List<Book> books = [];
                              snapshot.data.docs.forEach((element) {
                                Book book = Book(
                                    title: element.data()['title'],
                                    author: element.data()['author'],
                                    imgUrl: element.data()['imgUrl'],
                                    desc: element.data()['desc'],
                                    language: element.data()['language'],
                                    category: element.data()['category'],
                                    pages: element.data()['pages']);
                                books.add(book);
                              });
                              Book book = Book(
                                  title: readingBookData['title'],
                                  author: readingBookData['author'],
                                  imgUrl: readingBookData['imgUrl'],
                                  desc: readingBookData['desc'],
                                  language: readingBookData['language'],
                                  category: readingBookData['category'],
                                  pages: readingBookData['pages']);
                              return FocusedMenuHolder(
                                menuWidth: 170,
                                menuItems: <FocusedMenuItem>[
                                  FocusedMenuItem(
                                      title: Text(
                                        'Remove',
                                        style: style.copyWith(
                                            color: CupertinoColors.white),
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection(UsersCollection)
                                            .doc(userId)
                                            .collection(WishListCollection)
                                            .doc(snapshot.data.docs[index].id)
                                            .delete();
                                        widget.scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Removed successfully',
                                            style: style.copyWith(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: kDarkBlue,
                                          duration: Duration(seconds: 1),
                                        ));
                                      },
                                      trailingIcon: Icon(
                                        Icons.delete,
                                        size: 18,
                                      ),
                                      backgroundColor: Colors.red),
                                  FocusedMenuItem(
                                      title: Text('Move to read next',
                                          style: style.copyWith(
                                              color: Colors.black)),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection(UsersCollection)
                                            .doc(userId)
                                            .collection(WishListCollection)
                                            .doc(snapshot.data.docs[index].id)
                                            .delete();
                                        FirebaseFirestore.instance
                                            .collection(UsersCollection)
                                            .doc(userId)
                                            .collection(ReadingCollection)
                                            .add({
                                          'title': book.title,
                                          'author': book.author,
                                          'imgUrl': book.imgUrl,
                                          'language': book.language,
                                          'pages': book.pages,
                                          'desc': book.desc,
                                          'category': book.category
                                        });
                                        widget.scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Moved to read next',
                                            style: style.copyWith(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: kDarkBlue,
                                          duration: Duration(seconds: 1),
                                        ));
                                      },
                                      trailingIcon: Icon(
                                        FontAwesomeIcons.book,
                                        size: 16,
                                      )),
                                ],
                                onPressed: () => Navigator.pushNamed(
                                    context, PageRouter.bookPage,
                                    arguments: BookPageArguments(
                                        book: book,
                                        fromLibrary: true,
                                        bookList: books,
                                        index: index)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 150,
                                        width: 100,
                                        child: Image.network(
                                          readingBookData['imgUrl'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        readingBookData['author'].length > 20
                                            ? '${readingBookData['author'].substring(0, 20)}...'
                                            : readingBookData['author'],
                                        style: style.copyWith(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        readingBookData['title'].length > 15
                                            ? '${readingBookData['title'].substring(0, 15)}...'
                                            : readingBookData['title'],
                                        style: style.copyWith(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
