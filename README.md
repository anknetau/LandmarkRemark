#  Landmark Remark - Manifest

Created by Andres N. Kievsky.

## Approach Outline


- Created in Xcode 10.3, targetting iPhone devices on iOS 10 and up.
- Unit tests of View Models possible with careful separation between CoreLocation/API calls and rest of the architecture.
- MVVM: The app follows the modern MVVM pattern, with delegates for two way binding. In other projects, FRP can be used to simplify the binding.
- Coordinators: some simple examples of coordinators are used. These allow view controllers remain isolated from the methods used to display them.
- Service-based architecture: the networking layer is built on a service architecture which would normally be injected into ViewModels.
- Royalty-free images were taken from unsplash.com:
- Photo by Laura Cros on Unsplash
- Button images were taken from https://uxwing.com/
- git used for source control.

## Making implicit requirements explicit - imagined user journeys and requirements

1. Using a device's current location requires asking for access to location services. This access is required in order to use the app.
2. Focus view: Displaying the user's location as well as other views implies functionality should exist to focus the map on one or the other.
3. Results screen: searching for text implies the existence of a screen that can display a list of results, either on the map or in a separate list. A specific result can then be examined within the results.
4. Locality issues: a user may be interested in seeing results at the neighborhood level rather than a national or global level. Displaying both at the same time may trade resolution in the local level for completeness - and vice versa. Therefore, there's an expand button which will focus on all annotations, and a location (compass) button which will focus on the user's location.
5. Sign up and login: each user has their own username, coupled with a password to access the system. Users should also be able to sign up within the app. For simplicity, the app has a single screen that allows the user to enter a device-only name. No signup or login has been implemented for this test.
6. Update and delete: Being able to merely list and add locations is rarely sufficient for a user, update/delete functionality should exist, too, so users are able to fix errors. Ownership of the note should be used as a simple way to control access.

## Time Log

- UI: 8 hours
- Backend setup: 1 hour
- Architecture: 3 hours
- API layer: 4 hours
- Tests: 1 hour
- **Total**: ~17 hours

## Known issues, limitations and possible improvements

1. Location updates can affect battery life. This quick implementation does not take this into account and instead asks for continuous status updates.
2. For simplicity, the app has a single screen that allows the user to enter a device-only name (which is not stored). No signup or login has been implemented for this test - these are all simple improvements.
3. This app has not been tested in Xcode versions earlier than 10.3
4. This app requires swift 5 to run, as it uses the new Result type
5. As the app is required to target iOS 10 and up, the more flexible MKMarkerAnnotationView (iOS 11+) cannot be used. Instead, the older pin-style annotation has been used.
6. The app's device orientation is limited to portrait only.
7. The app has only been tested in the simulator
8. Obvious security issues exist with the unguarded API used - anyone on the internet with the right headers can make changes. In the real world, an auth system would be used, such as Auth0 or OAuth.
9. URL construction is done quickly via string operations rather than the correct URLComponents/URLQueryItem method.

