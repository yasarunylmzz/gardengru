
# Plant Recommendation App

This Flutter application leverages the power of the Google Gemini API to provide users with personalized plant recommendations based on their location and soil image. The app is designed to help users identify the best plants to grow in their specific environment, taking into account factors like soil quality and local climate.

## Features

- **Location-Based Recommendations**: Automatically detect the user's location to provide plant suggestions that are suitable for the local climate.
- **Soil Image Analysis**: Upload a soil image to get precise plant recommendations tailored to the specific soil type.
- **Firebase Integration**: Use Firebase for user authentication, data storage, and real-time updates.
- **Google Gemini API**: Utilize the advanced capabilities of the Google Gemini API to analyze environmental factors and generate accurate plant suggestions.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/plant-recommendation-app.git
   cd plant-recommendation-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Follow the official [Firebase documentation](https://firebase.google.com/docs/flutter/setup) to set up Firebase for your project.
   - Replace the `google-services.json` file in the `android/app` directory with your own.

4. **Set up Google Gemini API**:
   - Obtain your API key from the [Google Cloud Console](https://console.cloud.google.com/).
   - Add the API key to your project by updating the relevant configuration files.

5. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

1. **Sign In**: Users must sign in using their Google account to access the app's features.
2. **Location Detection**: The app will automatically detect the user's location, but users can also manually enter their location if preferred.
3. **Soil Image Upload**: Upload an image of the soil for analysis.
4. **Get Recommendations**: The app will analyze the soil and location data to suggest the best plants for the environment.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch-name`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch-name`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For any questions or feedback, please contact us at agcaabdurrahim@outlook.com or yasarunylmzz@gmail.com
