function [wPtr screenSize]=openScreen

Screen('Preference', 'Verbosity', 1);   %supress warnings to console
Screen('Preference', 'VisualDebugLevel', 1);    %suppress check screen
Screen('Preference', 'SkipSyncTests', 2);
Screens=Screen('Screens');
ScreenNumber=max(Screens);
[wPtr screenSize] = Screen('OpenWindow',ScreenNumber, [0 0 0]);
HideCursor;
end