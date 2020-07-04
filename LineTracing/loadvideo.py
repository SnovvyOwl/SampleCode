import cv2
import numpy as np
cap = cv2.VideoCapture("test.mp4")
while(cap.isOpened()):
    # 동영상 파일로부터 이미지를 가져옴
    ret, frame = cap.read()

    # 화면에 이미지를 출력, 연속적으로 화면에 출력하면 동영상이 됨.
    cv2.imshow('frame',frame)

    # ESC 키 누르면 루프 중단
    if cv2.waitKey(1) & 0xFF == 27:
        break;

# 모든 자원을 해제함
cap.release()
cv2.destroyAllWindows()