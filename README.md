<img src="https://raw.githubusercontent.com/yankodimitrov/SignalKit/master/logo.png" width="280" alt="SignalKit">

# SignalKit
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

SignalKit is a lightweight event and binding framework.
It provides you with a single unified API that lets you observe for KVO, Target-Action, NSNotificationCenter and custom event streams. You can then build a chain of operations on the incoming values using methods like <code>next</code>, <code>map</code>, <code>filter</code>, <code>debounce</code> or you can bind the value to a property of UI control.

Let’s observe and bind a signal of type String to the text property of UILabel:

```swift
let nameLabel = UILabel()
let name = ObservableProperty<String>("John")

name.observe().bindTo(textIn: nameLabel)
```

All the observations are made by calling a **single method** <code>observe()</code> on the type that you wish to observe for changes. This method returns a type conforming to the <code>SignalEventType</code> protocol and by using **Protocol Oriented Programming** SignalKit extends the <code>SignalEventType</code> protocol to provide you with the available events for that type.

Now let’s observe an <code>UIButton</code> for <code>.TouchUpInside</code> control events, its easy as that:

```swift
let button = UIButton()
        
button.observe().tapEvent.next { _ in print("Tap!") }
```

Now in order to preserve the chain of operations we need to store it in a property or we can use an instance of the <code>SignalBag</code> class:

```swift
let signalsBag = SignalBag()
...
name.observe()
    .bindTo(textIn: nameLabel)
    .addTo(signalsBag)

button.observe().tapEvent
    .next { _ in print("Tap!") }
    .addTo(signalsBag)
``` 

The <code>addTo(...)</code> method will store the chain of signal operations to our <code>signalsBag</code> and will return a disposable that we can use to remove the chain from the bag. The <code>signalsBag</code> will handle for us the disposal of all observations and chain of operations on deinit.


### KVO

How about observing a <code>NSObject</code> using **KVO**:

```swift
// Person is a class that inherits from NSObject
let person = Person(name: "Jack")
    
person.observe()
    .keyPath("name", value: person.name)
    .next { print("Hello \($0)") }
    .addTo(signalsBag)
```

As you know the **KVO** mechanism will return the value of the changed property as <code>AnyObject</code>, but we want the type of the property that we are interested in, so we are using the <code>value</code> parameter as the initial value and to specify the type of the property that we are interested in. SignalKit will perform an optional type cast for us and will dispatch the new value only if the type cast is successful, nice!


### Target-Action

SignalKit comes with several special observation options for certain UIKit controls. Here is how we can observe a <code>UIControl</code> for <code>UIControlEvents</code>:

```swift
let slider = UISlider()

slider.observe()
    .events(.ValueChanged)
    .next{ print("New value: \($0.value)") }
    .addTo(signalsBag)
```

Off course you can observe for multiple <code>UIControlEvents</code> using the new in Swift 2.0 option set syntax:  <code>[.ValueChanged, .TouchUpInside]</code>

As mentioned above SignalKit comes with special observation options for several UIKit controls, so we can observe the value changes in <code>UISlider</code> like this:

```swift
slider.observe().valueChanges
    .next { print("New value: \($0)") }
    .addTo(signalsBag)
```

Notice that here we are getting back a signal of type Float with the current value of the slider.

Instead of printing the slider’s new value let's bind it to the text property of a <code>UILabel</code>:

```swift
slider.observe().valueChanges
    .map { "Value : \($0)" }
    .bindTo(textIn: label)
    .addTo(signalsBag)
```


### NSNotificationCenter

At this point you may already guess how we are going to observe for notifications posted on the <code>NSNotificationCenter</code>:

```swift
let center = NSNotificationCenter.defaultCenter()
        
center.observe()
    .notification(UIKeyboardWillShowNotification)
    .next { print($0.name) }
    .addTo(signalsBag)
```

We can also observe for notifications posted by a certain object.

### Keyboard Events

Wouldn’t it be great if there was a easy way to observe for keyboard notifications and to get the keyboard data that is posted by the system with the notification?

Well SignalKit comes with a handy <code>Keyboard</code> strucute that you can call the static method <code>observe()</code> to observe for the keyboard events. When keyboard notification is posted by the system you will get back a signal of type <code>KeyboardState</code> which you can query for the keyboard begin/end frames and animation curve and duration.

```swift
Keyboard.observe().willShow
    .next { print($0.endFrame) }
    .addTo(signalsBag)
```


### Custom events

#### ObservablePropety
Observable property is a thread safe <code>Observable</code> implementation that have a notion of a current value. You can get the current <code>value</code> and if you set a value it will be dispatched to all observers. Alternatively you can call <code>dispatch(newValue)</code> to notify the observers:

```swift
// ViewModel
let name = ObservableProperty<String>("Jane")

// View/ViewController
name.observe()
    .next { print("Name: \($0)") }
    .addTo(signalsBag)

// prints "Name: Jane"

name.value = "John" // prints "Name: John"
```


### Signal Operations

SignalKit comes with the following <code>SignalType</code> protocol extension operations: 

#### next
Adds a new observer to a signal to perform a side effect:
```swift
name.observe().next { print($0) }
```

#### map
Transforms the signal to a signal of another type:
```swift
name.observe().map { $0.characters.count }.next { print($0) }
```

#### filter
Filters the signal value using a predicate:
```swift
name.observe().filter { $0.characters.count > 3 }.next { print($0) }
```

#### skip
Skip a certain number of signal values:
```swift
name.observe().skip(3).next { print($0) }
```

#### deliverOn
Deliver the signal on a given <code>SignalScheduler.Queue</code> (dispatch queue):
```swift
// .MainQueue
// .UserInteractiveQueue
// .UserInitiatedQueue
// .UtilityQueue
// .BackgroundQueue
// .CustomQueue(dispatch_queue_t)

name.observe().deliverOn(.MainQueue).next { print($0) }
```

#### debounce
Sends only the latest values that are not followed by another values within the specified duration (seconds). You can also specify the <code>SignalScheduler.Queue</code> on which to debounce which is by default the <code>.MainQueue</code>:
```swift
name.observe().debounce(0.5).next { print($0) }
```

#### delay
Delays the dispatch of the signal. Here you can also specify on which <code>SignalScheduler.Queue</code> to delay the dispatch which is by default again the <code>.MainQueue</code>:
```swift
name.observe().delay(0.2).next { print($0) }
```

#### distinct
Dispatches the new value only if it is not equal to the previous one (only for signals which type conforms to <code>Equatable</code> protocol):
```swift
name.observe().distinct().next { print($0) }
```

#### bindTo
Bind the value of the signal to an <code>Observable</code> of the same type:
```swift
let anotherName = ObservableProperty<String>("")

name.observe().bindTo(anotherName)
```
*Note: There are special bindTo(...) extensions for the UIKit UI components like UIView, UIControl and more.* 

#### addTo
Stores a chain of signal operations in a container that conforms to the <code>SignalContainerType</code> protocol:
```swift
let signalsBag = SignalBag()

name.observe().next { print($0) }.addTo(signalsBag)
```

#### combineLatestWith
Combine the latest values of the current signal A and another signal B in a signal of type <code>(A, B)</code>:

Let’s assume that we have <code>emailField</code>, <code>passwordField</code> and <code>loginButton</code> controls and we want the <code>loginButton</code> to be enabled only when both <code>emailField</code> and <code>passwordField</code> have valid content.

We can create two signals that observe for text changes in the fields and then map their text to a Boolean value using the functions <code>isValidName</code> and <code>isValidPassword</code>. Then we can combine the two signals to a signal of tuple type <code>(Bool, Bool)</code>, map to Boolean true if both are equal to true and finally bind the resulting Boolean to the enabled property of <code>UIButton</code>:

```swift
let emailField = UITextField()
let passwordField = UITextField()
let loginButton = UIButton()

let signalA = emailField.observe().text.map(isValidName)
let signalB = passwordField.observe().text.map(isValidPassword)

signalA.combineLatestWith(signalB)
    .map { ($0.0 == $0.1) == true }
    .bindTo(enabled: loginButton)
    .addTo(signalsBag)
```
#### combineLatest
A free function variant of the <code>combineLatestWith</code> which combines two or three signals:
```swift
combineLatest(signalA, signalB)
    .map { ($0.0 == $0.1) == true }
    .bindTo(enabled: loginButton)
    .addTo(signalsBag)
```

#### all
Special operation on a signal of type <code>(Bool, Bool)</code> or <code>(Bool, Bool, Bool)</code>. Sends true if all values in a signal of tuple type are matching the predicate function. We can replace the above <code>combineLatestWith</code> map operation with:
```swift
combineLatest(signalA, signalB)
    .all { $0 == true }
    .bindTo(enabled: loginButton)
    .addTo(signalsBag)
```

#### some
Similar to <code>all</code>, but send true if at least one value in a signal of tuple type <code>(Bool, Bool)</code> or <code>(Bool, Bool, Bool)</code> matches the predicate function:
```swift
combineLatest(signalA, signalB, signalC)
    .some { $0 == true }
    .bindTo(enabled: loginButton)
    .addTo(signalsBag)
```


## UIKit

SignalKit comes with UIKit extensions that let you observe for different control events and to bind a signal to a property of UI component.

Take a look at <code>SignalKit/Extensions/UIKit/</code> folder to explore the currently implemented observations and bindings for UIKit.

## AppKit & WatchKit

I will really love to include extensions for AppKit and WatchKit. Any help with that is welcome.

## Installation

SignalKit requires Swift 2.0 and XCode 7 beta 5

#### Carthage
Add the following line to your [Cartfile](https://github.com/carthage/carthage)
```swift
github "yankodimitrov/SignalKit"
```

#### CocoaPods
Add the following line to your [Podfile](https://guides.cocoapods.org/)
```swift
pod “SignalKit”
```

## Roadmap

- Support for more UIKit observations/bindings
- AppKit support
- WatchKit support

##License
SignalKit is released under the MIT license. See the LICENSE.txt file for more info.
