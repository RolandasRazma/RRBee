`-= THIS IS LIVING DOCUMENT =-`

RRBee
=====

Pet project for [BeeWi Mini Cooper](http://www.bee-wi.com/bluetooth-controlled-car,us,4,BBZ251-A6.cfm) controlling [@YPlan](http://yplanapp.com)<br />

BeeWi Mini Cooper [@YPlan](http://yplanapp.com)
------

It's not interesting when it's only work and no pleasure, so we got a [BeeWi Mini Cooper](http://www.bee-wi.com/bluetooth-controlled-car,us,4,BBZ251-A6.cfm) [@YPlan](http://yplanapp.com) to shorten those "hard" days :)<br />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/car_with_box.jpg" width="280" alt="BeeWi Mini Cooper" /><br />
It's a nice toy, and best of all - it is Bluetooth controlled over iPhone! All you need is free [iOS application](https://itunes.apple.com/gb/app/beewi-control-pad/id427936738?mt=8). After few drag races with our designer [João Pires](https://twitter.com/joaorafaelpires) we started to chat how it would be cool to mod it. You know... like add blinking lights, WiFi camera and etc, and best of all - I can write iOS application to do all that!<br />

Modding BeeWi Mini Cooper [@YPlan](http://yplanapp.com)
------

First of all I had to figure out how to send signals to [BeeWi Mini Cooper](http://www.bee-wi.com/bluetooth-controlled-car,us,4,BBZ251-A6.cfm) over bluetooth. Apparently it's quite simple. You just need to add `UISupportedExternalAccessoryProtocols` to `Info.plist` and connect to it using [ExternalAccessory.framework](https://developer.apple.com/library/ios/documentation/ExternalAccessory/Reference/ExternalAccessoryFrameworkReference/_index.html) I got `UISupportedExternalAccessoryProtocols` from [official App](https://itunes.apple.com/gb/app/beewi-control-pad/id427936738?mt=8) by extracting IPA and poking in their own `Info.plist`. I was about to start sniff Bluetooth data by emulating car, to check what data comes in to control it, but surprisingly found another project on GitHub that already did that [@hdi-95 hdi-remotepad](https://github.com/hdi-95/hdi-remotepad). That was pretty simple. Apparently you need only 8 command `0`-`7`. <br />
  * `0` - Stop go forward
  * `1` - Go forward
  * `2` - Stop go backwards
  * `3` - Go backwards
  * `4` - Stop turn Left
  * `5` - Turn Left
  * `6` - Stop Turn Right
  * `7` - Turn Right

You can clone <a href="https://github.com/RolandasRazma/RRBee/tree/master/iOS%20App%20(Default)">my basic iOS app</a> to control BeeWi!<br />

BeeWi Mini Cooper - Hardware
------
Ok. So I need more of those signals to turn on and off lights. Disassembling is quite easy. There is only 4 screws at the bottom. <br />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/screws.jpg" height="280" alt="4 screws" /><br />

Lets inspect whats under the hood. What you see standard Bluetooth receiver, and very simple [PCB](http://en.wikipedia.org/wiki/Printed_circuit_board) under it.<br />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/chassi.jpg" width="280" alt="chassi" />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/chassi_no_receiver.jpg" width="280" alt="chassis without Bluetooth receiver" />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/pcb_other_side.jpg" width="280" alt="PCB back side" />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/bluetooth_receiver.jpg" width="280" alt="Bluetooth receiver" />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/bluetooth_breakout_board_back_side.jpg" width="280" alt="Bluetooth breakout board" /> <br />

Ok, so we have Bluetooth serial communication module (most likely cheap one) and [breakout board](http://en.wikipedia.org/wiki/Breakout_board) with [micro controller](http://en.wikipedia.org/wiki/Micro_controller). I fast checked all 8 pins on breakout board using [multimeter](http://en.wikipedia.org/wiki/Multimeter) and unfortunately only 4 of those are for serial signal, other 4 are for [ISP](http://en.wikipedia.org/wiki/In-system_programming) 2 for ground, 1 for Vcc, and 1 unused for [LED](http://en.wikipedia.org/wiki/Led).<br />

4 pins only... `Go forward`, `Go backwards`, `Turn Left`, `Turn Right`… Clearly no place for all cool features I would like to add... even worser - after some experiments I figured out that __only 2__ of them can be active at the same time (for example `1` go forward + `7` turn right) so there is no way I could do some logic with [gates](http://en.wikipedia.org/wiki/Logic_gate)...<br />

<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Car/bluetooth_breakout_board_pins.jpg" width="280" alt="Bluetooth breakout board pins" /><br />

BeeWi Mini Cooper - Modding Hardware
------
So my choices pretty narrow here:
  * figure out what micro controller is used on breakout board and try to reprogram it.
  * cut micro controller from breakout board and add new one with enough pins I could program.
  * use [Shift register](http://en.wikipedia.org/wiki/Shift_register) to increase number of available outputs.<br />
  
*__What is Shift Registers?__*<br />
[Shift register](http://en.wikipedia.org/wiki/Shift_register) in principle it is "device" that counts how many impulses you gave to it. Every time you give impulse it shifts bit by one position. If you had `00000000` (look at legs of it) after you "give it" `1` it will have value of `00000001`, if you then "give it" `0` and `1` again, it will have value of `00000101`. It is very simple to operate, you can connect then in <a href="http://en.wikipedia.org/wiki/Daisy_chain_(electrical_engineering)">daisy chain</a> to get virtually unlimited number of outputs and best of all you need only 3-4 wires to do so.<br />
Depending on Shift register model it might have different pins, but for [74HC595 Shift Register](http://www.nxp.com/documents/data_sheet/74HC_HCT595.pdf) they are as follow:
 * `1` - output (QB)
 * `2` - output (QC)
 * `3` - output (QD)
 * `4` - output (QE)
 * `5` - output (QF)
 * `6` - output (QG)
 * `7` - output (QH)
 * `8` - <a href="http://en.wikipedia.org/wiki/Ground_(electricity)">GND</a> - ground pin you connecting to `-` of your [power supply](http://en.wikipedia.org/wiki/Power_supply)
 * `9` - output used for connecting several shift register together (QH')
 * `10` - serial clear - Will clear all values if no current is given. Most of the time you want it to be connected to power supply `+`
 * `11` - serial clock - When this pin is pulled high (has current), it will shift the register to whatever value is given on pin `14`
 * `12` - register clock - After you set value you want (by operating pin `11` and pin `14`) this pin needs to be pulled high (have current) to set the output to the new values. It must be pulled high after serial clock (pin `11`) has gone LOW.
 * `13` - output enabled - enables output when tied to ground (power supply `-`). If you want to temporary disable output without affecting shift register value you can pull it HIGH
 * `14` - serial input - value for the next bit that gets shifted in (when pin `11` is HIGH)
 * `15` - output (QA)
 * `16` - <a href="http://en.wikipedia.org/wiki/IC_power_supply_pin">VCC</a> - `+` of your power supply

<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/74HC595/74HC595_lots.jpg" height="280" alt=""/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/74HC595/74HC595.jpg" height="280" alt=""/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/74HC595/74HC595_pinout.jpg" height="280" alt=""/><br />

*__Wireing__*<br />
I thought that [Shift registers](http://en.wikipedia.org/wiki/Shift_register) is simplest solution as you can get virtually unlimited outputs, it would move all logic to software (iOS app) and most important in my case is that I can control it with 3 wires (remember that BeeWi Bluetooth breakout board has only 4 and allows only 2 be active at same time)

I had couple of [74HC595 Shift Registers](http://www.nxp.com/documents/data_sheet/74HC_HCT595.pdf) lying around as they are pretty common so I decide to hook it up.

Before I start soldering everything to BeeWi PCB I have to test if it would work. I started putting everything on [Breadboard](http://en.wikipedia.org/wiki/Breadboard). First, Bluetooth breakout board from BeeWi and Shift register, then added simple [power supply](http://en.wikipedia.org/wiki/Power_supply) I had and some [LED](http://en.wikipedia.org/wiki/Light-emitting_diode)'s. Then wrote some simple <a href="https://github.com/RolandasRazma/RRBee/tree/master/iOS%20App%20(Mod)">iOS app</a> to set bits as I wanted. Good, now I have 8 independant outputs!

<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard.jpg" height="280" alt="Breadboard"/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard_bt_74HC595.jpg" height="280" alt="Breadboard, BeeWi Bluetooth, Shift register"/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard_bt_74HC595_power_jumpers.jpg" height="280" alt="Breadboard, BeeWi Bluetooth, Shift register, Jumpers"/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard_bt_74HC595_power_jumpers_leds.jpg" height="280" alt="Breadboard, BeeWi Bluetooth, Shift register, Jumpers, LED's"/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard_bt_74HC595_power_jumpers_leds_done.jpg" height="280" alt="Breadboard, BeeWi Bluetooth, Shift register, Jumpers, LED's - assembled"/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Breakout/breadboard_bt_74HC595_power_jumpers_leds_done_on.jpg" height="280" alt="Breadboard, BeeWi Bluetooth, Shift register, Jumpers, LED's - assembled, on"/><br />

*__Putting back together__*<br />
It's time to put all back together. There is no place for shift register on bottom of original PCB so I decided to put it on the top. First of all I needed to cut old connections going to Bluetooth breakout board as they will be replaced with new on driven by shift register. It's not that card if you have [crafts knife](http://www.google.com/search?q=crafts+knife&tbm=isch). <br />
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Rewire/original.jpg" width="280" alt=""/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Rewire/cut.jpg" width="280" alt=""/>
<img src="https://raw.github.com/RolandasRazma/RRBee/master/Hardware/Rewire/solder.jpg" width="280" alt=""/>

`to be continued...`
