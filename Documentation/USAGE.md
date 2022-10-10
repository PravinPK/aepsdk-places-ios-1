# AEPPlaces Public APIs

This document contains usage information for the public functions, classes, and enums in `AEPPlaces`.

## Static functions

- [clear](#clear)
- [extensionVersion](#extensionVersion)
- [getCurrentPointsOfInterest](#getCurrentPointsOfInterest)
- [getLastKnownLocation](#getLastKnownLocation)
- [getNearbyPointsOfInterest](#getNearbyPointsOfInterest)
- [processRegionEvent](#processRegionEvent)
- [registerExtension](#registerExtension)
- [setAccuracyAuthorization](#setAccuracyAuthorization)
- [setAuthorizationStatus](#setAuthorizationStatus)

---

### clear

Clears out the client-side data for Places in shared state, local storage, and in-memory.

##### Swift

**Signature**
```swift
static func clear()
```

**Example Usage**
```swift
Places.clear()
```

##### Objective-C

**Signature**
```objc
+ (void) clear;
```

**Example Usage**
```objc
[AEPMobilePlaces clear];
```

---

### extensionVersion

Returns the running version of the AEPPlaces extension.

##### Swift

**Signature**
```swift
static var extensionVersion: String
```

**Example Usage**
```swift
let placesVersion = Places.extensionVersion
```

##### Objective-C

**Signature**
```objc
+ (nonnull NSString*) extensionVersion;
```

**Example Usage**
```objc
NSString *placesVersion = [AEPMobilePlaces extensionVersion];
```

---

### getCurrentPointsOfInterest

Returns all Points of Interest (POI) of which the device is currently known to be within.

##### Swift

**Signature**
```swift
static func getCurrentPointsOfInterest(_ closure: @escaping ([PointOfInterest]) -> Void)
```

**Example Usage**
```swift
Places.getCurrentPointsOfInterest() { currentPois in
    print("currentPois: \(currentPois)")
}
```

##### Objective-C

**Signature**
```objc
+ (void) getCurrentPointsOfInterest: ^(NSArray<AEPPlacesPoi*>* _Nonnull pois) closure;
```

**Example Usage**
```objc
[AEPMobilePlaces getCurrentPointsOfInterest:^(NSArray<AEPPlacesPoi *> *pois) {
    NSLog(@"currentPois: %@", pois);
}];
```

---

### getLastKnownLocation

Returns the last latitude and longitude provided to the AEPPlaces Extension.

If the Places Extension does not have a valid last known location for the user, the parameter passed in the closure will be `nil`. The CLLocation object returned by this method will only ever contain valid data for latitude and longitude, and is not meant to be used for plotting course, speed, altitude, etc.

##### Swift

**Signature**
```swift
static func getLastKnownLocation(_ closure: @escaping (CLLocation?) -> Void)
```

**Example Usage**
```swift
Places.getLastKnownLocation() { location in
    if let location = location {
        print("location returned from closure: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
    }
}
```

##### Objective-C

**Signature**
```objc
+ (void) getLastKnownLocation: ^(CLLocation* _Nullable lastLocation) closure;
```

**Example Usage**
```objc
[AEPMobilePlaces getLastKnownLocation:^(CLLocation *location) {
    if (location) {
        NSLog(@"location returned from closure: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
    }    
}];
```

---

### getNearbyPointsOfInterest

Requests a list of nearby Points of Interest (POI) and returns them in a closure.

##### Swift

**Signature**
```swift
static func getNearbyPointsOfInterest(forLocation location: CLLocation,
                                      withLimit limit: UInt,
                                      closure: @escaping ([PointOfInterest], PlacesQueryResponseCode) -> Void)
```

**Example Usage**
```swift
let location = CLLocation(latitude: 40.4350229, longitude: -111.8918356)
Places.getNearbyPointsOfInterest(forLocation: location, withLimit: 10) { (nearbyPois, responseCode) in    
    print("responseCode: \(responseCode.rawValue) - nearbyPois: \(nearbyPois)")
}
```

##### Objective-C

**Signature**
```objc
+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation
                             limit: (NSUInteger) limit
                          callback: ^ (NSArray<AEPPlacesPoi*>* _Nonnull, AEPPlacesQueryResponseCode) closure;
```

**Example Usage**
```objc
CLLocation *location = [[CLLocation alloc] initWithLatitude:40.4350229 longitude:-111.8918356];
[AEPMobilePlaces getNearbyPointsOfInterest:location
                                     limit:10
                                  callback:^(NSArray<AEPPlacesPoi *> *pois, AEPPlacesQueryResponseCode responseCode) {
    NSLog(@"responseCode: %ld", (long)responseCode);
    NSLog(@"nearbyPois: %@", pois);
}];
```

---

### processRegionEvent

Passes a `CLRegion` and a `PlacesRegionEvent` to be processed by the Places extension.

Calling this method will result in an Event being dispatched to the SDK's EventHub. This enables rule processing based on the triggering region event.

##### Swift

**Signature**
```swift
static func processRegionEvent(_ regionEvent: PlacesRegionEvent,
                               forRegion region: CLRegion)
```

**Example Usage**
```swift
let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.3886845, longitude: -111.8284979),
                              radius: 100,
                              identifier: "877677e4-3004-46dd-a8b1-a609bd65a428")

Places.processRegionEvent(.entry, forRegion: region)
```

##### Objective-C

**Signature**
```objc
+ (void) processRegionEvent: (AEPRegionEventType) eventType
                  forRegion: (nonnull CLRegion*) region;
```

**Example Usage**
```objc
CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.3886845, -111.8284979)
                                                             radius:100
                                                         identifier:@"877677e4-3004-46dd-a8b1-a609bd65a428"];

[AEPMobilePlaces processRegionEvent:AEPPlacesRegionEventEntry forRegion:region];
```

---

### registerExtension

This API no longer exists in `AEPPlaces`. Instead, the extension should be registered by calling the `registerExtensions` API in the `MobileCore`.

##### Swift

**Example:**
```swift
MobileCore.registerExtensions([Places.self])
```

##### Objective-C

**Example:**
```objc
[AEPMobileCore registerExtensions:@[AEPMobilePlaces.class] completion:nil];
```

---

### setAccuracyAuthorization

Sets the accuracy authorization status in the Places extension.

The value provided is stored in the Places shared state, and is for reference only. Calling this method does not impact the actual location accuracy authorization for this device.

##### Swift

**Signature**
```swift
static func setAccuracyAuthorization(_ accuracy: CLAccuracyAuthorization)
```

**Example Usage**
```swift
Places.setAccuracyAuthorization(.fullAccuracy)
```

##### Objective-C

**Signature**
```objc
+ (void) setAccuracyAuthorization: (CLAccuracyAuthorization) accuracy;
```

**Example Usage**
```objc
[AEPMobilePlaces setAccuracyAuthorization:CLAccuracyAuthorizationFullAccuracy];
```

---

### setAuthorizationStatus

Sets the authorization status in the Places extension.

The status provided is stored in the Places shared state, and is for reference only. Calling this method does not impact the actual location authorization status for this device.

> **Note**: This method should only be called from the `CLLocationManagerDelegate` protocol method  [locationManagerDidChangeAuthorization(_:)](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/3563956-locationmanagerdidchangeauthoriz).

##### Swift

**Signature**
```swift
static func setAuthorizationStatus(_ status: CLAuthorizationStatus)
```

**Example Usage**
```swift
// in the class implementing CLLocationManagerDelegate:

func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    Places.setAuthorizationStatus(manager.authorizationStatus)
}
```

##### Objective-C

**Signature**
```objc
+ (void) setAuthorizationStatus: (CLAuthorizationStatus) status;
```

**Example Usage**
```objc
// in the class implementing CLLocationManagerDelegate:

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [AEPMobilePlaces setAuthorizationStatus:manager.authorizationStatus];
}
```

---

## Additional Classes and Enums

| Type | Swift | Objective-C |
| ---- | ----- | ----------- |
| class | `PointOfInterest` | `AEPPlacesPoi` |
| enum | `PlacesQueryResponseCode` | `AEPlacesQueryResponseCode` |
| enum | `PlacesRegionEvent` | `AEPPlacesRegionEvent` |

#### PointOfInterest

| Name | Data Type |
| ---- | --------- |
| identifier | String |
| latitude | Double |
| libraryId | String |
| longitude | Double |
| metaData | [String: Any] |
| name | String |
| radius | Int |
| userIsWithin | Bool |
| weight | Int |

#### PlacesQueryResponseCode

| Case | Raw Value |
| ---- | ---------
| ok | 0 |
| connectivityError | 1 |
| serverResponseError | 2 |
| invalidLatLongError | 3 |
| configurationError | 4 |
| queryServiceUnavailable | 5 |
| privacyOptedOut | 6 |
| unknownError | 7 |

#### PlacesRegionEvent

| Case | Raw Value |
| ---- | --------- |
| entry | 0 |
| exit | 1 |
