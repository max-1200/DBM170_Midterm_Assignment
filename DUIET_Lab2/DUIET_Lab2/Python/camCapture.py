import cv2
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser(description='Camera Capture Program')
parser.add_argument('--cam', type=int, default=0, help='Camera index to use')
parser.add_argument('--width', type=int, default=1280, help='Frame width')
parser.add_argument('--height', type=int, default=720, help='Frame height')
args = parser.parse_args()

# Initialize the camera capture
cap = cv2.VideoCapture(args.cam)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, args.width)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, args.height)

id = 0

while True:
    ret, frame = cap.read()

    cv2.imshow("Camera Capture", frame)

    key = cv2.waitKey(1) & 0xFF

    if key == ord(' '):
        filename = str(id) + ".jpg"
        id += 1
        cv2.imwrite(filename, frame)
        print(f"Saved {filename}")

    elif key == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
