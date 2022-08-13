# QiMessaging for Smalltalk.

Proof of concept of a pure Smalltalk implementation of
[QiMessaging](https://github.com/aldebaran/libqi) based on this
[description of the protocol](https://github.com/lugu/qiloop/blob/master/doc/about-qimessaging.md).

QiMessaging is the network protocol used to communicate with
[NAO](https://us.softbankrobotics.com/nao) robots.

This is tested on a NAOv4 robot, minor changes might be required to communicate
with a NAOv5 or a Pepper robot.

## Installation

Install it on Pharo with:

```smalltalk
Metacello new
    repository: 'github://lugu/QiMessagingSmalltalk';
    baseline:'QiMessaging';
    load.
```

## How to start

Update the IP address of the robot accordingly bellow.

### How to call a service

```smalltalk
| session tts motion |
session := QiSession new join: 'tcp://192.168.0.1:9559'.

tts := session service: 'ALTextToSpeech'.
tts say: 'Hi!'.

motion := session service: 'ALMotion'.
motion moveTo: 1 with: 0 with: 0.
```

In this example, `QiSession>>jon:` connects and authenticate wiht the service
directory.

Then `QiMessaging>>service:` reaches out to a service to fetch its description.
Using this information a Smalltalk class is created on the fly (ex:
`QimProxyALTextToSpeech`) with all the methods (and signals) of the service.

The messages `say:` and `moveTo:with:with:` are remote procedure calls.

### How to listen to a signal

```smalltalk
| session cancelable |
session := QiSession new join: 'tcp://192.168.0.1:9559'.

session directory enableTrace: true.
cancelable := session directory onTraceObjectDo: [ :each | each traceCr ].
10 timesRepeat: [ session directory services ].

cancelable cancel.
```

This example uses the service directory. Notice `session directory` does the
same thing as `session service: 'ServiceDirectory'`.

To listen to the signal called "traceObject" we use the message
`onTraceObjectDo:`. The block passed as an argument will be invoked each time
an event is raised by the signal.

To produce some events, we enable tracing and make some calls to the service.
We do this because this example is about listening to the "traceObject" signal,
other signals don't requires this.

Finally, we cancel the signal registration with the `cancel` message.

### How to list all the serivces on the robot

The list of services can be printed with:

```smalltalk
session directory services collect: [ :each | each name traceCr ].
```

Remember, to see the API of a service, you have to connect to it first with
`session service:`. This will create a class with the prefix `QimProxy` that
you can inspect afterward.

## Dependency

[Petit Parser](https://scg.unibe.ch/research/helvetia/petitparser) is installed
as a dependency.
