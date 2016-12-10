classdef nightClient < matWebSocketClient
    
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = nightClient(URI)
            %Constructor
            obj@matWebSocketClient(URI);
        end
    end
    
    methods (Access = protected)
        function [variables_from_server] = onMessage(~,message,~) %we recieve a string - read it and paint using it
            % This function simply displays the message received
            % fprintf('Message received:\n%s\n\n',message);
            variables_from_server = sscanf( message , '%d,%f,%f,%d' );
            draw_users( 1 , variables_from_server );
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

