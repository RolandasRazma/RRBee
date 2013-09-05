RRBee
=====

Pet project for BeeWi car controlling @YPlan

BeeWi Mini Cooper [@YPlan](http://yplanapp.com)
=====

It's not interesting when it's only work and no pleasure, so we got a [BeeWi Mini Cooper](http://www.bee-wi.com/bluetooth-controlled-car,us,4,BBZ251-A6.cfm) [@YPlan](http://yplanapp.com) to shorten those "hard" days :)<br />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/car_with_box.jpg" width="300" alt="bluetooth receiver info" /><br />
It's a nice toy, and best of all - it is bluetooth controlled over iPhone! All you need is free [iOS application](https://itunes.apple.com/gb/app/beewi-control-pad/id427936738?mt=8). After few drag races with our designer [João Pires](https://twitter.com/joaorafaelpires) we started to chat how it would be cool to mod it. You know... like add blinking lights, WiFi camera and etc, and best of all - I can write iOS application to do all that!

Modding BeeWi Mini Cooper [@YPlan](http://yplanapp.com)
=====
First of all I had to figure out how to send signals to [BeeWi Mini Cooper](http://www.bee-wi.com/bluetooth-controlled-car,us,4,BBZ251-A6.cfm) over bluetooth. Apparently it's quite simple. You just need to add `UISupportedExternalAccessoryProtocols` to `Info.plist` and connect to it using [ExternalAccessory.framework](https://developer.apple.com/library/ios/documentation/ExternalAccessory/Reference/ExternalAccessoryFrameworkReference/_index.html) I got `UISupportedExternalAccessoryProtocols` from [official App](https://itunes.apple.com/gb/app/beewi-control-pad/id427936738?mt=8) by extracting IPA and poking in their own `Info.plist`. I was about to start sniff bluetooth data by emulating car, to check what data comes in to control it, but surprisingly found another project on GitHub that already did that [@hdi-95 hdi-remotepad](https://github.com/hdi-95/hdi-remotepad). That was pretty simple. Apparently you need only 8 command 0-7. You can clone <a href="https://github.com/RolandasRazma/RRBee/tree/master/iOS%20App%20(Default)">my basic iOS app</a> to control BeeWi!





<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/bluetooth_receiver_info.png" width="300" alt="bluetooth receiver info" />
