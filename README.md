# The Pumpkin King 🎃👑

A fun and interactive project that combines the power of SwiftUI (MacOS), Adobe Character Animator, and Arduino (ESP32 BLE) to switch between "Active" and "Idle" states based on human detection.

![Pumpkin King Logo](./pumkin_king.png) 

## Table of Contents

- [Description](#description)
- [Technologies](#technologies)
- [Setup](#setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Description

The Pumpkin King is a unique combination of software and hardware that detects human presence and switches modes in a SwiftUI application. When a person is detected, it transitions from an "Idle" state to an "Active" state, answering questions with the power of [OpenAI](https://openai.com/) and [Eleven Labs](https://elevenlabs.io/).

[Video Example](https://www.tiktok.com/@modern.magician/video/7295958411190095146?is_from_webapp=1&sender_device=pc&web_id=7284093191287670315) 

[Video of the beam/break detector](https://www.tiktok.com/@modern.magician/video/7294650655363435819?is_from_webapp=1&sender_device=pc&web_id=7284093191287670315)

## Technologies

- **SwiftUI**: For creating a visually appealing and responsive iOS application.
- **Arduino**: Used for the hardware component to detect human presence.
- **BLE (Bluetooth Low Energy)**: For seamless communication between the hardware and software components.
- **Adobe Character Animator**: Creates a face that you can project onto a [blow-up pumpkin](https://www.lowes.com/pd/WELLFOR-4-Feet-Halloween-Inflatable-Pumpkin-with-Build-in-LED-Light/5013900537).
- **OpenAI Whisper**: Used to take the audio recording of the user's question and turn it into text.
- **OpenAI Completions**: Used to generate a response to the user's question in the style of the pumpkin king.
- **Eleven Labs**: Used to generate an audio response in a custom voice that is sure to spook the kids.

## Setup

### Software (Xcode Project)

1. Clone the repository: `git clone [repository_link]`.
2. Open `PumpkinKing.xcodeproj` in Xcode.
3. Build and run the project on a Mac or an iOS device.
4. Goto the preferences in the main menu and enter in your API keys

### Hardware (Arduino)

1. Setup your Arduino board This project assumes [HiLetgo 0.96" ESP32 OLED (Amazon Non-Affiliate Link)](https://www.amazon.com/gp/product/B072HBW53G).
2. Connect the required sensors and components [Tutorial for Photoresistor](https://www.instructables.com/How-to-use-a-photoresistor-or-photocell-Arduino-Tu/).
3. Open the Arduino IDE and load the provided `.ino` file. (Configure the boards and libraries needed) 
4. Upload the code to your Arduino board.

### 3DModels 
I've uploaded the 3D models to Thangs these models make it easier to setup the beam break sensor outside. 
1. The sensor board and laser board: [thangs](https://than.gs/m/955710)
2. The ground stakes and caps: [thangs](https://than.gs/m/955712)

## Usage

1. Start the SwiftUI application.
2. Power on the Arduino setup.
3. Approach the Arduino sensor.
4. Watch as the SwiftUI application transitions from "Idle" to "Active" mode, playing a synthesized response.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. Please make sure to update tests as appropriate.

## License

<html>
<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><span property="dct:title">Pumpkin King Human Detector</span> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://magician.dev">David Bates</a> is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">Attribution 4.0 International<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>
</html>
