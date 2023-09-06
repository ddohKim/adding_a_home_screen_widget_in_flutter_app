import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'article_screen.dart';
import 'news_data.dart';

// New: Add these constants
// TO DO: Replace with your App Group ID
const String appGroupId = 'group.testingtesting'; ///앱 그룹 아이디를 둬야한다.
const String iOSWidgetName = 'NewsWidgets';  ///처음 widget extension 했을 때 name
const String androidWidgetName = 'NewsWidget';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
// New: add this function
void updateHeadline(NewsArticle newHeadline) {
  ///home_widget 패키지 기능 사용. key/value 값을 local db에 저장.
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>('headline_title', newHeadline.title);
  HomeWidget.saveWidgetData<String>(
      'headline_description', newHeadline.description);
  HomeWidget.updateWidget( ///위젯에 내용 update
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///초기 세팅할 때 home_widget 의 appgroupId를 세팅해서 updateHeadline 함수에서 사용 가능
    HomeWidget.setAppGroupId(appGroupId);
    // Mock read in some data and update the headline
    final newHeadline = getNewsStories()[0]; ///뉴스 headline 1개 가져온다.
    updateHeadline(newHeadline); ///headline 내용이 local_db에 저장
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Top Stories'),
            centerTitle: false,
            titleTextStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        body: ListView.separated(
          separatorBuilder: (context, idx) {
            return const Divider();
          },
          itemCount: getNewsStories().length,
          itemBuilder: (context, idx) {
            final article = getNewsStories()[idx];
            return ListTile(
              key: Key('$idx ${article.hashCode}'),
              title: Text(article.title!),
              subtitle: Text(article.description!),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ArticleScreen(article: article);
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
