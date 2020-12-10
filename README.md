# Real-World-Geometry

This is a proof of concept project that was inspired from UD HCI course Fall, 2020. There are basic 3 modules in many levels uses a different variation of AR. Level 1 is fully implemented and functional.
* “Learn the Basics”, uses no AR and simply has the user explore a geometric concept using the 2D environment. Feedbacks is given for both correct and incorrect answers.

* “Drop it in,” has the user explore their environment to solve geometric puzzles or activities placed in the AR environment, user is asked to find square shape. Currently, user can tap the screen to place a sqaure object on a detected plane. User can walk around and see the object from many perspectives.
 
* “Find it,” has the user interact with their environment to unveil the geometric concept. Currently, the app use open source ML core model to detect book and keyboard with confidence of 0.9. A green retangle shaped indicator will show up when objects are detected 

## Requirements

* Xcode 12
* iPhone with ios 14

## Set up
When you clone/download the code in Xcode, you will need to change the Signing & Capabilities --> Team into your account. Sometimes the Bundle Identififier is also needed to change.

## Acknowledgements
[1] https://developer.apple.com/machine-learning/models/
[2] https://medium.com/walmartglobaltech/build-your-first-ar-app-3c9f682d4c89
[3] https://rozengain.medium.com/using-vision-framework-object-detection-in-arkit-c0b5366f465d
