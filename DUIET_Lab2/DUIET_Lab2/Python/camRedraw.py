import cv2
import numpy as np
import json
import argparse  # For command-line argument parsing

# Function to parse command-line arguments
def parse_arguments():
    parser = argparse.ArgumentParser(description="Camera Redraw Program")
    parser.add_argument("--cam", type=int, default=0, help="Camera index (default: 0)")
    parser.add_argument("--width", type=int, default=1280, help="Frame width (default: 1280)")
    parser.add_argument("--height", type=int, default=720, help="Frame height (default: 720)")
    parser.add_argument("--profile", type=str, default="camera.json", help="Camera profile JSON file")
    return parser.parse_args()

# Function to load camera calibration data from a JSON file
def load_camera_calibration(profile_file):
    with open(profile_file, 'r') as json_file:
        camera_data = json.load(json_file)
    distCoeffs = np.array(camera_data["dist"])  # Distortion coefficients
    cameraMatrix = np.array(camera_data["mtx"])  # Camera matrix (intrinsic parameters)
    return cameraMatrix, distCoeffs

# Main function
def main():
    args = parse_arguments()

    # Load camera calibration data
    cameraMatrix, distCoeffs = load_camera_calibration(args.profile)

    # Create a VideoCapture object with the specified camera index
    cap = cv2.VideoCapture(args.cam)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, args.width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, args.height)

    isCalibed = True

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Undistort the captured frame using camera_matrix and dist_coeffs
        undistorted_frame = cv2.undistort(frame, cameraMatrix, distCoeffs)

        # Display the undistorted frame
        if isCalibed:
            cv2.imshow("Undistorted Camera View", undistorted_frame)
        else:
            cv2.imshow("Undistorted Camera View", frame)
        
        key = cv2.waitKey(1)

        if key == ord(' '):  # Press space key to toggle calibration
            isCalibed = not isCalibed
        elif key == ord('q'):  # Press 'q' key to exit
            break

    # Release the VideoCapture and close windows
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
