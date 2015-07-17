<img src="https://raw.githubusercontent.com/yankodimitrov/SignalKit/master/logo.png" width="280" alt="SignalKit">

# SignalKit

SignalKit is a type safe event and binding Swift framework with great focus on clean and readable API. It allows you to observe different event streams like KVO, Target-Action, NSNotificationCenter and custom events by using a single unified API. You can declare a chain of operations that will be performed when the event occurs like <code>map</code> and <code>filter</code> or bind the resulting value to a property of a UI element.

Let’s assume that we want to bind a String value and any upcoming changes to that value to the text property of a UILabel:

```swift
// ViewModel
let name = ObservableValue<String>("John")

// View/ViewController
observe(viewModel.name)
    .bindTo( textIn(nameLabel) )
```

Now the above code will set the <code>nameLabel</code>’s text to reflect the current value (“John”) found in the observable, but if we want to observe for the upcoming changes we need to retain the resulting <code>Signal</code> and its preceding chain of operations. To do this we can use a private property or we can add the signal to a <code>SignalContainer</code>:

```swift
private let signalContainer = SignalContainer()
...

observe(viewModel.name)
    .bindTo( textIn(nameLabel) )
    .addTo(signalContainer)
```
The <code>addTo(signalContainer)</code> method will return a disposable item which you can use to remove (dispose) the chain of operations from the container.

How about observing a UIButton for the <code>.TouchUpInside</code> event:

```swift
observe(touchUpInside: button)
    .next { _ in println("Wooot!") }
    .addTo(signalContainer)
``` 

So, the <code>observe(...)</code> functions will return a <code>Signal</code> of the type of the observable and we can build a chain of signal operations starting from that initial signal. Thus a signal represents a value over time. Each signal except the initial one, holds a back reference to its source signal - the signal on which its value depends on. 

As each signal conforms to <code>Disposable</code> protocol, you can dispose the chain and the observation by calling <code>dispose()</code> method on the last signal.

## ObservableValue

<code>ObservableValue</code> is a thread safe class that you can use to create your own observable streams of values/events. It is a generic class so you can use it with any type. To dispatch a new value to the observers simply change the <code>value</code> property:

```swift
let title = ObservableValue<String>("")

title.value = "Cool!"
```

You can also notify the observers on a certain dispatch queue. This is helpful when you are doing some background work and you want to notify the observers on the main queue (you can also dispatch on a background queue):

```swift
let title = ObservableValue<String>("")

title.dispatch("Cool!", on: .Main)
```

## KVO

Let’s see how we can observe a NSObject for a given key path:

```swift
let person = Person(name: "John")

observe(keyPath: "name", value: "", object: person)
    .next { println("Name: "\($0)") }
    .addTo(signalContainer)
```

The <code>value</code> argument is used as an initial dispatch value and its type is used to perform an optional type cast on the <code>AnyObject</code> that is sent by the KVO mechanism. This way you will not have to manually cast it to the type of the observable property. Cool! 

The resulting signal is of type <code>Signal< T ></code> where <code>T</code> is the type of the <code>value</code> argument.

## Target-Action

We can observe an <code>UIControl</code> instance for control event/s using the following observe function:

```swift
observe(control, forEvents: .ValueChanged)
    .next { _ in println("value changed") }
    .addTo(signalContainer)
```

The resulting signal is of type <code>Signal< T ></code> where <code>T</code> is the type of the control that we are observing.

## NSNotificationCenter

We can also observe the default <code>NSNotificationCenter</code> for a given notification:

```swift
observe(notificationName)
    .next { println("\($0.name)")
    .addTo(signalContainer)
```

The resulting signal is of type <code>Signal< NSNotification ></code>.

## Keyboard Notifications

SignalKit comes with a convenient way to observe for keyboard notifications on iOS. The resulting signal is of type <code>KeyboardState</code> which is a struct that you can ask for the keyboard's begin/end frames, animation curve and animation duration that came from the posted by the system <code>NSNotification</code>.

```swift
observe(keyboard: .WillShow)
    .next { println("keyboard end frame: \($0.endFrame)") }
    .addTo(signalContainer)
```

Awesome!

## Signal methods and functions

#### next
Adds a new observer to a signal to perform a side effect:

```swift
observe(name)
    .next { value in println(value) }
```

#### map

Transforms a signal ot type T to a signal of type U using a transform function:

```swift
// transforms the initial signal of type String to a signal of type Int
observe(name)
    .map { count($0) }
    .next { println($0) }
```

#### filter

Filters the dispatched by the signal values using a predicate function:

```swift
// filters the String length to be equal or greather than 3
observe(name)
    .filter { count($0) >= 3 }
    .next { println($0) }
```

#### skip

Skip a certain number of dispatched by the signal values:

```swift
// skips two changes in the name property
observe(name)
    .skip(2)
    .next { println($0) }
```

#### deliverOn

Dispatch (deliver) the next signal value on a given dispatch queue:

```swift
// delivers the value on the main queue
observe(viewModel.title)
    .deliverOn(.Main)
    .next { println($0) }

// delivers the value on a background queue
observe(viewModel.title)
    .deliverOn(.Background(queue_name))
    .next { println($0) }
```

#### combineLatest

Combine the latest values of two, thee or four signals to a single signal. The resulting signal will dispatch new values only when all of the combined signals have dispatched at least one value. The type of that signals is a tuple with a values from each combined signal.

```swift
let signalA = observe(textIn: emailField).map(isValidEmail)
let signalB = observe(textIn: passwordField).map(isValidPassword)

// combines the above signals to a signal of type (Bool, Bool)
combineLatest(signalA, signalB)
    .map { $0.0 == $0.1 == true }
    .bindTo( isEnabled(loginButton) )
    .addTo(signalContainer)
```

**Note**: The combined signal will contain a reference to each of the combined signals, so we can store only that chain of signals to a signal container or property. 

#### bindTo

Bind the signal value using a binding function or bind the value to a <code>Observable</code> of the same type:

```swift
// bind using a binding function
// Here we are using a curried function to bind a String value to the UILabel's text property
observe(viewModel.name)
    .bindTo( textIn(nameLabel) )

// bind the value to a Observable of the same type
// changes in the name will call dispatch(newValue) on the binded Observable 
let destination = ObservableValue<String>("")

observe(name)
    .bindTo(destination)
```

#### addTo

We have already seen the use of this method: Add a signal or a chain of signals to a signal container that conforms to the <code>SignalContainerType</code> protocol. As stated before this will end the chain of signals and will return a disposable item on which you can call <code>dispose()</code> to remove the chain from the signal container.

## UIKit

Here is the list of currently implemented observe and bind functions for UIKit:

#### observe 

| Class | observe   | Signal Type | 
|------|-----------|----------|
| UIControl | observe< T: UIControl >(control: T, forEvents: UIControlEvents) | Type of the UIControl |
| UIButton | observe(touchUpInside: UIButton) | UIButton |
| UIDatePicker | observe(dateIn: UIDatePicker) | NSDate |
| UISlider | observe(valueIn: UISlider) | Float |
| UISwitch | observe(switchIsOn: UISwitch) | Bool |
| UITextField | observe(textIn: UITextField) | String |
| UITextView | observe(textIn: UITextView) <br/> observe(attributedTextIn: UITextView) | String<br/>NSAttributedString |
| UISegmentedControl | observe(selectedIndexIn: UISegmentedControl) | Int |

#### bind

| Class | bind  | to |
|-------|-------|----|
| UIControl | Bool | isEnabled(control: UIControl) |
| UIView | UIColor <br/> CGFloat <br/> Bool | backgroundColorIn(view: UIView) <br/> alphaIn(view: UIView) <br/> viewIsHidden(view: UIView) |
| UIImageView | UIImage? | imageIn(imageView: UIImageView) |
| UILabel | String <br/> NSAttributedString | textIn(label: UILabel) <br/> attributedTextIn(label: UILabel) |
| UISlider | Float | valueIn(slider: UISlider) |
| UISwitch | Bool | switchIsOn(switchControl: UISwitch) |
| UITextField | String <br/> NSAttributedString | textIn(field: UITextField) <br/> attributedTextIn(field: UITextField) |
| UITextView | String <br/> NSAttributedString | textIn(textView: UITextView) <br/> attributedTextIn(textView: UITextView) |

##License
SignalKit is released under the MIT license. See the LICENSE.txt file for more info.