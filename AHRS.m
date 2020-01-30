% AHRS EBIMU 9DOF V4 for raspberry pi
% This code is written by SnowyOwl
clear; clc;
ipadress='192.168.0.0'; %ip adress Raspberry pi
mypi=raspi(ipadress,'pi','password'); %raspi obeject consturct
IMU=serialdev(mypi,'/dev/ttyUSB0'); %AHRS Serial Port
IMUdata=[];
readdata="";
  for i=1:50
        data="";
        while(readdata~='*')
            readdata= read(IMU,1,'char');
        end
        readdata= read(IMU,1,'char');
        data=data+readdata;
        while(readdata~="*")
             readdata= read(IMU,1,'char');
             data=data+readdata;
        end            
        % dataÁ¤¸®
        splitdata=strsplit(data,',');
        splitdata{6} = splitdata{6}(1:length(splitdata{6})-3);
        c=clock;
        IMUdata(1:6)=c;
        IMUdata(7)=str2double(splitdata{1});
        IMUdata(8)=str2double(splitdata{2});
        IMUdata(9)=str2double(splitdata{3});
        IMUdata(10)=str2double(splitdata{4});
        IMUdata(11)=str2double(splitdata{5});
        IMUdata(12)=str2double(splitdata{6});
        pause(0.001)
end
