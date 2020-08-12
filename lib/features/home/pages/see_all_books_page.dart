import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/model/book.dart';
import 'package:flutter_app/core/network/http_get_books.dart';
import 'package:flutter_app/core/utils/colors.dart';
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
  ValueNotifier<int> _currentTab;
  TabController _tabController;
  Future<List<Book>> _future;

  @override
  void initState() {
    super.initState();
    _currentTab = ValueNotifier<int>(widget.category);
    _tabController =
        TabController(length: 10, vsync: this, initialIndex: widget.category);
    _future = NetworkCall().fetchBooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget categoryBuilder({@required int selectedIndex, String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: TextStyle(
            color: _currentTab.value == selectedIndex
                ? Colors.black
                : Colors.black26,
            fontWeight:
                _currentTab.value == selectedIndex ? FontWeight.w600 : null,
            fontSize: 16),
      ),
    );
  }

  Widget searchBar(TextStyle style) {
    return Container(
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
    );
  }

  Widget bookBuilder({List<Book> books, int index, TextStyle style}) {
    return FocusedMenuHolder(
      menuWidth: 170,
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text('Add to wish list',
                style: style.copyWith(color: Colors.black)),
            onPressed: () {},
            trailingIcon: Icon(
              FontAwesomeIcons.bookmark,
              size: 16,
            )),
        FocusedMenuItem(
            title: Text('Add to read next',
                style: style.copyWith(color: Colors.black)),
            onPressed: () {},
            trailingIcon: Icon(
              FontAwesomeIcons.book,
              size: 16,
            )),
      ],
      onPressed: () => Navigator.pushNamed(context, Router.bookPage,
          arguments: BookPageArguments(book: books[index], fromLibrary: false)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Hero(
          tag: books[index].imgUrl,
          child: Image.network(
            books[index].imgUrl,
            height: 140,
            width: 100,
          ),
        ),
      ),
    );
  }

  Widget tabBody({List<Book> books, TextStyle style}) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      itemCount: 21,
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
      child: FutureBuilder<List<Book>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> books) {
          if (books.connectionState == ConnectionState.done) {
            if (books.hasError) {
              return Scaffold(
                backgroundColor: CupertinoColors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/error_state/error.png',
                        height: 150,
                        fit: BoxFit.fitHeight,
                      ),
                      Text(
                        'Oops something went wrong',
                        style:
                            style.copyWith(color: Colors.black26, fontSize: 12),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ValueListenableBuilder(
                builder: (BuildContext context, value, Widget child) {
                  return Scaffold(
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
                          labelColor: kDarkBlue,
                          indicatorColor: kDarkBlue,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 4,
                          tabs: [
                            categoryBuilder(selectedIndex: 0, title: 'Fiction'),
                            categoryBuilder(selectedIndex: 1, title: 'Poetry'),
                            categoryBuilder(selectedIndex: 2, title: 'Design'),
                            categoryBuilder(selectedIndex: 3, title: 'Cooking'),
                            categoryBuilder(selectedIndex: 4, title: 'Nature'),
                            categoryBuilder(
                                selectedIndex: 5, title: 'Philosophy'),
                            categoryBuilder(
                                selectedIndex: 6, title: 'Education'),
                            categoryBuilder(selectedIndex: 7, title: 'Comics'),
                            categoryBuilder(selectedIndex: 8, title: 'Health'),
                            categoryBuilder(
                                selectedIndex: 9, title: 'Business'),
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
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
                                    tabBody(books: books.data, style: style),
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
                valueListenable: _currentTab,
              );
            }
          } else
            return Scaffold(
              body: Center(
                child: Text(
                  'loading..',
                  style: style.copyWith(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w100,
                      fontSize: 20),
                ),
              ),
            );
        },
      ),
    );
  }
}
