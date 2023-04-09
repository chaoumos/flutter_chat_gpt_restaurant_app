# Restaurant Ordering App

This is a Flutter project for a restaurant ordering app created with the help of ChatGpt. The app uses Getx for state management, and it has a demo Stripe payment system. Please note that this app is for demonstration purposes only, and no API key should be present in the app. The app also uses the Firebase auth UI package for authentication and Firestore database.

## Dependencies

- Flutter SDK: ">=2.19.0 <3.0.0"
- cupertino_icons: ^1.0.2
- get: ^4.6.5
- flutter_rating_bar: ^4.0.1
- badges: ^3.0.2
- http: ^0.13.5
- flutter_stripe: ^8.0.0+1
- firebase_core: ^2.7.0
- cloud_firestore: ^4.4.3
- firebase_ui_auth: ^1.1.14
- firebase_auth: ^4.2.9
- firebase_ui_oauth_google: ^1.0.21
- flutter_dotenv: ^5.0.2

## Installation

To use this project, follow these steps:

Clone this repository to your local machine.
Run

```console
flutter pub get
```

to install all the dependencies.
more information on how to install Flutter [here](https://flutter.dev/docs/get-started/install).

# Run the app using

To run the project, run the following command:

```console
flutter run
```

This app allows users to browse a restaurant's menu, add items to their cart, and checkout using a demo Stripe payment system. The app also has authentication functionality provided by the Firebase auth UI package. The app stores all the user and order data in the Firestore database.

# Contribution

Contributions are always welcome! If you want to contribute to this project, please fork this repository and submit a pull request with your changes.

## Assets

This project uses a .env file as an asset.

## License

This project is licensed under the MIT License. You can find more information in the LICENSE file.
