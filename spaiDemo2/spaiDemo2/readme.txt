






To complete set up, add this authorization callback URL to your app configuration in the Apple Developer Console. Additional steps may be needed to verify ownership of this web domain to Apple.
https://spaidemo2.firebaseapp.com/__/auth/handler



## Schedule:

Things that have been completed:
- AI asking a test question verbally.
- Users answering the question verbally.
- Users can take 4 types of speaking tests.
- Privacy concerns related to microphones, recording, etc.
- Runnign the app on a device

Yet to be revised:
- Google Signin
- UI/UX
- Int Scoring / Str Grading  - expected to take 2 weeks
- AI voice configurations (currently set to default values used in the iOS native framework) - expected to take 1 week

Future works:
- Wave Animation based on volume
- Profile Tab bar
- History (will be easily adjusted once the scoring/grading works well)
- Allowing users to take four different types of tests at once
- Checking App Store release regulations
- Dark mode


- test ends, submit button, send the result to us



Errors we got while creating the history feature(*all resolved):
1. 10.20.0 - [FirebaseFirestore][I-FST000001] AppCheck failed: 'The operation couldn’t be completed. The attestation provider DeviceCheckProvider is not supported on current platform and OS version.'
2. Error saving test history: Missing or insufficient permissions.
3. 10.20.0 - [FirebaseFirestore][I-FST000001] WriteStream (106f323c8) Stream error: 'Permission denied: Missing or insufficient permissions.'
4. 10.20.0 - [FirebaseFirestore][I-FST000001] Write at users/DUnBD1k93QQK528iwwku3CWuKqH3/testHistory/nzFkEfZ8xShAEyzr495r failed: Missing or insufficient permissions.
How to resolve above errors:
*1*   i. try use an actual device(not the Xcode simulator)
    ii. If URL is shown in the error, probably need to go to the cloud conlose to enable something.
        Configure DeviceCheck on the Apple Developer Portal:
            Go to the Apple Developer Portal.
            Navigate to "Certificates, Identifiers & Profiles".
            Select "Identifiers" and then your app's identifier.
            Ensure that "DeviceCheck" is enabled for your app identifier. If it's not, edit the identifier settings to enable it.
        Set up DeviceCheck in Firebase:
            Go to the Firebase Console.
            In the "App Check" section, go to App, and set the DeviceCheck and/or App Attest (App Attest worked this time)

*2,3,4*  i. check the rules, matches the collection names, etc. debug it.
