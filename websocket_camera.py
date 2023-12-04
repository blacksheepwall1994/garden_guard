import cv2

# Replace 'your_video_file.mp4' with the path to your video file
video_path = "C:/Users/Admin/Downloads/test.mov"

# Set the RTSP stream URL
rtsp_url = "rtsp://localhost:8554"

# Open the local video file
cap = cv2.VideoCapture(video_path)

# Get the video width and height
width = int(cap.get(3))
height = int(cap.get(4))

# Set the codec and create a VideoWriter object for RTSP streaming
fourcc = cv2.VideoWriter_fourcc(*'H264')
rtsp_stream = cv2.VideoWriter(rtsp_url, fourcc, 20.0, (width, height))

try:
    while True:
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture frame.")
            break

        # Write the frame to the RTSP stream
        rtsp_stream.write(frame)

        # Display the frame (optional)
        cv2.imshow("Frame", frame)

        # Break the loop if 'q' key is pressed
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

finally:
    # Release the resources
    cap.release()
    rtsp_stream.release()
    cv2.destroyAllWindows()
