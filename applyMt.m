function source_transformed = applyMt(source,MT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        
%                                                                         %
%                                                                         %
% Parametros                                                              %
%                                                                         %  
% lineas_source:
% MT: 
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    N = size(source,1); 
    source_transformed = MT(1:3,1:3) * source' + repmat(MT(1:3,4), 1, N);
end



