# hive_sync_firebase

Flutter Hive + Firebase Sync App

This project is a Flutter-based offline-first mobile app that stores and syncs transaction data using Hive and Firebase Firestore. It follows Clean Architecture principles and uses BLoC for state management.

Key Features:
    1.Add, view, and sync transactions
    2.Offline-first support using Hive
    3.Automatic sync to Firebase when network is available
    4.Error handling using the dartz package with Either<Failure, T>


 Architecture: Clean Structure:
    UI (BlocBuilder)  
        ↓  
    BLoC (Events → States)  
        ↓  
    UseCases (Application Logic)  
        ↓  
    Repository (Domain Interface)  
        ↓  
    RepositoryImpl (Data Layer)  
        ↓  
    LocalDataSource (Hive) + RemoteDataSource (Firebase)

 Sync Flow:
    1.User adds a transaction → Stored immediately in Hive (offline)
    2.App tries to sync to Firebase via RemoteTransactionDataSource
    3.If sync is successful → Marked isSynced = true in Hive
    4.If failed → Kept as isSynced = false for later retry


 Key Functions & Concepts Used:
📦 Hive (Local Storage)
TransactionModel is a Hive object

1.Data is saved to Hive using:
    await box.put(model.id, model);

2.Adapter registered via:
    Hive.registerAdapter(TransactionModelAdapter());

☁️ Firebase Firestore (Cloud Sync):

1.Syncs transactions to Firestore using:
    firestore.collection('transactions').doc(model.id).set({...});

🔄 Sync Logic
2.Unsynced transactions are filtered via:
    box.values.where((model) => !model.isSynced);
On successful sync, data is marked as synced:


Hive Reference:
Read this article to learn more about Hive integration:
👉 Hive Database in Flutter – Medium Article by Raju Potharaju


Technologies Used:
    1. Flutter
    2. Hive (Local NoSQL DB)
    3. Firebase Firestore
    4. Dartz (Either<Failure, T>)
    5. Clean Architecture
    6. BLoC (flutter_bloc)

