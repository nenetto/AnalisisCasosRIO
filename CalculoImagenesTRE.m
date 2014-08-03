function tre_map_nii = CalculoImagenesTRE(resolucion,mascara, output)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Este script analiza las máscaras obtenidas mediante la segmentación de  %
% las líneas radiopacas en las imágenes preoperatorias. A partir de dichas%
% imágenes, crea otras nuevas donde en cada vóxel se calcula el error     %
% teórico TRE (Target Registration Error) [1]. No tiene en cuenta el FRE  %
% del registro. Sólo la componente de distribución para crear la imagen.  %
%                                                                         % 
% [1] Fitzpatrick et al. 2001 The Distribution of Target Registration     %
%     Error in Rigid-Body Point-Based Registration                        %
%                                                                         %
%                                                                         %
% Parametros                                                              %
%                                                                         %  
% resolucion: el mapa TRE se calcula a una                                %
%             resolucion = resolucion * [resolucion de mascara]           %
% mascara: mascara de [0,~0] de la distribucion de marcadores   
% output: prefijo para los nombres de archivo resultante
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


% Lectura de la mascara

    lineas_original = load_nii(mascara);

% Obtención de la resolucion de la mascara

    tam_voxel = lineas_original.hdr.dime.pixdim(2:4);
    tam_imagen = lineas_original.hdr.dime.dim(2:4);
    
% Calculo de la resolucion nueva
    
    tam_imagen_result = floor(tam_imagen * resolucion); %% ARREGLAR NO PUEDE DAR DECIMALES
    tam_voxel_result = tam_voxel .* (tam_imagen./tam_imagen_result);

% Calculo de las posiciones de la mascara

    indices = find(lineas_original.img~=0);
    [X_lin,Y_lin,Z_lin]=ind2sub(tam_imagen,indices);

    X_lin = X_lin*tam_voxel(1); 
    Y_lin = Y_lin*tam_voxel(2);
    Z_lin = Z_lin*tam_voxel(3);
    
    posiciones_mask = [X_lin Y_lin Z_lin];
    
% Calculo de las posiciones donde calcular TRE y creacion de la imagen mapa

    posiciones_tre = zeros(tam_imagen_result(1),tam_imagen_result(2),tam_imagen_result(3));
    indices_tre = find(posiciones_tre == 0);
    [X_lin_tre,Y_lin_tre,Z_lin_tre]=ind2sub(tam_imagen_result,indices_tre);

    X_lin_tre = X_lin_tre*tam_voxel_result(1); 
    Y_lin_tre = Y_lin_tre*tam_voxel_result(2);
    Z_lin_tre = Z_lin_tre*tam_voxel_result(3);
    
    posiciones_tre = [X_lin_tre Y_lin_tre Z_lin_tre];

% Calculo de TRE en cada posicion_tre mediante la distribucion
% posiciones_mask

    tre_map = TRE_dist(posiciones_mask, posiciones_tre);

    
% Guardado de datos y fin
    
    tre_map = reshape(tre_map,tam_imagen_result(1),tam_imagen_result(2),tam_imagen_result(3));
    
    tre_map_nii = lineas_original;
    tre_map_nii.img = tre_map;
    tre_map_nii.hdr.dime.datatype = 64;
    tre_map_nii.hdr.dime.bitpix = 64;

    tre_map_nii.hdr.dime.dim(2:4) = tam_imagen_result;
    tre_map_nii.hdr.dime.pixdim(2:4) = tam_voxel_result;
    
    save_nii(tre_map_nii,output);


%     figure
%     plot3(X_lin(:),Y_lin(:),Z_lin(:),'.b');
%     xlabel('x'); ylabel('y'); zlabel('z');
%     file = [output 'CTmask.tiff'];
%     print( '-dtiff', file)
%     title('Mask CT')
%     axis equal
%     hold on

end