# Covid-Tracker
This project uses iOS location tracking and unsupervised learning to predict highly populated areas with covid.

UI: Swift and Apple's Mapkit, Database: Firebase

The app stores user locations on firebase and upon update, calls a google cloud function to write back to firebase cluster locations using Sklearn DBScan.
