# QiMessaging for Smalltalk.

Proof of concept of a pure Smalltalk implementation of
[QiMessaging](https://github.com/aldebaran/libqi) based on this
[description of the protocol](https://github.com/lugu/qiloop/blob/master/doc/about-qimessaging.md).

QiMessaging is the network protocol used to communicate with
[NAO](https://us.softbankrobotics.com/nao) robots.

This is tested on a NAOv4 robot, minor changes might be required to communicate
with a NAOv5 or a Pepper robot.

## Installation

Install on Pharo with:

```smalltalk
Metacello new
    repository: 'github://lugu/QiMessagingSmalltalk';
    baseline:'QiMessaging';
    load.
```

## How to start

Update the IP address of the robot accordingly in:

```smalltalk
| session logger |
session := QiSession new join: 'tcp://192.168.0.1:9559'.
logger := session service: 'LogManager'.
```

## Dependency

[Petit Parser](https://scg.unibe.ch/research/helvetia/petitparser) is installed
as a dependency.
