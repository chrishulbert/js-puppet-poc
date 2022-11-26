# js-puppet-poc

Proof of Concept of using Javascript to control a native 'Puppet' app.

The idea is that a common JS codebase could be the 'puppeteer' controlling iOS and Android native shells, in order to create a cross-platform app. Currently only the iOS shell exists.

This uses JavaScriptCore to run a Javascript 'view controller', which communicates with the native app via a 'bridge' closure.

Using this bridge, it is able to present alerts, signal exceptions, and create views. Since this is a Proof-of-Concept there is not a large amount of functionality.

The native ViewController maintains a reference to the JS 'view controller' class instance, and is able to store state. This demo uses two buttons to mutate the state and display an alert showing the current state.

Thanks for reading!
