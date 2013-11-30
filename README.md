Phoney
======

Phoney is a sensor simulator library for iOS. It simulates the rotation data provided by CMMotionManager. It can be if you are running a simulator and need to simulate rotation of the device, or if you need to precise rotation test cases that can be persisted.

Installation
-------------
1. Clone the repository somewhere on your hard drive
2. Open your project in XCode 
3. Drag and drop Phoney folder into your project
4. Build it as a static library

Usage
--------------

If there deviceMotion isn't available on the device, you simply instantiate the DummyMotionManager instead. 

```
self.motionManager= [[CMMotionManager alloc] init];
BOOL deviceMotionAvailable= [self.motionManager isDeviceMotionAvailable];

if(!deviceMotionAvailable){
    self.motionManager= [[DummyMotionManager alloc] init];
}

self.motionManager.deviceMotionUpdateInterval= myUpdateInterval;
[self.motionManager startDeviceMotionUpdates];
```

From there, you can read the rotation data.

```
CMRotationMatrix rotationMatrix= self.motionManager.deviceMotion.attitude.rotationMatrix;
CMQuaternion quaternion= self.motionManager.deviceMotion.attitude.quaternion;
```

Simulating rotation
--------------

But how do you actually simulate the rotation? [PhoneyUI](https://github.com/nmarkovic04/PhoneyUI). It will simulate rotation and send the data to localhost using UDP on a configured port. <b>Make sure that port in your .plist file matches the port in the PhoneyUI</b>. You can configure the port by adding a value for "PhoneyPort" key inside your .plist file. The default port is 28000.
