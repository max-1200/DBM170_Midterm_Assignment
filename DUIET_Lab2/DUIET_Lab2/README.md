# DUIET23Q2 Lab2: ArUCo for Surface Computing

The Processing Example codes are compatible with the Python server provided in Lab2. Additionally, we provide a new Python server **cvMarkerServerV2** to facilitate easy parameter setup in the Terminal. 

If you plan to use an external camera, check the **Setup an External Camera** section.

If you plan to use the built-in camera on your laptop, the Python server provided in Lab1 is sufficient. Follow the instructions in Lab 1's README.md to calibrate the camera. Once calibration is complete, proceed to run the CVMarkerServer:
```shell
python cvMarkerServer.py
```
and use **Processing/MarkerReceiverOSC_v4a_Basic** and the **Patterns/ArUco_Grid50.pdf** to see if the marker tracking is working.

## Tracking Marker Events on a 2D Plane: 
### Processing/MarkerReceiverOSC_v4b_PWarpingTouch
This Processing sketch defines a tracking plane using four corner markers (ID: 0, 1, 2, 3) and accomplishes two functions:

1. Map 3D marker locations to a 2D plane using a homography matrix and Cartesian coordinates derived from the four corner markers.
2. Detect surface contact by measuring the 3D distance between each marker and the plane. The touch thresold can be adjusted by 
```java
   float touchThreshold = 0.015; //e.g., Touch is detected when the distance between each marker and the plane is less than 1.5 cm (unit: m).
```
Pressing the `SPACE` key recalculates the plane in Processing.

### Processing/MarkerReceiverOSC_v4c_PWarpingBundle
This Processing sketch detects the bottom of an object that attached at least one CV Marker, namely **bundle**, using the marker's 3D locations and orientations. It accomplishes two main functions:

1. The system calculates the 3D location of the bottom of an object with a marker attached to its top, considering the marker's 3D location, orientation, and relative position to the object's bottom. For instance,
```java
int[][] bundlesIDs = {{21},{14}}; //The marker ID of the two objects
PVector[][] bundlesOffsets = {{new PVector(0,0,-0.124)},{new PVector(0,0,-0.048)}}; //irelative position to the object's bottom. Unit: m.
```
2. The distance between the derived bottom location and the plane determines if the object touches the surface.

### Processing/MarkerReceiverOSC_v4d_PWarpingOnScreen
This Processing sketch enables marker tracking on a computer display, adjusting scale for various four-corner marker patterns.

1. Measure the width of the A4-size four-corner marker patterns on the screen.
2. Use the measurement to scale the on-screen marker to real A4 size by setting the variable:
```java
   float paperWidthOnScreen = 230; // unit: mm
```
Then, restart the Procesing code, the A4 paper will be scaled to the real-world size accordingly. Now, if the marker is too large for your screen, put a piece of A4 printed paper on it instead.

## Setup an external camera: 

0. Open the terminal
   - **Mac:** Use the Terminal app.
   - **PC:** Open the Miniconda PowerShell.

Change the directory to the Python folder using the following command:
```shell
cd [YOUR DUIETLAB2/PYTHON FOLDER PATH]
```
Activate the Python virtual environment:
```shell
conda activate p39
```
1. Run the camCapture program with your external camera:
```shell
python camCapture.py --cam 1
```
use "--cam 0" to choose the previously used camera

and then press the SPACE key to capture at least four images containing the checkerboard pattern (calibPattern.pdf). Then, press the 'q' key to quit the program.

2. Run the camCalib program, but save the calibration file of the external camera as camera_ext.json:
```shell
python camCalib.py --profile camera_ext.json
```
use "--profile [NAME]" to save the camera profile to a file [NAME].

press the SPACE key to browse the images to ensure that the corners of the checkerboard patterns were captured until the process is finished. Check the terminal to verify the camera resolution (e.g., 1280 720) for later use. The camera parameters are saved as camera.json.

3. Run the camRedraw program with the previously used camera and the previously saved profile camera_ext.json:
```shell
python camRedraw.py --cam 0 --profile camera_ext.json
```
and press the SPACE key to see the results before and after then lens correction. Then, press the 'q' key to quit the program.

4. run the cvMarkerServer with the previously used camera and the previously saved profile camera_ext.json
```shell
python cvMarkerServerV2.py --cam 0 --profile camera_ext.json
```
and use the 3x4 grid of 50mm-width ARUCO5x5 patterns (aruco_50_3x4.pdf) for testing. Once you observe the correct results, leave the server running.

To detect smaller ArUco markers (e.g., 2.5cm width):
```shell
python cvMarkerServerV2.py --cam 0 --profile camera_ext.json --size 0.025                       
```
Results can be used in the "Processing v4a Basic" example.


