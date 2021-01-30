# MUVI app

Muvi is an app in play store, that aims to provide collective information about your favourite movies, based on the TMDb database via API calls. This repository holds the code base for that app.

[Visit the app on Play Store](https://play.google.com/store/apps/details?id=com.application.muvi_app&hl=en&gl=IN)

If you are interested to see the initial UI designs that the developer did:
[Download the UI Design of the App(Adobe XD file)](http://bit.ly/2YqgRRk)

## Getting Started

First thing first, do you know what flutter is? Its a framework(a kind of a structure, to make a certain rules and provide certain functionalities) written in Dart programming language(you might have heard about programming languages like C, C++, JavaScript, etc, so it is another programming language built by Google) that aims to build hybrid mobile apps(in layman terms, an app that can run both on iOS and Android, from a single program that a developer writes).

## Understanding Flutter and Installation

Don't worry too much if you don't know flutter coding. But before beginning, I would really recommend you to take a flutter beginner's course(on YouTube or anywhere you like). It will makes things really easier to understand. 

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## For the Developers

To begin with, fork or clone this repository. Rename the "/lib/common/api_credentials(rename-this).dart" file to "/lib/common/api_credentials.dart". This is the file where we store the API key for TMDb. 
Then, to get your own API key:-

1.  Create a free account at [TMDb official website](https://www.themoviedb.org/signup)
2.  Check your e-mail to verify your account.
3.  Visit the API Settings page in your Account Settings and request an API key
4.  You should now have an API key and be ready to go!

Now paste your API key in the place of "YOUR_API_HERE" in the new "/lib/common/api_credentials.dart" file, and run the app. That's all there is to it. This should be enough to get you started. Customize it all to your liking.

