function IMU_GUI
global A IMU IMUdata save closer

A.figure = figure('Name','E2BOX EBIMU 9DOFV4','NumberTitle','off','MenuBar','none','units','normalized','Position',[.2 .0 .6 .7]);
A.axis1=axes('parent',A.figure ,'units','normalized','position',[.1 .3 .70 .70],'NextPlot','replace');
grid(A.axis1,'on')  
A.axis1.Title.String='IMU trajectory';

 grid on
 
%     axis([-4 4 -4 4 -4 4])

%%% Angle UI
A.rolltext=uicontrol('parent',A.figure,'Style','text','String','roll','units','normalized','Position',[0.1,0.2,0.13,0.05]);
A.pitchtext=uicontrol('parent',A.figure,'Style','text','String','pitch','units','normalized','Position',[0.3,0.2,0.13,0.05]);
A.yawtext=uicontrol('parent',A.figure,'Style','text','String','yaw','units','normalized','Position',[0.5,0.2,0.13,0.05]);
A.roll=uicontrol('parent',A.figure,'Style','edit','String','roll','units','normalized','Enable','inactive','Position',[0.1,0.18,0.13,0.05]);
A.pitch=uicontrol('parent',A.figure,'Style','edit','String','pitch','units','normalized','Enable','inactive','Position',[0.3,0.18,0.13,0.05]);
A.yaw=uicontrol('parent',A.figure,'Style','edit','String','yaw','units','normalized','Enable','inactive','Position',[0.5,0.18,0.13,0.05]);

%%% Acc UI
A.accXtext=uicontrol('parent',A.figure,'Style','text','String','acc_X','units','normalized','Position',[0.1,0.12,0.13,0.05]);
A.accYtext=uicontrol('parent',A.figure,'Style','text','String','acc_Y','units','normalized','Position',[0.3,0.12,0.13,0.05]);
A.accZtext=uicontrol('parent',A.figure,'Style','text','String','acc_Z','units','normalized','Position',[0.5,0.12,0.13,0.05]);
A.accX=uicontrol('parent',A.figure,'Style','edit','String','acc_X','units','normalized','Enable','inactive','Position',[0.1,0.1,0.13,0.05]);
A.accY=uicontrol('parent',A.figure,'Style','edit','String','acc_Y','units','normalized','Enable','inactive','Position',[0.3,0.1,0.13,0.05]);
A.accZ=uicontrol('parent',A.figure,'Style','edit','String','acc_Z','units','normalized','Enable','inactive','Position',[0.5,0.1,0.13,0.05]);
%%%%%%%%%%%%% panel A %%%%%%%%%%%%%%%%%%
A.panel10 = uipanel('parent',A.figure,'Title','Plot','Position',[.87 .2 .12 .2]);
A.run10 = uicontrol('parent',A.panel10,'Style', 'pushbutton', 'String', 'Run','units','normalized','Position', [.07 .55 0.8 .2],'Callback',@pushbutton_run);
A.load = uicontrol('parent',A.panel10,'Style', 'pushbutton', 'String', 'Stop saving','units','normalized','Position', [.07 .3 0.8 .2],'Callback',@pushbutton_stopsave);
A.close = uicontrol('parent',A.panel10,'Style', 'pushbutton', 'String', 'Close','units','normalized','Position', [.07 0.05 0.8 .2],'Callback',@pushbutton_close);
A.saving = uicontrol('parent',A.panel10,'Style', 'pushbutton' , 'String', 'Saving','units','normalized','Position', [.07 .8 0.8 .2],'Callback',@pushbutton_saving);

%%%%%%%%%%%%% Callback function %%%%%%%%%%%%%%%%%%
  function pushbutton_run(source,callbackdata) 
    delete(instrfindall); % Erase All Serial Connection
    COMPORT='COM3';
    IMU=serial(COMPORT,'BaudRate', 115200, 'DataBits', 8, 'parity', 'none','stopbits',1);
    fopen(IMU); % Port Open
    IMUdata=[];
    pause(0.01);
    %fprintf(IMU,'<SOA2>');
    fprintf(IMU,'3C534F41323E')
    pause(0.01);
    i=1;
    j=1;
    origin=[0,0,0];
    leng=0.1;
    tx=[leng,0.0,0.0];
    ty=[0.0,leng,0.0];
    tz=[0.0,0.0,leng];
    predata=[0 0 0 0 0 0 0 0 0 0 0 0];
    V=[0, 0 ,0 ];
    D=[0,0,0];
    preV=[0,0,0];
    closer=0;
    filesave=1;
    while(1)
        data = fscanf(IMU);
        data=strcat(data);
        splitdata=strsplit(data,',');
        splitdata{1} = erase(splitdata{1},'*');
        c=clock;
        IMUdata(1:6)=c;
        IMUdata(7)=str2double(splitdata{1});
        IMUdata(8)=str2double(splitdata{2});
        IMUdata(9)=str2double(splitdata{3});
        IMUdata(10)=str2double(splitdata{4});
        IMUdata(11)=str2double(splitdata{5});
        IMUdata(12)=str2double(splitdata{6});
%         X = IMUdata(7);
%         Y = IMUdata(8);
%         Z = IMUdata(9);
% R = [                      cos(Y)*cos(Z),                      -cos(Y)*sin(Z),         sin(Y);
%       sin(X)*sin(Y)*cos(Z)+cos(X)*sin(Z), -sin(X)*sin(Y)*sin(Z)+cos(X)*cos(Z), -sin(X)*cos(Y);
%      -cos(X)*sin(Y)*cos(Z)+sin(X)*sin(Z),  cos(X)*sin(Y)*sin(Z)+sin(X)*cos(Z),  cos(X)*cos(Y)];
% 
%  V=V+(IMUdata(10:12)+predata(10:12))/2*(IMUdata(6)-predata(6));
%  D=D+(V+preV)/2*(IMUdata(6)-predata(6));
%

%         trajectory Generate
%         origin= origin+D;
%         new_tx=R*tx';
%         new_ty=R*ty';
%         new_tz=R*tz';
%         tx_vec(1,1:3) = origin;
%         tx_vec(2,:) = new_tx + origin';
%         ty_vec(1,1:3) = origin;
%         ty_vec(2,:) = new_ty + origin';
%         tz_vec(1,1:3) = origin;
%         tz_vec(2,:) = new_tz + origin';
%         hold on
%         p1=plot3(tx_vec(:,1), tx_vec(:,2), tx_vec(:,3));
%         set(p1,'Color','Green','LineWidth',1);
%         p1=plot3(ty_vec(:,1), ty_vec(:,2), ty_vec(:,3));
%         set(p1,'Color','Blue','LineWidth',1);
%         p1=plot3(tz_vec(:,1), tz_vec(:,2), tz_vec(:,3));
%         set(p1,'Color','Red','LineWidth',1);
        set(A.roll,'String',IMUdata(7))
        set(A.pitch,'String',IMUdata(8))
        set(A.yaw,'String',IMUdata(9))
        set(A.accX,'String',IMUdata(10))
        set(A.accY,'String',IMUdata(11))
        set(A.accZ,'String',IMUdata(12))
        
        pause(0.001); 
        if save>0
             datamat(j,:)=IMUdata;
             j=j+1;
            if length(datamat)==50
                s2=num2str(filesave);
                s1={'IMUbin_',s2,'.txt'};
                filename = strjoin(s1);
                fid=fopen(filename,'w');
                fprintf(fid,'%d/%d/%d %d:%d:%f ->>  %f , %f , %f , %f , %f , %f \n',datamat');
                fclose(fid);
                filesave=filesave+1;
                j=1;
                datamat=[];
            end
        end
        i=i+1;
        if(closer==1)
            break;
        end
        predata=IMUdata;
        preV=V;
    end
    fclose(IMU);  
  end
end

  function pushbutton_close(source,callbackdata) 
    global save closer
    closer=1;
    pause(0.001);
    close all;
    save = 0;
  end

  function pushbutton_stopsave(source,callbackdata)
  global save
    save = 0;
    pause(0.001);
  %%%% EMPTY
  end

function pushbutton_saving(source,callbackdata)
    global save
    pause(0.001);
    save = 1;
end
