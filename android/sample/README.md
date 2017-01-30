SCG Push SDK
===

# Pre-requirements
Configured project for the Android platform using Gradle and Android Studio

# SDK Download and Install
## Download

> TODO: way to distribute the SDK

## Install

> TODO: way to distribute the SDK

# Setup library
Before starting using the SCG Push SDK, library must be initialized.

Follow the instructions for initializing [Firebase Messaging Client](https://firebase.google.com/docs/cloud-messaging/android/client) on Android.

- Replace `.MyFirebaseMessagingService` service with  `com.softavail.scg.push.sdk.ScgMessagingService`
- Replace `.MyFirebaseInstanceIDService` service with `com.softavail.scg.push.sdk.ScgInstanceIdService`

```xml
<application .... >
  <service android:name="com.softavail.scg.push.sdk.ScgMessagingService">
      <intent-filter>
          <action android:name="com.google.firebase.MESSAGING_EVENT" />
      </intent-filter>
  </service>
  <service android:name="com.softavail.scg.push.sdk.ScgInstanceIdService">
      <intent-filter>
          <action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
      </intent-filter>
  </service>
  <receiver android:name=".MainReceiver"
            android:exported="false"
            android:enabled="true">
    <intent-filter>
        <action android:name="com.softavail.scg.push.sdk.action.PUSH_TOKEN_RECEIVED"/>
        <action android:name="com.softavail.scg.push.sdk.action.MESSAGE_RECEIVED"/>
    </intent-filter>
  </receiver>
</application>
```

## Register broadcast receiver
To handle receiving push notifications and refresh push tokens you must register in manifest or from some `Activity` an broadcast receiver. This receiver must extends `ScgPushReceiver`.

```xml
<receiver android:name=".MainReceiver" android:exported="false" android:enabled="true">
  <intent-filter>
      <action android:name="com.softavail.scg.push.sdk.action.PUSH_TOKEN_RECEIVED"/>
      <action android:name="com.softavail.scg.push.sdk.action.MESSAGE_RECEIVED"/>
  </intent-filter>
</receiver>
```
Make sure that the broadcast is not exported `android:exporeted="false"`

You must implement:

- `onPushTokenReceived(String token)`

  Called when device push token is registered for first time or refreshed.

- `onMessageReceived(String messageId, RemoteMessage message)`

  Called when notification `message` with `messageId` arrived.

## Initialize with root URL and App ID
SDK Push library must be used as a singleton object. Before start using it,
you must initialize it with `rootUrl` and `appId`

You can initialize the library from every entry point, but `Application` class is preferred.

> Initialize in Applicaiton class:

```java
ScgClient.initialize(context, "http://api.example.com/v1","example.application.id");
```

After initialize instance of library can be obtain with:

```java
ScgClient client = ScgClient.getInstance();
```

Also you can check if library is initialized using `isInitiaized()` method:

```java
if (ScgClient.isInitiaized()) {
  // Library is initialized
  // Do further work
}
```

## Authentication

Before you can use SDK functionality (for example `register`/`unregister` push token or `delivery` report) you must authenticate using:

```java
ScgClient.getInstance().auth("validtoken");
```

# Register/Unregister push token

Device push token must registered before you can receive notifications. For both methods you must have properly initialized and authenticated library.

When device push token is refreshed or registered to the Firebase Messaging service you will
receive the it in the `onPushTokenReceived(String token)` method in the broadcast receiver you registered.

## Register

To register given `token` you must call `registerPushToken` with `ScgCallback`:

```java
ScgClient.getInstance().registerPushToken(token, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When registration was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When registration failed
  }
});
```

**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*

## Unregister

To unregister given `token` you must call `unregisterPushToken` with `ScgCallback`:

```java
ScgClient.getInstance().unregisterPushToken(token, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When unregistration was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When unregistration failed
  }
});
```

**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*

# Handle notifications

Notifications are arrived using broadcast receiver whatever application is in background or foreground. You must decide what to do with the message - you can build and show notification to the system or use the message inside your application UI.

Registering two broadcasts one in the manifest and one in activity will deliver same notification twice. You can abort the broadcast using `abortBroadcast()` method after you consume the event from one of the broadcast receivers.

## Notification data
All notification data is located in the `Map`:

```java
RemoteMessage message....
message.getData();
```

Available constants:
- `ScgPushReceiver.MESSAGE_ID`
- `ScgPushReceiver.MESSAGE_BODY`

> Retrieving message body or ID

```java
RemoteMessage message....
final String id = message.getData().get(ScgPushReceiver.MESSAGE_ID);
final String body = message.getData().get(ScgPushReceiver.MESSAGE_BODY)
```

There are constants you can use to extract some helpful data from notification message:

# Delivery report

Once message is arrived you can perform optionally delivery report by calling ` ScgClient.getInstance().deliveryConfirmation(messageId, callback);` with the `messageId` and some `callback`:

```java
ScgClient.getInstance().deliveryConfirmation(messageId, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When delivery was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When delivery report failed
  }
});
```

**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*