import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/enums/document_present_absent.dart';
import 'package:flutter_app/core/model/book.dart';
import 'package:flutter_app/core/network/http_get_books.dart';
import 'package:flutter_app/core/utils/colors.dart';
import 'package:flutter_app/core/utils/strings.dart';
import 'package:flutter_app/core/widgets/error_state.dart';
import 'package:flutter_app/core/widgets/loading_widget.dart';
import 'package:flutter_app/routes/router.gr.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SeeAllBooksPage extends StatefulWidget {
  final int category;

  SeeAllBooksPage({this.category = 0});

  _SeeAllBooksPageState createState() => _SeeAllBooksPageState();
}

class _SeeAllBooksPageState extends State<SeeAllBooksPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<int> _currentTab;
  TabController _tabController;
  Future<List<List<Book>>> _future;
  ValueNotifier<Document> _wishlistNotifier =
      ValueNotifier<Document>(Document.absent);
  ValueNotifier<Document> _readingNotifier =
      ValueNotifier<Document>(Document.absent);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _currentTab = ValueNotifier<int>(widget.category);
    _tabController =
        TabController(length: 10, vsync: this, initialIndex: widget.category);
    _future = NetworkCall().fetchBooksAccordingToCategory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget categoryBuilder(
      {@required int selectedIndex, String title, TextStyle style}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
      ),
    );
  }

  Widget searchBar(TextStyle style) {
    return GestureDetector(
      onTap: () {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Tapped on search',
            style: style.copyWith(color: Colors.white),
          ),
          backgroundColor: kDarkBlue,
          duration: Duration(seconds: 1),
        ));
      },
      child: Container(
        width: double.maxFinite,
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(color: kDarkBlue),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                color: kDarkBlue,
              ),
            ),
            Text(
              'Search books by name',
              style: style.copyWith(color: kDarkBlue),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _addToWishList(
      {FirebaseFirestore firestore,
      TextStyle style,
      int index,
      List<Book> bookList,
      BuildContext context,
      ValueNotifier wishlistNotifier}) async {
    var user = FirebaseAuth.instance.currentUser;
    return await firestore
        .collection(UsersCollection)
        .doc(user.uid)
        .collection(WishListCollection)
        .get()
        .then((snapshot) {
      for (var ds in snapshot.docs) {
        if (ds.data()['imgUrl'] == bookList[index].imgUrl) {
          wishlistNotifier.value = Document.present;
          break;
        } else {
          wishlistNotifier.value = Document.absent;
        }
      }
      if (wishlistNotifier.value == Document.present) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Book already exist',
            style: style.copyWith(color: Colors.white),
          ),
          backgroundColor: kDarkBlue,
          duration: Duration(seconds: 1),
        ));
      } else {
        firestore
            .collection(UsersCollection)
            .doc(user.uid)
            .collection(WishListCollection)
            .add({
          'title': bookList[index].title,
          'author': bookList[index].author,
          'imgUrl': bookList[index].imgUrl,
          'language': bookList[index].language,
          'pages': bookList[index].pages,
          'desc': bookList[index].desc,
          'category': bookList[index].category
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Added to wishlist',
            style: style.copyWith(color: Colors.white),
          ),
          backgroundColor: kDarkBlue,
          duration: Duration(seconds: 1),
        ));
      }
    });
  }

  Future<Null> _addToReadingList(
      {FirebaseFirestore firestore,
      TextStyle style,
      int index,
      List<Book> bookList,
      BuildContext context,
      ValueNotifier readingNotifier}) async {
    var user = FirebaseAuth.instance.currentUser;
    return await firestore
        .collection(UsersCollection)
        .doc(user.uid)
        .collection(ReadingCollection)
        .get()
        .then((snapshot) {
      for (var ds in snapshot.docs) {
        if (ds.data()['imgUrl'] == bookList[index].imgUrl) {
          readingNotifier.value = Document.present;
          break;
        } else {
          readingNotifier.value = Document.absent;
        }
      }
      if (readingNotifier.value == Document.present) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Book already exist',
            style: style.copyWith(color: Colors.white),
          ),
          backgroundColor: kDarkBlue,
          duration: Duration(seconds: 1),
        ));
      } else {
        firestore
            .collection(UsersCollection)
            .doc(user.uid)
            .collection(ReadingCollection)
            .add({
          'title': bookList[index].title,
          'author': bookList[index].author,
          'imgUrl': bookList[index].imgUrl,
          'language': bookList[index].language,
          'pages': bookList[index].pages,
          'desc': bookList[index].desc,
          'category': bookList[index].category
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Added to reading list',
            style: style.copyWith(color: Colors.white),
          ),
          backgroundColor: kDarkBlue,
          duration: Duration(seconds: 1),
        ));
      }
    });
  }

  Widget bookBuilder({List<Book> books, int index, TextStyle style}) {
    return FocusedMenuHolder(
      menuWidth: 170,
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text('Add to wish list',
                style: style.copyWith(color: Colors.black)),
            onPressed: () {
              _addToWishList(
                  firestore: _firestore,
                  index: index,
                  style: style,
                  wishlistNotifier: _wishlistNotifier,
                  bookList: books);
            },
            trailingIcon: Icon(
              FontAwesomeIcons.bookmark,
              size: 16,
            )),
        FocusedMenuItem(
            title: Text('Add to read next',
                style: style.copyWith(color: Colors.black)),
            onPressed: () {
              _addToReadingList(
                  firestore: _firestore,
                  index: index,
                  style: style,
                  readingNotifier: _readingNotifier,
                  bookList: books);
            },
            trailingIcon: Icon(
              FontAwesomeIcons.book,
              size: 16,
            )),
      ],
      onPressed: () => Navigator.pushNamed(context, PageRouter.bookPage,
          arguments: BookPageArguments(
              book: books[index],
              fromLibrary: false,
              index: index,
              bookList: books)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Image.network(
          books[index].imgUrl,
          height: 140,
          width: 100,
        ),
      ),
    );
  }

  Widget tabBody({List<Book> books, TextStyle style}) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        return bookBuilder(books: books, index: index, style: style);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      crossAxisCount: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText1;
    return SafeArea(
      child: FutureBuilder<List<List<Book>>>(
        future: _future,
        builder: (BuildContext context,
            AsyncSnapshot<List<List<Book>>> listOfBooks) {
          if (listOfBooks.connectionState == ConnectionState.done) {
            if (listOfBooks.hasError) {
              return ErrorStateBuilder();
            } else {
              return AnimatedBuilder(
                animation: Listenable.merge(
                    [_readingNotifier, _wishlistNotifier, _currentTab]),
                builder: (BuildContext context, Widget child) {
                  return Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ),
                    body: Column(
                      children: <Widget>[
                        TabBar(
                          controller: _tabController,
                          onTap: (index) {
                            _currentTab.value = index;
                          },
                          isScrollable: true,
                          labelStyle:
                              style.copyWith(fontWeight: FontWeight.w600),
                          unselectedLabelStyle:
                              style.copyWith(fontWeight: null),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black26,
                          indicatorColor: kDarkBlue,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 4,
                          tabs: [
                            categoryBuilder(
                                selectedIndex: 0,
                                title: 'Fiction',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 1,
                                title: 'Poetry',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 2,
                                title: 'Design',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 3,
                                title: 'Cooking',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 4,
                                title: 'Nature',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 5,
                                title: 'Philosophy',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 6,
                                title: 'Education',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 7,
                                title: 'Comics',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 8,
                                title: 'Health',
                                style: style),
                            categoryBuilder(
                                selectedIndex: 9,
                                title: 'Business',
                                style: style),
                          ],
                        ),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 10,
                                    blurRadius: 20)
                              ]),
                          child: Column(
                            children: <Widget>[
                              searchBar(style),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    tabBody(
                                        books: listOfBooks.data[0],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[1],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[2],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[3],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[4],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[5],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[6],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[7],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[8],
                                        style: style),
                                    tabBody(
                                        books: listOfBooks.data[9],
                                        style: style),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  );
                },
              );
            }
          } else
            return LoadingStateBuilder();
        },
      ),
    );
  }
}
