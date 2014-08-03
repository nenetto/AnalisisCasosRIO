function fre = CalculoPuntosFRE(puntos_target,puntos_source,MT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        
%                                                                         %
%                                                                         %
% Parametros                                                              %
%                                                                         %  
% lineas_target:
% lineas_source:
% MT: 
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


N = size(puntos_target,1);
fre = 0;

source_transformed = applyMt(puntos_source,MT)';  


for i=1:N
   fre = fre + norm(puntos_target(i,:) - source_transformed(i,:))^2;  
end

fre = sqrt(fre/N)*1000;

end