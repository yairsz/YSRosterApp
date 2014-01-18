YSRosterApp
===========

RosterApp done in Code Fellows week 1

The app has the following features:

- Table view with each students and teachers name.
- Touching the name takes you to a detail view controller.
- The detail view is a scroll view that changes position according to user interaction.
- Each student has an image, a twitter and a github account. A color can also be set for each one.
- An image of the student can be set through a UIImagePickerController.
- The camera can be used only if it's available on the device.
- Permissions for the users library are checked and handled.
- The user can take a photo or pick an image from the users image library.
- The color picker button brings up the sliders view and saves the color to that user.
- The github and twitter and github fields can be set using the normal ios keyboard workflow.
- The scroll view moves to reveal the textfields when the keyboard comes up.
- All data entered is permanently stored to the users documents directory using the NSCoding Protocols.
- AN EMAIL CAN BE SENT WITH ALL THE DATA COLLECTED BY THE USER!




MVC Design Pattern Features:

Model:
- Data model consists of the YSPerson class. Its attributes are name, twitter, github, image path, and color.

View:
- Created a custom table view cell that sets its own contents by taking a YSPerson as a parameter.
- The App uses a UITableView and UIScrollView that have a variety of subviews.

Controller:
- All data is handled by a data controller called YSTableDataSource. This is a singleton class initialized from the App delegate.
- There are two main controllers:
    1) YSViewController handles the names view.
    2) YSScrollViewController handles the detailview
