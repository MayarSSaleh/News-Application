# News Application
An iOS application that demonstrates the use of Combine for reactive programming, MVVM architecture, URLSession networking, and Core Data for local storage. The app consists of three main screens: Home, Details, and Favorites.

# This app:
Fetches articles from the News API and allows users to save their favorite articles locally.
The app includes:

1- Home Screen: Displays a list of articles retrieved from the News API, with a search bar (UISearchBar) and date picker (UIDatePicker) for filtering articles.

![home](https://github.com/user-attachments/assets/ad6c7a01-d66b-47fc-a868-28d64aeb4a4c)
![filter by date](https://github.com/user-attachments/assets/d93a32fd-b364-41b0-867f-3fd0acedd12a)
![filter by topic and date](https://github.com/user-attachments/assets/5094f783-b06e-4142-9eb9-689ffcd6e0b5)

2- Details Screen: Shows detailed information about the selected article, with an option to save the article locally using Core Data.

![article details](https://github.com/user-attachments/assets/decf4db0-6f9b-4423-b27d-555c323a4486)
![artical added to favorites](https://github.com/user-attachments/assets/9b0d67a8-20d2-4797-af72-9c5e3a31910d)

3- Favorites Screen: Displays articles saved by the user, persisted locally with Core Data.
![favorites](https://github.com/user-attachments/assets/1c1cf513-2cab-431e-b5f5-c0d0c03cda4a)
![delete confirmation](https://github.com/user-attachments/assets/e62fa2aa-d472-4cc6-a92f-497f03289c6d)

# Features and Requirements:
* Reactive Programming: Uses Combine for reactive data updates and UI bindings.
* Architecture: MVVM (Model-View-ViewModel).
* Networking: Uses URLSession to fetch articles from the News API.
* Local Persistence: Uses Core Data to save and retrieve favorite articles.
* User Interface: Built with UIKit and Nib files for the UI layout.
* Version Control: Managed with Git and GitHub, following the Git flow methodology.

# App Workflow
1- Data Fetching: The Home Screen initially retrieves articles from the News API.

2- Article Filtering: Users can filter articles by search term or date using the search bar and date picker.

3- Navigation to Details Screen: When an article is tapped, the user is taken to the Details Screen, where more information about the selected article is displayed.

4- Saving Articles: Users can save the article to their favorites by tapping a designated button on the Details Screen.

5- Dismissal and Notification: Upon successful saving, the Details Screen dismisses, and a success alert notifies the user on the Home Screen.

6- Favorites Screen: The saved article appears on the Favorites Screen, where users can easily access and view their saved articles.
