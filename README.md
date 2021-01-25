# MUVI app

Muvi app is an app in play store, that aims to provide information about all the movies, released or unreleased based on the TMDb database. This repository holds the code base for that app.

## Getting Started

First thing first, if you have no idea about mobile app development or don't know "Flutter" means, then let me help you. It is a framework(a kind of a structure, to make a certain rules and provide certain functionalities) written in Dart programming language(you might have heard about programming languages like C, C++, JavaScript, etc, so it is another programming language built by Google) that aims to build hybrid mobile apps(In layman terms, an app that can run both on iOS and Android, from a single program that a developer writes). That is the jist of Flutter.

## Understanding Flutter and Installation

Don't worry if you don't know about flutter much, I didn't knew it too at first. One might say, it's kind of similar to JavaScript. Don't worry if you don't know JavaScript too, I didn't when I started. But before beginning, I would really recommend you to take a flutter beginner's course(on YouTube or anywhere you like). It will makes things really easy to understand. 

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## For the Developers

First thing we need to rename is the "/lib/common/api_credentials(rename-this).dart" file to "/lib/common/api_credentials.dart". This is the file where we store the API key for TMDb. 
Then, to get your own API key:-

1.  Create a free account at [TMDb official website](https://www.themoviedb.org/signup)
2.  Check your e-mail to verify your account.
3.  Visit the API Settings page in your Account Settings and request an API key
4.  You should now have an API key and be ready to go!

Just get a copy of this repository, paste your API key in the place of "YOUR_API_HERE" in the new "/lib/common/api_credentials.dart" file, and run the app. And voila! That's all there is to it. Customize it all to your liking.

