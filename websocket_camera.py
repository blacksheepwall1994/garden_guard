import cv2

# Replace 'your_video_file.mp4' with the path to your video file
video_file = "C:/Users/Admin/Downloads/test.mov"

# Set up the RTSP server
def rtsp_server():
    # Open the video file
    cap = cv2.VideoCapture(video_file)

    # Get video properties
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    # Define the RTSP server address
    rtsp_url = 'rtsp://localhost:8554/live'

    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'H264')
    server = cv2.VideoWriter(rtsp_url, fourcc, 20.0, (width, height))

    while True:
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture frame.")
            break

        # Display the frame locally
        cv2.imshow('Local Video', frame)

        # Write the frame to the RTSP server
        server.write(frame)

        # Break the loop when 'q' key is pressed
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release resources
    cap.release()
    server.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    rtsp_server()