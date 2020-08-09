import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/core/colors.dart';
import 'package:flutter_app/core/dimens.dart';
import 'package:flutter_app/core/model/book.dart';
import 'package:flutter_app/core/strings.dart';
import 'package:flutter_app/features/home/presentation/pages/see_all_books_page.dart';
import 'package:flutter_app/routes/router.gr.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Widget _title(TextStyle style) {
    return Container(
      margin: EdgeInsets.only(top: 100, left: 30),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            'Book',
            style: style.copyWith(
                fontWeight: FontWeight.w900, fontSize: 30, color: kDarkBlue),
          ),
          Text('shelf',
              style: style.copyWith(
                  fontWeight: FontWeight.w100,
                  fontSize: 25,
                  color: CupertinoColors.white))
        ],
      ),
    );
  }

  Positioned userDp() {
    return Positioned(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: kDarkBlue,
        child: Icon(
          Icons.person,
          color: CupertinoColors.white,
        ),
      ),
      top: 20,
      right: 20,
    );
  }

  Widget buildNewBooksListView({TextStyle style, List<Book> books}) {
    return Container(
      margin: EdgeInsets.only(top: 230, left: 30),
      height: booksCardHolderHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 10, blurRadius: 20)
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
                  'Discover new',
                  style: style.copyWith(
                      fontSize: 30, color: CupertinoColors.black),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeeAllBooksPage())),
                  child: Text(
                    'see all',
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length ?? 0,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 100,
                        child: Image.network(
                          books[index].imgUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        books[index].author,
                        style: style.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        books[index].title.length > 10
                            ? '${books[index].title.substring(0, 10)}...'
                            : books[index].title,
                        style:
                            style.copyWith(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWishListedBooksListView({TextStyle style, List<Book> books}) {
    return Container(
      margin: EdgeInsets.only(top: 1200, left: 30),
      height: booksCardHolderHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 10, blurRadius: 20)
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
                Text(
                  'see all',
                  style: style.copyWith(color: kDarkBlue),
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 100,
                        child: Image.network(
                          books[index].imgUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        books[index].author,
                        style: style.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        books[index].title.length > 10
                            ? '${books[index].title.substring(0, 10)}...'
                            : books[index].title,
                        style:
                            style.copyWith(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContinueReadingBooksListView(
      {TextStyle style, List<Book> books}) {
    return Container(
      margin: EdgeInsets.only(top: 820, right: 30),
      height: booksCardHolderHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 10, blurRadius: 20)
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
                  'Continue Reading',
                  style: style.copyWith(
                      fontSize: 30, color: CupertinoColors.black),
                ),
                Text(
                  'see all',
                  style: style.copyWith(color: kDarkBlue),
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
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 100,
                        child: Image.network(
                          books[index].imgUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        books[index].author,
                        style: style.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        books[index].title.length > 10
                            ? '${books[index].title.substring(0, 10)}...'
                            : books[index].title,
                        style:
                            style.copyWith(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFinishedReadingBooksListView(
      {TextStyle style, List<Book> books}) {
    return Container(
      margin: EdgeInsets.only(top: 1580, right: 30),
      height: booksCardHolderHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 10, blurRadius: 20)
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
                  'Finished',
                  style: style.copyWith(
                      fontSize: 30, color: CupertinoColors.black),
                ),
                Text(
                  'see all',
                  style: style.copyWith(color: kDarkBlue),
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
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 100,
                        child: Image.network(
                          books[index].imgUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        books[index].author,
                        style: style.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        books[index].title.length > 10
                            ? '${books[index].title.substring(0, 10)}...'
                            : books[index].title,
                        style:
                            style.copyWith(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container searchBar(TextStyle style) {
    return Container(
      width: double.maxFinite,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: kDarkBlue),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 170),
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

  Container buildCategories(TextStyle style) {
    return Container(
      margin: EdgeInsets.only(top: 600),
      height: 300,
      width: double.maxFinite,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Categories',
                style:
                    style.copyWith(fontSize: 30, color: CupertinoColors.black),
              ),
              Text(
                'see all',
                style: style.copyWith(color: kDarkBlue),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          LimitedBox(
            maxHeight: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                categoryChild(style: style, title: 'Fiction', category: 0),
                categoryChild(style: style, title: 'Poetry', category: 1),
                categoryChild(style: style, title: 'Design', category: 2),
                categoryChild(style: style, title: 'Cooking', category: 3),
                categoryChild(style: style, title: 'Nature', category: 4),
                categoryChild(style: style, title: 'Philosophy', category: 5),
                categoryChild(style: style, title: 'Education', category: 6),
                categoryChild(style: style, title: 'Comics', category: 7),
                categoryChild(style: style, title: 'Health', category: 8),
                categoryChild(style: style, title: 'Business', category: 9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryChild({TextStyle style, String title, int category}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Router.seeAllBooksPage,
          arguments: category),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/books/categories/${title.toLowerCase()}.svg',
              height: 30,
              width: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: style.copyWith(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '45 books',
              style: style.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Book>> getBooks() async {
    List<Book> books = [];
    Response response =
        await get('$baseUrl?q=subject:fiction&maxResults=40&key=$apiKey');
    var data = jsonDecode(response.body);
    data['items'].forEach((data) {
      Book book = Book(
          title: data['volumeInfo']['title'],
          imgUrl: data['volumeInfo']['imageLinks']['thumbnail'],
          author: data['volumeInfo']['authors'][0]);
      books.add(book);
    });
    return books;
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText1;
    return SafeArea(
      child: FutureBuilder<List<Book>>(
        future: getBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> books) {
          if (books.connectionState == ConnectionState.done) {
            if (books.hasError) {
              return Text(books.error);
            } else {
              return Scaffold(
                body: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: <Widget>[
                      Image.network(loginPageImgUrl),
                      _title(style),
                      userDp(),
                      searchBar(style),
                      buildNewBooksListView(style: style, books: books.data),
                      buildCategories(style),
                      buildContinueReadingBooksListView(
                          style: style, books: books.data),
                      buildWishListedBooksListView(
                          style: style, books: books.data),
                      buildFinishedReadingBooksListView(
                          style: style, books: books.data),
                    ],
                  ),
                ),
              );
            }
          } else
            return Center(
              child: Text(
                'loading..',
                style: style.copyWith(
                    color: kDarkBlue,
                    fontWeight: FontWeight.w100,
                    fontSize: 20),
              ),
            );
        },
      ),
    );
  }
}