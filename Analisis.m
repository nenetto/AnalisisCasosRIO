function AnalisisCasoRIO(folder)



mkdir('Resultados');

%% Calculo de los mapas TRE
% Mapa TRE_lineasCT
% Mapa TRE_puntos

TRE_lineasCT = CalculoImagenesTRE(0.1,'../Codigo/CT_mask_lineas.hdr', 'Resultados/TRE_lineasCT.hdr');
TRE_puntosCT = CalculoImagenesTRE(0.1,'../Codigo/CT_mask_puntos.hdr', 'Resultados/TRE_puntosCT.hdr');

Calculo_TRE_EjesPrincipales(0.1,'../Codigo/CT_mask_lineas.hdr');

%% Calculo de los FRE de las lineas

load('../Codigo/LineasCT.mat')
target = Datos/1000;

load('../Codigo/LineasOptPRE.mat')
source = LineasOptPRE;

load('../Codigo/MtransformacionLINEAS.mat')
MT = MtransFinal;

clear Datos LineasOptPRE MtransFinal

fre_lineas = CalculoLineasFRE(target,source,MT);



%% Calculo de los FRE de los puntos
load('../Codigo/PuntosCT.mat')
target = Datos/1000;

load('../Codigo/PuntosOptPRE.mat')
source = PuntosOptPRE;

load('../Codigo/MtransformacionPUNTOS.mat')
MT = MtransFinal;

clear Datos LineasOptPRE MtransFinal

fre_puntos = CalculoPuntosFRE(target,source,MT);



%% Calculo de la N superior de las líneas a los puntos (Fórmula Eu)

TRE_N = TRE_puntosCT;
TRE_N.img = TRE_puntosCT.img./TRE_lineasCT.img;
save_nii(TRE_N,'Resultados/TRE_N.hdr');

TRE_puntosCT.img = fre_puntos * TRE_puntosCT.img;
save_nii(TRE_puntosCT,'Resultados/TRE_puntosCT_FRE_included.hdr');

TRE_lineasCT.img = fre_lineas * TRE_lineasCT.img;
save_nii(TRE_lineasCT,'Resultados/TRE_lineasCT_FRE_included.hdr');

%% Copia de la imagen preoperatoria

copyfile('../Codigo/CTPRE.hdr','Resultados/CTPRE.hdr');
copyfile('../Codigo/CTPRE.img','Resultados/CTPRE.img');

save('Resultados/FRELineas.txt','fre_lineas','-ascii', '-double')
save('Resultados/FREPuntos.txt','fre_puntos','-ascii', '-double')

end