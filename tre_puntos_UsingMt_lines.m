function resultado = tre_puntos_UsingMt_lines(folder)




str_aux = [folder, '/Codigo/PuntosOptPRE.mat'];
load(str_aux);
str_aux = [folder, '/Codigo/MtransformacionLINEAS.mat'];
load(str_aux);




% TRE 
    Dicp2 = MtransFinal(1:3,1:3) * PuntosOpt' + repmat(MtransFinal(1:3,4), 1, length(PuntosOpt));
    TRE_puntos_aprox = sum((Dicp2-PuntosCT').^2);
    
    resultado = cat(2,PuntosOpt,TRE_puntos_aprox);

end