import matplotlib.pyplot as plt 
import matplotlib.image as mpimg 
import cv2
import numpy as np
import math

def region_of_interest(img, vertices):
    mask = np.zeros_like(img)
    if len(img.shape)>2:
        channel_count =img.shape[2]
        ignore_mask_color = (255,)*channel_count
    else:
        ignore_mask_color =255
    cv2.fillPoly(mask,vertices,ignore_mask_color)
    masked_image =cv2.bitwise_and(img,mask)
    return masked_image


cap = cv2.VideoCapture("test.mp4")
while (True):
    ret, src = cap.read() 
    src = cv2.resize(src, (640, 360))
    gray=cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
    blur_gray=cv2.GaussianBlur(gray,(5,5),0)
    edge = cv2.Canny(blur_gray,50,200) #CANNYEDGE 검출
    imshape=src.shape
    vertices=np.array([[(160,imshape[0]-30),(290,250),(480,250),(imshape[1]-40,imshape[0]-30)]],dtype=np.int32) ##MASK 영역
    mask=region_of_interest(edge,vertices)
    cdst = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)
    cdstP = np.copy(cdst)
    lines = cv2.HoughLines(mask, 1, np.pi / 180, 150, None, 0, 0) #HOUGHLINE 사용으로 line 검출
    
    if lines is not None:
        for i in range(0, len(lines)):
            rho = lines[i][0][0]
            theta = lines[i][0][1]
            a = math.cos(theta)
            b = math.sin(theta)
            x0 = a * rho
            y0 = b * rho
            pt1 = (int(x0 + 1000 * (-b)), int(y0 + 1000 * (a)))
            pt2 = (int(x0 - 1000 * (-b)), int(y0 - 1000 * (a)))
            cv2.line(cdst, pt1, pt2, (0, 0, 255), 3, cv2.LINE_AA)
 
    linesP = cv2.HoughLinesP(mask, 1, np.pi / 180, 50, None, 50, 10)
 
    if linesP is not None:
        for i in range(0, len(linesP)):
            l = linesP[i][0]
            cv2.line(cdstP, (l[0], l[1]), (l[2], l[3]), (0, 0, 255), 3, cv2.LINE_AA)
 
    cv2.imshow("Source", src)
    cv2.imshow("Detected Lines (in red) - Standard Hough Line Transform", cdst)
    cv2.imshow("Detected Lines (in red) - Probabilistic Line Transform", cdstP)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
 
cap.release()
cv2.destroyAllWindows()