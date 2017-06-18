clc
clear all
close all
imaqreset
instrreset
s=serial('COM3');
set(s,'BaudRate',9600); 
fopen(s);
vid = videoinput('winvideo',2,'YUY2_320x240');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;
start(vid)
 
Azero=zeros(240,320,3);
choice=menu('Do you want to train database','Y','N');
if (choice)==1
    T=trainexp(vid);
    save('db.mat','T');
else
    load db.mat
    [m, A, Eigenfaces] = EigenfaceCore(T);  
    choice1=1;
    while choice1==1
         choice1=menu('Continue Testing','yes','no');
 if (choice1~=1)
     break;
 end
 
    preview(vid)
pause(5);
closepreview(vid)
TestImage=getsnapshot(vid);
faceDetector = vision.CascadeObjectDetector;
 bboxes = step(faceDetector, TestImage);
 IFace = imcrop(TestImage,bboxes);
 IFace=imresize(IFace,[160 160]);
   IFace = rgb2gray(IFace);
 
IFace=imresize(IFace,[160 160]);
 
OutputNum = Recognition(IFace, m, A, Eigenfaces);
if OutputNum<17
    [Q,fs]=audioread('auth.wma');
    player=audioplayer(Q,fs);
    disp('Authorized')
    playblocking(player)
    fprintf(s,'A')
if OutputNum<9
    [Q,fs]=audioread('happy.wma');
     disp('Happy')
    player=audioplayer(Q,fs);
    playblocking(player)
    fprintf(s,'h')
else
    [Q,fs]=audioread('sad.wma');
     disp('Sad')
    player=audioplayer(Q,fs);
    playblocking(player)
    fprintf(s,'s')
end
dir=1;
while (dir==1)
   nav=menu('cHOOSE dIRECTION','Front','Left','Right','Stop','Back','Exit') ;
   switch(nav)
       case 1
           fprintf(s,'2')
       case 2
           fprintf(s,'4')
       case 3
           fprintf(s,'6')
       case 4
           fprintf(s,'5')
       case 5
           fprintf(s,'8')
       case 6
           fprintf(s,'5')
           dir=0;
           [Q,fs]=audioread('bye.wma');
           player=audioplayer(Q,fs);
           playblocking(player)
   end      
end
else
    [Q,fs]=audioread('unauth.wma');
    disp('Unauthorised')
    player=audioplayer(Q,fs);
    playblocking(player)
    fprintf(s,'u')
end
