function Resultados = Calculo_TRE_EjesPrincipales(resolucion,mascara)


% Lectura de la mascara

    lineas_original = load_nii(mascara);

% Obtención de la resolucion de la mascara

    tam_voxel = lineas_original.hdr.dime.pixdim(2:4);
    tam_imagen = lineas_original.hdr.dime.dim(2:4);
    
% Calculo de la resolucion nueva
    
    tam_imagen_result = floor(tam_imagen * resolucion); %% 
    tam_voxel_result = tam_voxel .* (tam_imagen./tam_imagen_result);

% Calculo de las posiciones de la mascara

    indices = find(lineas_original.img~=0);
    [X_lin,Y_lin,Z_lin]=ind2sub(tam_imagen,indices);

    X_lin = X_lin*tam_voxel(1); 
    Y_lin = Y_lin*tam_voxel(2);
    Z_lin = Z_lin*tam_voxel(3);
    
    distribucion = [X_lin Y_lin Z_lin];
    

% Calculo de los ejes principales
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

eje = [0:0.2:200]';

X_data = [  eje*principal_axis_1(1) + centroide(1) ;  eje*principal_axis_2(1)+ centroide(1); eje*principal_axis_3(1)+ centroide(1)  ];
Y_data = [  eje*principal_axis_1(2)+ centroide(2);  eje*principal_axis_2(2)+ centroide(2); eje*principal_axis_3(2) + centroide(2) ];
Z_data = [  eje*principal_axis_1(3)+ centroide(3);  eje*principal_axis_2(3)+ centroide(3); eje*principal_axis_3(3)+ centroide(3)  ];
    

posiciones = [X_data Y_data Z_data];
    
 
tre_map = TRE_dist(distribucion, posiciones)';


d = length(eje);
Resultados = [tre_map(1:d) tre_map((d+1):2*d) tre_map((2*d+1):end) eje];


% save('Resultados/ResultadosEjesPrincipales.txt','Resultados','-ascii', '-double')
% 



    

end