# CSCI342-Assignment3
CSCI319 Assignment 3 - iOS Swift


--------------------------------------------------------------------------------

Name:			Matthew Saliba
Subject:		CSCI342
Student Num:	3284165
Desc:			Ass3

--------------------------------------------------------------------------------

Installation and running instructions

1) download and unzip the folder,
2) open the extracted folder
3) click on the "ass3.xcodeproj" file
4) README.md file contains design choices for the available view controllers

Notes

- Project must be run in iPhone 6 simulator
- Size for each view in the "Main.storyboard" should be set to iPhone 4.7-inch

--------------------------------------------------------------------------------

Design reasoning

-----------------------------------

Main Page

Map is placed in the centre of the screen to provide a central focal point for user interaction.

It is the biggest element because it is what we want the user to interact with to enable the secondary features of the UI.

Placing additional secondary elements can become confusing, distract the user and lead them down a different navigational path than what we want.

By allowing for certain elements to be available at a given time, we can direct the user's choices more effectively.

When the user touches on the map for an extended period, a pin will appear as will a button to view the satellite images of this area

The button has been placed directly under the map on appearance. This is because it is a secondary element within the layout's hierarchy.

-----------------------------------

Map Image Views

Loading Screen: Is shown when a user clicks to view a set of map images.

An overlaying colour has been added with an animating image and text status label.

These elements combine to notify the user the status of their request. In particular, without the updating text label, the loading screen on it's
own was too confusing and felt as if the app had crashed. Having the label self update as the requests were received provided the required notification.

-----------------------------------

Map Image View

Follows a similar hierarchy to the main map page.

The resulting images have been placed at the top and in the main central point of the screen.

It is the first and biggest element in view because it is what the user has requested to see.

Additional information based elements, such as the date have been placed underneath to support the displaying images.

--------------------------------------------------------------------------------

