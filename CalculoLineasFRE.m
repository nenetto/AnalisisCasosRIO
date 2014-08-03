function fre = CalculoLineasFRE(lineas_target,lineas_source,MT)
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

    N_target = size(lineas_target,1);
    N_source = size(lineas_source,1);

    lineas_source_transformed = applyMt(lineas_source,MT)';  
   
    match = zeros(1,N_target);
    mindist = zeros(1,N_target);
    dx = zeros(1,N_target);
    dy = zeros(1,N_target);
    dz = zeros(1,N_target);
    for ki=1:N_target
        d=zeros(N_source,1);
        for ti=1:3
            d=d+(lineas_source_transformed(:,ti)-lineas_target(ki,ti)).^2;
        end
        [mindist(ki),match(ki)]=min(d);
        aux = lineas_source_transformed(match(ki),:)-lineas_target(ki,:);
        dx(ki) = aux(1);
        dy(ki) = aux(2);
        dz(ki) = aux(3);
    end
    
    mindist = sqrt(mindist);
    
    fre = sqrt(sum(mindist.^2)/length(mindist))*1000;
    
    
end