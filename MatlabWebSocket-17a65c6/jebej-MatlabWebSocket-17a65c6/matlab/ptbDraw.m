function ptbDraw(variables_from_server, obj)

%Variables

wPtr= obj.wPtr;
screenSize= obj.screenSize;

currentX= str2double(variables_from_server{2}); %should be 2!!
currentY= str2double(variables_from_server{3});

width= screenSize(3);
hight= screenSize(4);

currentX= round(currentX.*width);
currentY = round(currentY.*hight);

[centerX,centerY] = RectCenter(screenSize); %screen center

dotDiameter= 10;
dot=[(currentX), (currentY), (currentX+dotDiameter), (currentY+dotDiameter)];
% dot= [ 400 400 410 410] % sanity check - draws a dot [x1 y1 x2 y2]
Screen('FillOval', wPtr, [0,255,178], dot);

% erase the past "screen" when a new one comes using:
%Screen(wPtr,'Flip'); 

% "Draw" by leaving the past screen on when a new one comes using:
Screen(wPtr,'Flip',[],1); 
pause(0.06);

end

% breakpoint - this doesn't work well in this configuration..
% function breakpoint
% Screen('CloseAll');
% keyboard;
% ShowCursor;
% end
