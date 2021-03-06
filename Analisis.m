function AnalisisCasoRIO(folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta funcion analiza y extrae todos los resultados para un caso RIO a 
% partir de toda la informaci�n recogida en la carpeta "Codigo" de cada caso
% RIO realizado. Las operaciones que realiza son las siguientes
% 
% 1. Extrae un mapa de TRE para el registro realizado mediante l�neas. Usa la
% imagen de m�scara de las l�neas para calcular la componente espacial de la 
% f�rmula empleada por Fitzpatrick.
% 
% 2. Extrae un mapa de TRE para el registro realizado mediante puntos. Usa la
% imagen de m�scara de los puntos para calcular la componente espacial de la 
% f�rmula empleada por Fitzpatrick.
% 
% 
% 3. Extrae un mapa de TRE evaluar la componente/deriva espacial en cada eje 
% principal para el registro por l�neas.
% 
% 4. Calcula el FRE de las l�neas
% 
% 5. Calcula el FRE de los puntos
% 
% 6. Crea nuevos mapas que multiplican FRE por el mapa de componente espacial
% TRE antes extra�do para cada caso: l�neas o puntos
% 
% 7. Crea una bola donde calcula el error para las l�neas y extrae la media y
% la desviaci�n est�ndar.
%                                                                         
% Parametros                                                              
%                                                                          
% folder: 
%                                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

str_aux = [folder, '/Resultados'];
mkdir(str_aux);

%% Calculo de los mapas TRE

% Mapa TRE_lineasCT
str_aux1 = [folder '/Codigo/CT_mask_lineas.hdr'];
str_aux2 = [folder '/Resultados/TRE_map_spatialComp_lineasCT.hdr'];
TRE_lineasCT = CalculoImagenesTRE(0.1,str_aux1, str_aux2);


% Mapa TRE_puntos
str_aux1 = [folder '/Codigo/CT_mask_puntos.hdr'];
str_aux2 = [folder '/Resultados/TRE_map_spatialComp_puntosCT.hdr'];
TRE_puntosCT = CalculoImagenesTRE(0.1,str_aux1, str_aux2);


%% Calculo de los FRE de las lineas

load('../Codigo/LineasCT.mat')
target = Datos/1000;

load('../Codigo/LineasOptPRE.mat')
source = LineasOptPRE;

load('../Codigo/MtransformacionLINEAS.mat')
MT = MtransFinal;

clear Datos LineasOptPRE MtransFinal

FRE_lineas = CalculoLineasFRE(target,source,MT);



%% Calculo de los FRE de los puntos
load('../Codigo/PuntosCT.mat')
target = Datos/1000;

load('../Codigo/PuntosOptPRE.mat')
source = PuntosOptPRE;

load('../Codigo/MtransformacionPUNTOS.mat')
MT = MtransFinal;

clear Datos LineasOptPRE MtransFinal

FRE_puntos = CalculoPuntosFRE(target,source,MT);



%% Calculo de la N superior de las l�neas a los puntos (F�rmula Eu)

TRE_N = TRE_puntosCT;
TRE_N.img = TRE_puntosCT.img./TRE_lineasCT.img;
save_nii(TRE_N,'Resultados/TRE_N.hdr');

TRE_puntosCT.img = FRE_puntos * TRE_puntosCT.img;
save_nii(TRE_puntosCT,'Resultados/TRE_puntosCT_FRE_included.hdr');

TRE_lineasCT.img = FRE_lineas * TRE_lineasCT.img;
save_nii(TRE_lineasCT,'Resultados/TRE_lineasCT_FRE_included.hdr');

%% Copia de la imagen preoperatoria

copyfile('../Codigo/CTPRE.hdr','Resultados/CTPRE.hdr');
copyfile('../Codigo/CTPRE.img','Resultados/CTPRE.img');

save('Resultados/FRELineas.txt','fre_lineas','-ascii', '-double')
save('Resultados/FREPuntos.txt','fre_puntos','-ascii', '-double')





Calculo_TRE_EjesPrincipales(0.1,'../Codigo/CT_mask_lineas.hdr');



end