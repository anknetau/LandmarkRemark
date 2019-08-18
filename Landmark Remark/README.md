#  Landmark Remark - Manifest

Created by Andres N. Kievsky.

## Approach Outline


- Created in Xcode 10.3, targetting iPhone devices on iOS 10 and up.
- git
- tests
- MVVM-C
- Services

## Making implicit requirements explicit - imagined user journeys and requirements

1. Finding current location can be done through...
2. Using a device's current location requires asking for access to location services.
3. Focus view: Displaying the user's location as well as other views implies functionality should exist to focus the map on one or the other.
4. Results screen: searching for text implies the existence of a screen that can display a list of results, either on the map or in a separate list. A specific result can then be examined within the results.
5. Locality issues: a user may be interested in seeing results at the neighborhood level rather than a national or global level. Displaying both at the same time may trade resolution in the local level for completeness - and vice versa.
6. Sign up and login: each user has their own username, coupled with a password to access the system. Users should also be able to sign up within the app.
7. Update and delete: Being able to merely list and add locations is rarely sufficient for a user, update/delete functionality should exist, too, so users are able to fix errors. Ownership of the note should be used as a simple way to control access.
8. 

## Time Log

## Known issues, limitations and possible improvements

This app has not been tested in Xcode versions earlier than 10.3.

bettery life

database
os version
tested against what?
scalability
security

### POS


### Accessibility


### Additional QA
