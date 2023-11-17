import websockets
import asyncio
import cv2
import base64

port = 3000
print("Started server on port:", port)

async def transmit(websocket, path):
    print("Client Connected !")
    try:
        cap = cv2.VideoCapture(0)

        while cap.isOpened():
            _, frame = cap.read()

            # Mirror the frame horizontally
            mirrored_frame = cv2.flip(frame, 1)

            encoded = cv2.imencode('.jpg', mirrored_frame)[1]

            data = str(base64.b64encode(encoded))
            data = data[2:len(data)-1]

            await websocket.send(data)

            cv2.imshow("Transmission", frame)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    except websockets.connection.ConnectionClosed as e:
        print("Client Disconnected !")

start_server = websockets.serve(transmit, port=port)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
