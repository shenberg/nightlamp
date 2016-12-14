classdef nightClient < matWebSocketClient
    
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % all variables that enter are written here
    
        wPtr= [];
        screenSize= [];          
        
    end
    
    methods
        function obj = nightClient(URI,wPtr,screenSize)
            %Constructor - meaning: here we define the features that enter
            %functions (fron the properties)
            obj@matWebSocketClient(URI);
            obj.wPtr= wPtr;
            obj.screenSize= screenSize;
        end
    end
    
    methods (Access = protected)
        function onMessage(obj,message,~) %we recieve a string - read it and paint using it
            % This function simply displays the message received
            % fprintf('Message received:\n%s\n\n',message);
                      
%             variables_from_server = sscanf( message , '%f,%*s,%f,%d' )
%             variables_from_server(1)=0;
             
            variables_from_server = strsplit(message,','); %splits the string to all its content that is seperated by a comma           
           
            %draw_users( 1 , variables_from_server ); %our old "plot" function
           ptbDraw(variables_from_server, obj);
            
%             fprintf( '%f,%f\n', variables_from_server(2) , variables_from_server(3) );
        end
        
        function onOpen(~,message,~)
            fprintf('Connection opened:\n%s\n\n',message);
        end
        
        function onClose(~,message,~)
            fprintf('Server closed connection:\n%s\n\n',message);
        end
        
        function onError(~,message,~)
            fprintf('Error:\n %s\n\n',message);
        end
    end
end

