function LIM_RegistroPRE_vero()

%% RegistroLineas carga las líneas y las registra con las originales mediante
%ICP
clear all


% Se cargan los datos adquiridos PRE
load('LineasOptPRE.mat');
%load('PuntosLineasOptPRE.mat');
load('PuntosOptPRE.mat');

LineasOpt = LineasOptPRE;
PuntosOpt = PuntosOptPRE;



% Se cargan los puntos adquiridos en el CT
load('PuntosCT.mat');
PuntosCT = Datos/1000;
load('LineasCT.mat');
LineasCT = Datos/1000;

%
Npuntos = 7;


[MtransFinal,error] = registro(PuntosOpt,PuntosCT);


    save('MtransformacionPUNTOS.mat','MtransFinal');
    save('MtransformacionPUNTOS.txt','MtransFinal','-ascii', '-double')
    %save('C:\Radiance\Output\MtransformacionPUNTOS.dat','MtransFinal','-ascii', '-double')
    
  %
    figure
    Dicp = MtransFinal(1:3,1:3) * PuntosOpt' + repmat(MtransFinal(1:3,4), 1, length(PuntosOpt));
    FRE_rms_puntos_mm = sqrt(mean((sqrt(sum((Dicp-PuntosCT').^2))).^2))*1000
    plot3(PuntosCT(:,1),PuntosCT(:,2),PuntosCT(:,3),'b.',Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
    %plot3(PuntosCT(:,1),PuntosCT(:,2),PuntosCT(:,3),'b.',PuntosOpt(:,1),PuntosOpt(:,2),PuntosOpt(:,3),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Point Based Registration');
    file = 'Point_Based_Registration.tiff';
    print( '-dtiff', file)



% Se cargan las líneas adquiridas en el CT








% Se procede al registro

% Inicialización con los puntosCT (inicio de las líneas)

% Registro de los puntos
    
    M_inicializacion = MtransFinal; %eye(4);


% Registro por ICP

    Ricp = M_inicializacion(1:3,1:3);
    Ticp = M_inicializacion(1:3,4);

    D_inicial = Ricp * LineasOpt' + repmat(Ticp, 1, length(LineasOpt));  
    % FRE inicial
    [~, mindist, ~, ~, ~] = match_bruteForce(D_inicial,LineasCT');
    FRE_rms_lineas_inicial_mm = sqrt(sum(mindist.^2)/length(mindist))*1000
    figure
    plot3(LineasCT(:,1),LineasCT(:,2),LineasCT(:,3),'b.',D_inicial(1,:),D_inicial(2,:),D_inicial(3,:),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    
%  
    
    opts.Registration = 'Rigid';
    opts.Verbose = true;
    opts.Optimizer = 'lsqnonlin';
    opts.TolP = 1e-7;
    [Points_Moved,MtransFinal]=ICP_finite(LineasCT, D_inicial', opts);

    MtransFinal = MtransFinal*M_inicializacion;


    save('MtransformacionLINEAS.mat','MtransFinal');
    save('MtransformacionLINEAS.txt','MtransFinal','-ascii', '-double')
    %save('C:\Radiance\Output\MtransformacionLINEAS.dat','MtransFinal','-ascii', '-double')
    
    figure
    Dicp = MtransFinal(1:3,1:3) * LineasOpt' + repmat(MtransFinal(1:3,4), 1, length(LineasOpt));
    % FRE
    [~, mindist, ~, ~, ~] = match_bruteForce(Dicp,LineasCT');
    FRE_rms_lineas_mm = sqrt(sum(mindist.^2)/length(mindist))*1000
    
    plot3(LineasCT(:,1),LineasCT(:,2),LineasCT(:,3),'b.',Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Line Based Registration');
    file = 'Line_Based_Registration.tiff';
    print( '-dtiff', file)

    % TRE 
    Dicp2 = MtransFinal(1:3,1:3) * PuntosOpt' + repmat(MtransFinal(1:3,4), 1, length(PuntosOpt));
    TRE_rms_7puntos_mm = sqrt(mean((sqrt(sum((Dicp2-PuntosCT').^2))).^2))*1000
    Dicp2
    PuntosCT'
    ind = find(Dicp2(3,:)<0.5) %Sólo cercanos zona quirúrgica (5)
    TRE_rms_5puntos_mm = sqrt(mean((sqrt(sum((Dicp2(:,ind)-PuntosCT(ind,:)').^2))).^2))*1000
    plot3(LineasCT(:,1),LineasCT(:,2),LineasCT(:,3),'b.',Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
    hold on; plot3(PuntosCT(:,1),PuntosCT(:,2),PuntosCT(:,3),'b.',Dicp2(1,:),Dicp2(2,:),Dicp2(3,:),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Line Based Registration');

    
    
    save('FRE_PRE.mat','FRE_rms_lineas_mm','FRE_rms_lineas_inicial_mm','FRE_rms_puntos_mm');
    


    
end


















