## SciencePulse Application
SciencePulse is an iOS application designed to keep you informed about the latest scientific discoveries, trends, and topics. The app provides a seamless and personalized experience for science enthusiasts, enabling them to explore, search, save, and discover a wide range of articles from trusted sources.

## Features
### Main Screens
**1-splash Screen**
* Features an engaging Lottie animation to enhance the user experience.

![Splash Screen](https://github.com/user-attachments/assets/ade8ebc3-5d6a-42a1-a863-7933516d6160)

**2-Home**
* Stay updated with the latest trends and breakthroughs in the scientific world.
  
  ![Home](https://github.com/user-attachments/assets/baa41270-aa0f-498d-8391-f734e1380307)

* Offline Mode: Displays an informative message when there is no internet connection.

![No network connection](https://github.com/user-attachments/assets/ddc639e1-cb88-4836-94e7-dbde26db3c25)

**3-Article Details Screen**
* View detailed content for selected articles.
* Save articles locally or remove them.
* Confirmation alerts before deletion enhance user control.

![Details](https://github.com/user-attachments/assets/7f476c40-de8e-4704-b6e8-979dff87de71)

![Delete Confirmation](https://github.com/user-attachments/assets/6e12969f-f7c0-4bf6-ae91-e504f97db574)

**4-Search and Filter by Date**
* Search for articles using keywords:
  
![Search](https://github.com/user-attachments/assets/f2f4a4b7-fc24-4146-8c89-9f1c443d7823)

**5-Filter results by selecting a specific date**
  
![Filet the search result](https://github.com/user-attachments/assets/af8f0d91-6577-48c8-a387-1eb3dba1938a)

  
**6-Saved Articles**
* Save your favorite articles locally for offline reading:
  
![Saved](https://github.com/user-attachments/assets/3278d169-9a9e-4038-a8ab-a9bd02d23d72)

**7-Other Topics**
Explore articles outside the realm of science for a broader perspective:

![Categories](https://github.com/user-attachments/assets/b9ab6977-88ac-499b-a584-cc9b2ba830cc)


## Technical Overview
* Reactive Programming: Utilizes Combine for real-time data updates and UI bindings.
* Architecture: Implements the MVVM (Model-View-ViewModel) pattern for clean code organization and maintainability.
* Networking: Fetches articles efficiently using URLSession and integrates the News API.
* Local Persistence: Uses Core Data for saving and retrieving articles, offering a smooth offline experience.
* User Interface: Built with UIKit and Nib files, ensuring a visually appealing, user-friendly design.
* Pagination: Implements smooth article loading as the user scrolls.
* Reachability: Monitors network connection status to provide a robust offline mode.

## Technical Enhancements:
#### Code Reusability with UIViewController Extension

To reduce redundancy and promote code reuse, an extension on UIViewController was implemented to add reusable methods used across multiple views.

![Screenshot 2024-11-28 at 1 53 41 PM](https://github.com/user-attachments/assets/9bc90847-dc2b-45e7-aef4-9e04ed3ea317)

#### Centralized Network Monitoring with NetworkBaseViewController
   
Centralized Network Monitoring: The app uses a NetworkBaseViewController class to encapsulate network monitoring logic. All other view controllers inherit this class to automatically monitor network status and handle changes efficiently.

![Screenshot 2024-11-28 at 1 58 14 PM](https://github.com/user-attachments/assets/ef5cf024-1a0d-4c53-8b24-d69a85d456b3)

##### How It Works?
1- Inheritability: Any view controller that needs network monitoring simply inherits NetworkBaseViewController.

2- Subclass Overrides: Override handleNetworkAvailable() and handleNoNetwork() in the subclass to customize behavior.

## Combine:
is used extensively in the app to manage reactive data updates and UI bindings,Below is an example of how Combine powers:
1- Fetching and Binding Articles:
  
![Data Task Publiser](https://github.com/user-attachments/assets/ea4f0016-fcb4-4fd9-adb6-44b25bb49cfa)

![Publiser in ViewModel](https://github.com/user-attachments/assets/07c20231-3c54-4f7a-8bc0-b121c06f7b58)

![Bind UI with ViewmModel](https://github.com/user-attachments/assets/ac91cbf6-d185-45be-a36f-9b0d57391c8e)

2- Search Optimization: 
Uses Combine’s PassthroughSubject and debounce operators for real-time yet efficient search functionality. This ensures only meaningful search queries trigger network calls.

![PassthroughSubject and Debounce](https://github.com/user-attachments/assets/04e5b323-f2f1-41e7-98e8-562e0f1121ac)

Enjoy exploring the wonders of science with SciencePulse! 🚀
