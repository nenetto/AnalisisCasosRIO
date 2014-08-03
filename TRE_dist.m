function tre_distribucion = TRE_dist(distribucion, posiciones)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta funcion analiza el TRE a partir de una distribucion de puntos      %
% usados como marcadores para el registro. Calcula un vector que  es el   %
% valor del componente TRE dependiente de la distribucion en las          %
% posiciones dadas.                                                       %
%                                                                         %
% [1] Fitzpatrick et al. 2001 The Distribution of Target Registration     %
%     Error in Rigid-Body Point-Based Registration                        %
%                                                                         %
%                                                                         %
% Parametros                                                              %
%                                                                         %  
% distribucion: posicion de las marcas usadas para registro               %
% posiciones: posiciones donde calcular el TRE_distribucion               %  
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

[Num_posiciones, ~] = size(posiciones);
N = size(distribucion,1);

% Calculo del centroide distribucion, entorno al cual se calcularán los TRE

centroide = mean(distribucion);

% Matriz covarianza (ejes principales) para distribucion
vect_fiduciales_centroide = distribucion - repmat(centroide, N, 1);
C = cov(vect_fiduciales_centroide);
[U,~,~] = svd(C); % S -> autovalores, U -> autovectores, uno por cada columna
principal_axis_1 = U(:,1);
principal_axis_2 = U(:,2);
principal_axis_3 = U(:,3);


ejes_principales(1,:) = U(:,1)';
ejes_principales(2,:) = U(:,2)';
ejes_principales(3,:) = U(:,3)';


dist_fiduciales_centroide_axis1 =[];
dist_fiduciales_centroide_axis2 =[];
dist_fiduciales_centroide_axis3 =[];

for i=1:N
    dist_fiduciales_centroide_axis1 = [dist_fiduciales_centroide_axis1 norm(cross(vect_fiduciales_centroide(i,:),principal_axis_1))/norm(principal_axis_1)];
    dist_fiduciales_centroide_axis2 = [dist_fiduciales_centroide_axis2 norm(cross(vect_fiduciales_centroide(i,:),principal_axis_2))/norm(principal_axis_2)];
    dist_fiduciales_centroide_axis3 = [dist_fiduciales_centroide_axis3 norm(cross(vect_fiduciales_centroide(i,:),principal_axis_3))/norm(principal_axis_3)];
end

f1=sqrt(mean(dist_fiduciales_centroide_axis1.^2)); %rms
f2=sqrt(mean(dist_fiduciales_centroide_axis2.^2));
f3=sqrt(mean(dist_fiduciales_centroide_axis3.^2));
fk = [f1 f2 f3];


% Calculo de los dk dependientes de las posiciones

for i=1:Num_posiciones
    APs(i,:) = posiciones(i,:)-centroide;
end

dk = zeros(Num_posiciones,3);

for i= 1: Num_posiciones 
    for k = 1:3
    dk(i,k) = norm(cross(ejes_principales(k,:),APs(i,:)));
    end  
end

% calculo del tre

for i = 1:Num_posiciones

    tre_distribucion(i) = sqrt(1 + sum((dk(i,:)./fk).^2));

end


end