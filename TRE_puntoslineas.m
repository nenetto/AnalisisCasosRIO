% FRE de los puntos usando las l�neas


%% TRE de los puntos con la Transformacion de las l�neas *!*!*!*!*!
load('../Codigo/PuntosCT.mat')
target = Datos/1000;

load('../Codigo/PuntosOptPRE.mat')
source = PuntosOptPRE;

load('../Codigo/MtransformacionLINEAS.mat')
MT = MtransFinal;

clear Datos LineasOptPRE MtransFinal

fre_puntos_lineas = CalculoPuntosFRE(target,source,MT)

save('Resultados/FREPuntos_lineas.txt','fre_puntos_lineas','-ascii', '-double')