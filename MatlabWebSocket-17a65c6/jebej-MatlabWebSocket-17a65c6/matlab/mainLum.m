     function mainLum % starts Luminous!

clear all ; close all;  clc;
'shuffle';  rng('shuffle'); 
 
[wPtr,  screenSize]= openScreen
URI= 'ws://localhost:3001';

message='Welcome to Luminous!'; 
drawMessage(message, wPtr, screenSize); %leaves the msg on until a key is pressed
    
n = nightClient(URI,wPtr,screenSize); %recieves phone locations from java

end

function [wPtr, screenSize]=openScreen %PsychToolBox always starts with this

Screen('Preference', 'Verbosity', 1);   %supress warnings to console
Screen('Preference', 'VisualDebugLevel', 1);    %suppress check screen
Screen('Preference', 'SkipSyncTests', 2);
Screens=Screen('Screens');
ScreenNumber=max(Screens);
[wPtr, screenSize] = Screen('OpenWindow',ScreenNumber, [0 0 0]);
HideCursor;
end

% drawMessage
function drawMessage(message, wPtr, screenSize, backgroundColor,waitingTime, sizeFont, typeFont, location)

if nargin<3
    message=' ';
    backgroundColor=[0 0 0];
    waitingTime=0.5;
    sizeFont=50;
    typeFont='angsanaUPC';
    location=0.25;
end

if nargin<4
    backgroundColor=[0 0 0];
    waitingTime=0.5;
    sizeFont=50;
    typeFont='angsanaUPC';
    location=0.25;
end

if nargin<5
    waitingTime=0.5;
    sizeFont=50;
    typeFont='angsanaUPC';
    location=0.25;
end

if nargin<6
    sizeFont=50;
    typeFont='angsanaUPC';
    location=0.25;
end

if nargin<7
    typeFont='angsanaUPC';
    location=0.25;
end

if nargin<8
    location=0.25;
end

oldTextSize=Screen('TextSize', wPtr);
Screen('TextFont',wPtr, typeFont);
Screen('TextSize',wPtr,sizeFont);
DrawFormattedText(wPtr,message,'center', location*screenSize(4),[255 255 102] );
Screen('Flip', wPtr);
WaitSecs(waitingTime);
RestrictKeysForKbCheck([]);
KbWait;
Screen('TextSize',wPtr,oldTextSize);
end