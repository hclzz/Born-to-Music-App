# App for Born to Music Project

**Description of the Born to Music App Programming**  

The application was developed in Flutter and integrates technology into musical learning through an intuitive and interactive interface. Its main function is to manage and send chord sequences to an ESP32 via Wi-Fi connection, facilitating musical practice.  

### **Main Features:**  
1. **Chord Selection**:  
   Users can select predefined chords using buttons that change color (red for unselected and green for selected). The sequence is displayed in the chosen order.  

2. **Tempo Adjustment**:  
   A slider allows users to set the time interval between chords, providing flexibility for musical practice.  

3. **Sequence Sending**:  
   The selected chords are sent sequentially to the ESP32. The app uses HTTP requests to establish communication, ensuring accurate transmission at the configured tempo.  

4. **IP Address Configuration**:  
   A settings menu allows users to update the ESP32's IP address, making it easy to adapt to different networks.  

5. **Intuitive Interface**:  
   The interface is designed with a dark theme, featuring red highlights for a modern and user-friendly appearance.  

### **Technologies Used:**  
- **Programming Language**: Dart, using the Flutter framework.  
- **Libraries**:  
  - `http` for HTTP requests.  
  - `audioplayers` (imported but not currently used in the code).  
- **Integrated Hardware**: ESP32 to control LEDs on the guitar neck.  

### **Workflow:**  
1. The user selects chords through the interface.  
2. Sets the time interval between chords using the slider.  
3. Sends the sequence to the ESP32, which controls the LEDs to indicate finger positions on the guitar neck.  
4. Communication is established via HTTP requests, with the app sending data at the configured intervals.  

This app combines simplicity and efficiency, serving as a powerful tool for those who wish to learn or teach music with the support of technology.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
