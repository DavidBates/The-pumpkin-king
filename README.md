# Pumpkin King Human Detector

A fun and interactive project that combines the power of Swift, SwiftUI, and Arduino to switch between "Active" and "Idle" states based on human detection.

![Pumpkin King Logo](./pumkin_king.png) 

## Table of Contents

- [Description](#description)
- [Technologies](#technologies)
- [Setup](#setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Description

The Pumpkin King Human Detector is a unique combination of software and hardware that detects human presence and switches modes in a SwiftUI application. When a person is detected, it transitions from an "Idle" state to an "Active" state, playing a synthesized voice in the process.

## Technologies

- **SwiftUI**: For creating the visually appealing and responsive iOS application.
- **Arduino**: Used for the hardware component to detect human presence.
- **BLE (Bluetooth Low Energy)**: For seamless communication between the hardware and software components.

## Setup

### Software (Xcode Project)

1. Clone the repository: `git clone [repository_link]`.
2. Open `PumpkinKing.xcodeproj` in Xcode.
3. Build and run the project on a Mac or an iOS device.

### Hardware (Arduino)

1. Setup your Arduino board.
2. Connect the required sensors and components.
3. Open the Arduino IDE and load the provided `.ino` file.
4. Upload the code to your Arduino board.

## Usage

1. Start the SwiftUI application.
2. Power on the Arduino setup.
3. Approach the Arduino sensor.
4. Watch as the SwiftUI application transitions from "Idle" to "Active" mode, playing a synthesized response.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
