# FlatMates - iOS Roommate Matching App

FlatMates is a modern iOS application designed to help users find compatible roommates through a streamlined matching process.

## Architecture Diagram
<img width="1053" alt="Screenshot 2025-02-08 at 5 56 24 PM" src="https://github.com/user-attachments/assets/bce6cabc-fad6-4b76-ae08-832a6dcdd471" />

## [UI Design Files](https://uofc-my.sharepoint.com/:p:/g/personal/lilia_skumatova_ucalgary_ca/EUHMQlcYqvlNvSYzA0gcFBYBsWNq71Cm9gOUJicBBzhsPg?e=R5BOqs)
<img width="1010" alt="Screenshot 2025-02-08 at 5 54 17 PM" src="https://github.com/user-attachments/assets/ba3f6301-e38a-4df5-882e-67d311aa6cd4" />

## Features

### Smart Matching System
- Profile-based matching algorithm
- Preferences for smoking, pets, noise tolerance, and more
- Location-based roommate search

### User Authentication
- Secure email/password registration and login
- Profile creation and management
- Password reset functionality

### Interactive UI
- Swipe-based matching interface
- Real-time chat functionality
- Modern, intuitive design
- Comprehensive onboarding process

### Notifications
 - Real-time push notifications for new messages using Firebase Cloud Messaging (FCM).
 - iOS badge updates and in-app alerts to keep users informed and engaged.
   
### Pixabay API Integration
 - Leverages the Pixabay API to access a vast library of high-quality, royalty-free images.
 - Enhances the app’s visual appeal with dynamic image fetching, improving user experience.
   
### Profile Management
- Customizable user profiles
- Profile picture upload
- Lifestyle preferences settings
- Location preferences

### Messaging System
- Real-time chat with matches
- Message notifications
- Chat history management

## Technical Stack

### Frontend
- SwiftUI for UI components
- iOS 18.0+ support

### Backend
- Firebase Authentication
- Firebase Firestore for database
- Firebase Storage for media
- PixaBay API

## Requirements
- iOS 18.0 or later
- Xcode 16.0 or later
- Firebase account for backend services

## Test Instructions for Submission

### Create the first account:

- Sign up for a new account
- Fill out all profile and preference information completely
- Log out of the first account


### Create the second account:

- Sign up for another account
- Fill out all profile and preference information entirely
- Swipe right on the first account to express interest
- Log out of the second account


### Match the accounts:

- Log into the first account
- Swipe right on the second account to create a match
- Expect to see a match page displaying the connection between the accounts


### Initiate a conversation:

- On the match page, tap "Go to Match"
- The app should navigate to the chatting page with the second user account


### Test sending messages (First account):

- Type and send several messages to the second user account
- Log out of the first account


### Verify message reception (Second account):

- Log into the second user account
- Check if the messages sent from the first account have been received
- Log out of the second account


### Confirm message sync (First account):

- Log back into the first user account
- Verify that the messages sent from the second user are visible and synced correctly
## License

This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

We welcome contributions to FlatMates! Please feel free to submit issues and pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Contact

Project Link: [https://github.com/users/Anidion/projects/1/views/1](https://github.com/users/Anidion/projects/1/views/1)

---

Developed with ❤️ by Anshi, Ben, Bradley, Jessie, Joey, Lilia, Nayera and Youssef.

Development Continued by Kevin, Ivan, Anshi, Alina, Doowon, Jungsu, Lilia
