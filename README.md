<img src="https://raw.githubusercontent.com/yankodimitrov/SignalKit/SignalKit-3.0/Resources/logo.png" width="280" alt="SignalKit">

---
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Abstract
SignalKit is a lightweight event and binding framework. The core of SignalKit is the Observable protocol. Each implementation of the Observable protocol defines the type of the observation thus an Observable can dispatch only one type of event. For example an Observable of type String can only dispatch String values.

Another key protocol is SignalType which implements Observable and Disposable. Each SignalType implementation has a property <code>disposableSource: Disposable?</code> which points to a Disposable that comes before the current signal.

Because SignalType implements Disposable we can use the <code>disposableSource</code> property to chain signal operations like map, filter and combineLatest together. Each operation returns either a new SignalType or a Disposable. When we call <code>dispose()</code> on a SignalType it will dispose the whole chain of operations.

To store the chain of operations we can use a stored property or the <code>disposeWith(container: DisposableBag) -> Disposable</code> method on the Disposable protocol. When DisposableBag is deinitialized it will dispose all of its items for us.

```swift
let disposableBag = DisposableBag()
let userName = Signal<String>()

userName.next { print("name: \($0)") }
	.disposeWith(disposableBag)

userName.dispatch("John") // prints "name: John"
```

![SignalKit Primary Protocols](https://raw.githubusercontent.com/yankodimitrov/SignalKit/SignalKit-3.0/Resources/primary-protocols.png)

## Events And Bindings

SignalKit comes with an elegant way to observe for different event sources like **KVO**, **Target Action** and **NSNotificationCenter** via an unified API by simply calling <code>observe()</code> method. The observe method is a protocol extension on the <code>NSObjectProtocol</code> which returns a SignalEvent with sender Self. Then we use Protocol Oriented Programming to add extensions to a SignalEventType protocol where Sender is from a given type.

![SignalKit Primary Protocols](https://raw.githubusercontent.com/yankodimitrov/SignalKit/SignalKit-3.0/Resources/event-model.png)

### Key Value Observing

Let's say we want to observe an instance of <code>class Person: NSObject</code> for it's <code>name</code> property changes with KVO. This is super easy with SignalKit, just call <code>observe()</code> on the instance and it will return the available events for this type. Then choose <code>keyPath(path: String, value: T)</code> where for the value parameter pass the initial value of the property. SignalKit will use this initial value type to perform an optional type cast on the values sent by KVO.

```swift
let person = Person(name: "John")

person.observe()
    .keyPath("name", value: person.name)
    .next { print("Hello \($0)") }
    .disposeWith(disposableBag)
```

### Target Action

SignalKit comes with SignalEventType extensions for controls which inherits from <code>UIControl</code> and <code>UIBarButtonItem</code>:

```swift
let control = UIControl()
let barButton = UIBarButtonItem()

control.observe().events([.TouchUpInside])
    .next { _ in print("Tap!") }
    .disposeWith(disposableBag)
        
barButton.observe().tapEvent
    .next { _ in print("Tap!") }
    .disposeWith(disposableBag)
```

### NSNotificationCenter

SignalEventType also have a handy extensions for observing an instance of <code>NSNotificationCenter</code> for notifications:

```swift
let center = NSNotificationCenter.defaultCenter()

center.observe().notification(UIApplicationWillResignActiveNotification)
    .next{ _ in print("Resign Active") }
    .disposeWith(disposableBag)
```

### Bindings

Bindings in SignalKit are implemented again with protocol extensions. We extend the SignalType where the ObservationType (from the generic Observable protocol) is from a certain type and add method to bind the value to a UI control like <code>UILabel</code>.
Here is an example of binding the String value from the signal to the text property of UILabel:

```swift
let userName = Signal<String>()
let nameLabel = UILabel()

userName.bindTo(textIn: nameLabel)
    .disposeWith(disposableBag)
```

## Observables

#### Signal
<code>Signal</code> is the simplest Observable which you can use to dispatch events.

#### ObservableProperty
<code>ObservableProperty</code> is an Observable which has a notion of a current value. If you change the value it will be dispatched to the observers.

#### ObservableCollectionType
<code>ObservableCollectionType</code> is a protocol that defines a property of type: <code>var changeSetSignal: Signal&lt;CollectionChangeSet&gt; { get }</code>.

You can implement the protocol in your data source or other object that you use to return sections and items data to your collection/table view data source.

When you make changes to your collection of section and items you can create a new <code>CollectionChangeSet</code> and use it to track the changes. Then you call the <code>changeSetSignal</code> to dispatch the changes:

```swift
var items = ["a", "b", "c"]
var changeSet = CollectionChangeSet()

items.insert("x", atIndex: 0)
items.insert("y", atIndex: 0)

changeSet.insertItemsInRange(0..<2, inSection: 0)
changeSetSignal.dispatch(changeSet, onQueue: .MainQueue)
```

<code>ObservableCollectionType</code> has extensions which let you observe it and bind it to a <code>UITableView</code> or <code>UICollectionView</code>.

## Operations

SignalKit comes with the following SignalType operations:
![SignalKit Primary Protocols](https://raw.githubusercontent.com/yankodimitrov/SignalKit/SignalKit-3.0/Resources/signal-operations.png)

## Extensions

Currently SignalKit comes with extensions for the the following <code>UIKit</code> components:
![SignalKit Primary Protocols](https://raw.githubusercontent.com/yankodimitrov/SignalKit/SignalKit-3.0/Resources/uikit-extensions.png)

### Keyboard
You can use the <code>Keyboard</code> structure to observe for keyboard events posted by the system. Then you will get back a structure of type <code>KeyboardState</code> which you can query for the keyboard end/start frame and other data that the system sends with the notification:

```swift
Keyboard.observe().willShow
    .next { print($0.endFrame) }
    .disposeWith(disposableBag)
```

## Installation

SignalKit requires Swift 2.0 and XCode 7

#### Carthage
Add the following line to your [Cartfile](https://github.com/carthage/carthage)
```swift
github "yankodimitrov/SignalKit" "master"
```

#### CocoaPods
Add the following line to your [Podfile](https://guides.cocoapods.org/)
```swift
pod “SignalKit”
```

##License
SignalKit is released under the MIT license. See the LICENSE.txt file for more info.
