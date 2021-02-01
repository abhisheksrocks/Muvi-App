# MUVI app

This repository holds the code base for Muvi app. It's an app in play store, that aims to provide collective information about your favourite movies, based on the TMDb database via API calls. *But isn't that every other similar app? How's this different?* I'll tell you how! The idea was to create an app based on simple idea, but to overkill in terms of **UI design, UX and features**. What *features* am I talking about? Well here is the list:-

1.  Image Caching Mechanism - No image is ever downloaded twice, not even after restart, because every image is cached to phone storage.
2.  *Intelligent* Image Viewer - The app always shows the best resolution file, that we have downloaded, unless the *required resolution* of the image is more. What *required resolution* thingy? The developer has implemented a system, where the image is searched based on the width of the image placeholder, so a FullHD screen will download the 1080p resolution image when full screen placeholder is loaded, whereas 480p screen would download 480p image in that case.
3.  Clutter Cleaner - Don't worry, the app will automatically delete the old image, if a higher resolution is ever downloaded.
4.  State Management - The app is implemented using Cubit exclusively(as an experiment). The developer did rigorous testing to made sure no state was ever left. The state management is efficient enough to detect any real-time network changes and shows relavent warning/error messages.
5.  Slow internet friendly - First of all, internet is *precious*. And second, how slow are we talking? **5-8KB/s!** Yes, seriously! The developer kept the *Indian Janta* in mind, where 4G also feels like 2G in many places. So this was necessary😉.
6.  Cancellable API calls implementation - This is probably the most underated feature. If you are a flutter developer, than you might know that **API calls can't be cancelled** in Flutter. That's Dart by design! Right? Not anymore! The developer has implemented cancelable API calls feature in the app which you can actually test in the search section of the app(everytime you search, when a search is already loading) or generally when your netspeed is 5-8KB/s.
7.  Responsive Design - The app should work in any screen size. The developer didn't had a lot of screens to test this feature, but have tried to implement by following some common sense and logic. Why don't you try it out and let him know?
8.  Pagination - Don't you expect this of any app by default? Yeah, it's in here as well.

There is a long list of design choices/features, the developer is not going to write here(need clues- API fetch saver, custom button, poster gradient, scroll controller listener, etc). The list already is too long. Just know that a lot of thought went into creating this app, and the goal was primarily focused on creating an *experience*! You've been an awesome reader (**seriously!**). Enjoy the app!

Download the app from Play Store - [Link](https://play.google.com/store/apps/details?id=com.application.muvi_app&hl=en&gl=IN)

Original UI/UX Design - [Google Drive link(Adobe XD file)](http://bit.ly/2YqgRRk)

Original app announcement post - [LinkedIn Post](https://www.linkedin.com/posts/abhishek-97099b125_flutterdeveloper-androidapp-uidesign-activity-6761417122682851328-pYNl)

Fun fact - The LinkedIn post got just 4 likes the first day it was posted, of which 1 was the developer's himself.

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

Now paste your API key in the place of "YOUR_API_HERE" in the new "/lib/common/api_credentials.dart" file, and run the app. That's all there is to it. This should be enough to get you started. Customize it all to your liking. Developer's personal recommendation:-

1.  From the UI file (*that Google Drive link*), try to implement the other carousel version that the developer thought to create. Maybe use Horizontal ListViews instead of PageView(just a thought). That carousel file is "/lib/presentation/widgets/card_list_movies_carousel.dart".
2.  Make hero animation for the carousel. You can maybe start from "/lib/presentation/widgets/single_carousel_movie_card.dart".

