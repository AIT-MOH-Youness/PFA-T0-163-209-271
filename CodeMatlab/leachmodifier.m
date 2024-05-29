%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          LEACH Protocol                              %
% Protocoles �conomes en �nergie dans les r�seaux de capteurs sans fil %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;

%%%%%%%%%%%%%%% Param�tres d'�tablissement du r�seau %%%%%%%%%%%%%%%%%%

xm=12;% Dimensions du terrain en m�tres %
ym=7.5;
zm=5;
x=0; % ajout� pour un meilleur affichage des r�sultats avec plot
y=0; % ajout� pour un meilleur affichage des r�sultats avec plot
z=0; % ajout� pour un meilleur affichage des r�sultats avec plot
% Nombre de n�uds sur le terrain %
n=33;
% Nombre de capteurs d'empreintes %
nE=5;
% Nombre de capteurs de bruit %
nB=10;
% Nombre de capteurs de fum�e %
nF=12;
% Nombre de capteurs d'humidit� %
nH=5;
% Nombre de n�uds morts au d�but %
dead_nodes=0;
% Coordonn�es de la station de base(l'emplacement est pr�d�termin� dans cette simulation) %
sinkx=0.5*xm;
sinky=ym;
sinkz=zm;

% Coordonn�es du lecteur RFID%
lRFIDx=xm;
lRFIDy=(5.2/7.5)*ym;
lRFIDz=(0.2)*zm;


%%% Valeurs �nerg�tiques %%%
% �nergie initiale d'un n�ud (en joules) % 
Eo=0.1; % unit�s en Joules
% �nergie requise pour faire fonctionner les circuits (� la fois pour l'�metteur et le r�cepteur) %
Eelec=50*10^(-9); % unit�s in Joules/bit
ETx=50*10^(-9); % unit�s en Joules/bit
ERx=50*10^(-9); % unit�s en Joules/bit
% Types d'amplificateurs de transmission %
%quantit� d'�nergie d�pens�e par l'amplificateur pour transmettre les bits
Eamp=100*10^(-12); % unit�s en Joules/bit/m^3
% �nergie d�agr�gation de donn�es %
EDA=5*10^(-9); % unit�s en Joules/bit
% Taille du paquet de donn�es %
k=4000; % unit�s en bits
% Pourcentage sugg�r� de chef de cluster%
p=0.10; % un 5 pour cent de la quantit� totale de n�uds utilis�s 
%dans le r�seau est propos� pour donner de bons r�sultats
% Nombre de Clusters %
No=p*n; 
% Round d'op�ration %
rnd=0;
% Coeff d'Amplification %
a=3;
% Nombre actuel de n�uds op�rationnels %
operating_nodes=n;
transmissions=0;
bitsRecuParSB=0;
temp_val=0;
flag1stdead=0;

sinkExist=0;
nodesExist=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%% Fin des param�tres %%%%%%%%%%%%%%%%%%%%%%%%%%%%



            %%% Cr�ation du r�seau de capteurs sans fil %%%

% Tracer le RCSF %
for i=1:n
    
    SN(i).id=i;	% L'ID du capteur
    if i > p*n
        SN(i).E=Eo; % niveaux d'�nergie normaux des n�uds (initialement d�finis pour �tre �gaux � "Eo"
    else 
        SN(i).E=Eo*(1+a);  % niveaux d'�nergie des n�uds avanc�s
                        % initialement r�gl� pour �tre �gal � "Eo" avec amplification
    end    
    SN(i).role=0;   % le n�ud agit normalement si la valeur est ��0��
                    % s'il est �lu comme chef de cluster, il obtient la valeur ��1��
    SN(i).cluster=0;%le cluster auquel appartient un n�ud
    SN(i).cond=1;	% Indique l'�tat actuel du n�ud.
                    % lorsque le n�ud est op�rationnel sa valeur est =1 et lorsqu'il est mort =0
    SN(i).rop=0;	% nombre de tours, le n�ud �tait op�rationnel
    SN(i).rleft=0;  % tours restants pour que le n�ud devienne disponible pour l'�lection du chef de cluster
    SN(i).dtch=0;	% distance des n�uds du cluster head du cluster auquel il appartient
    SN(i).dts=0;    % distance des n�uds � l'�vier
    SN(i).tel=0;	% indique combien de fois le n�ud a �t� �lu en tant que chef de cluster
    SN(i).rn=0;     % le n�ud rond a �t� �lu chef du cluster
    SN(i).chid=0;   % ID de n�ud du chef de cluster auquel appartient le n�ud normal "i"
     
end


%----------------------------------------------------------------------%    
%%%%%%%%%%-------------Les Capteurs de Bruit---------------------%%%%%%%%%%%% 

 j=0;
for i=1:2:nB-1
   
    SN(i).x=((3+1.5*(i-j))/12)*xm;	%Coordonn�es sur l'axe X du n�ud du capteur
    SN(i).y=(7/7.5)*ym;	% Coordonn�es sur l'axe Y du n�ud du capteur
    SN(i).z=0.16*zm; % Coordonn�es sur l'axe Z du n�ud du capteur
    
    
    SN(i+1).x=((3+1.5*(i-j))/12)*xm;	
    SN(i+1).y=(6/7.5)*ym;	
    SN(i+1).z=0.16*zm; 
   
    j=j+1;  
   
end


%----------------------------------------------------------------------%    
%%%%%%%%%%--------------------Fum�e---------------------%%%%%%%%%%%% 

 j=0;
for i=1:2:5
    
    SN(nB+i).x=((1.5+3*(i-j))/12)*xm; %Coordonn�es sur l'axe X du n�ud du capteur
    SN(nB+i).y=(2/7.5)*ym;	        % Coordonn�es sur l'axe Y du n�ud du capteur
    SN(nB+i).z=zm;                  % Coordonn�es sur l'axe Z du n�ud du capteur
    
    SN(nB+i+1).x=((1.5+3*(i-j))/12)*xm;	
    SN(nB+i+1).y=(6.5/7.5)*ym;	
    SN(nB+i+1).z=zm;
   
    j=j+1;  
   
end

    SN(nB+7).x=(1/8)*xm;	%Coordonn�es sur l'axe X du n�ud du capteur
    SN(nB+7).y=(2/15)*ym;	%Coordonn�es sur l'axe Y du n�ud du capteur
    SN(nB+7).z=zm;          %Coordonn�es sur l'axe Z du n�ud du capteur
    
    SN(nB+8).x=(1/8)*xm;	
    SN(nB+8).y=(6/15)*ym;	
    SN(nB+8).z=zm;          
    
    SN(nB+9).x=(1/12)*xm;	
    SN(nB+9).y=(10/15)*ym;	
    SN(nB+9).z=zm;          
    
    SN(nB+10).x=(1/6)*xm;	
    SN(nB+10).y=(13/15)*ym;	
    SN(nB+10).z=zm;         
    
    SN(nB+11).x=(7/12)*xm;	
    SN(nB+11).y=(10/15)*ym;	
    SN(nB+11).z=zm;        
    
    SN(nB+12).x=(11/12)*xm;	
    SN(nB+12).y=(10/15)*ym;
    SN(nB+12).z=zm;          
    
%----------------------------------------------------------------------%   
%%%%%%%%----------------Les capteurs d'humidit�-----------------%%%%%%%%%%%%    
    
    
    SN(nB+nF+1).x=(4.3/12)*xm;	
    SN(nB+nF+1).y=(1/15)*ym;	
    SN(nB+nF+1).z=0.5*zm;       
    
     SN(nB+nF+2).x=(5.9/12)*xm;	
    SN(nB+nF+2).y=(7/15)*ym;	
    SN(nB+nF+2).z=0.5*zm;      
    
     SN(nB+nF+3).x=(7.5/12)*xm;	
    SN(nB+nF+3).y=(1/15)*ym;	
    SN(nB+nF+3).z=0.5*zm;       
   
     SN(nB+nF+4).x=(9.2/12)*xm;	
    SN(nB+nF+4).y=(7/15)*ym;	
    SN(nB+nF+4).z=0.5*zm;      
    
     SN(nB+nF+5).x=(10.7/12)*xm;	
    SN(nB+nF+5).y=(1/15)*ym;	
    SN(nB+nF+5).z=0.5*zm;      
    
    
%----------------------------------------------------------------------%    
%%%%%%%%%%--------------Les capteurs d'Empreinte---------------%%%%%%%%%%%%    
    
    
    SN(nB+nF+nH+1).x=(3.2/12)*xm;	
    SN(nB+nF+nH+1).y=(0.6)*ym;	
    SN(nB+nF+nH+1).z=(0.2)*zm;	
    
     SN(nB+nF+nH+2).x=(3.2/12)*xm;	
    SN(nB+nF+nH+2).y=(10.4/15)*ym;	
    SN(nB+nF+nH+2).z=(0.2)*zm;	

    SN(nB+nF+nH+3).y=(1/15)*ym;	
    SN(nB+nF+nH+3).z=(0.2)*zm;	
     SN(nB+nF+nH+4).x=(3/12)*xm;	
    SN(nB+nF+nH+4).y=(5/15)*ym;	
    SN(nB+nF+nH+4).z=(0.2)*zm;	

     SN(nB+nF+nH+5).x=xm;	
    SN(nB+nF+nH+5).y=(10/15)*ym;	  
    SN(nB+nF+nH+5).z=(0.2)*zm;	

 %----------------------------------------------------------------------%    
%%%%%%%%%%--------------------Le lecteur RFID ---------------------%%%%%%%%%%%%    
    
    
    SN(n).x=lRFIDx;
    SN(n).y=lRFIDy;	
    SN(n).z=lRFIDz;	

    
    
%%%%%%%%%%--------------Set-Up Phase---------------%%%%%%%%%%%%    
    


while operating_nodes>0
        
    %Affiche le tour en cours%     
    rnd     

	% Valeur de seuil %
	t=(p/(1-p*(mod(rnd,1/p))));
    
    % Valeur de r��lection %
    tleft=mod(rnd,1/p);
 
	% R�initialisation du nombre pr�c�dent de chefs de cluster dans le r�seau %
	CLheads=0;
    
    % R�initialisation de la quantit� d'�nergie pr�c�dente consomm�e dans le r�seau lors du cycle pr�c�dent%
    energy=0;
 
        
        
% %---------�lection des chefs de cluster--------------%
        delete(findobj(gca, 'Type', 'scatter', 'MarkerFaceColor', 'r'));
        for i=1:n
            SN(i).cluster=0;    %r�initialisation du cluster auquel appartient le n�ud
            SN(i).role=0;       %r�initialisation du r�le du n�ud
            SN(i).chid=0;       % r�initialisation de l'identifiant du chef de cluster
            if SN(i).rleft>0
               SN(i).rleft=SN(i).rleft-1;
            end
            if (SN(i).E>0) && (SN(i).rleft==0)
                generate=rand;	
                    if generate< t
                    SN(i).role=1;	% attribue le r�le de n�ud d'un chef de cluster
                    SN(i).rn=rnd;	% Attribue le tour auquel �tait le chef du cluster
                                      % �lu � la table de donn�es
                    SN(i).tel=SN(i).tel + 1;   
                    SN(i).rleft=1/p-tleft;    %Tours pour lesquels le n�ud ne pourra pas devenir un CH
                    SN(i).dts=sqrt((sinkx-SN(i).x)^2 + (sinky-SN(i).y)^2 +(sinkz-SN(i).z)^2); 
                    % calcule la distance entre le noeud et la SB
                    CLheads=CLheads+1;	% somme des chefs de cluster qui ont �t� �lus
                    SN(i).cluster=CLheads; % cluster dont le n�ud a �t� �lu chef de cluster
                    CL(CLheads).x=SN(i).x; % Coordonn�es sur l'axe X du chef de cluster �lu
                    CL(CLheads).y=SN(i).y; % Coordonn�es sur l'axe Y du chef de cluster �lu
                    CL(CLheads).z=SN(i).z; % Coordonn�es sur l'axe W du chef de cluster �lu
                    CL(CLheads).id=i; % Attribue l'ID de n�ud du nouvel �lu CH vers un tableau
                    
                    end
                    
            end   
           
           
        end
        
        
	% Correction de la taille du tableau "CL" %
	CL=CL(1:CLheads);
  
    
% Regrouper les n�uds en clusters et calculer la distance entre le n�ud et le chef de cluster %
     
       for i=1:n
        if  (SN(i).role==0) && (SN(i).E>0) && (CLheads>0) % if node is normal
            for j=1:CLheads
            d(j)=sqrt((CL(j).x-SN(i).x)^2 + (CL(j).y-SN(i).y)^2 + (CL(j).z-SN(i).z)^2 );
            %nous calculons la distance 'd' entre le n�ud du capteur qui est
            %qui transmet et la t�te de cluster qui re�oit avec l'�quation suivante
            %d=sqrt((x2-x1)^2 + (y2-y1)^2) o� x2 et y2 les coordonn�es de
            %le chef de cluster et x1 et y1 les coordonn�es du n�ud �metteur
            end
        d=d(1:CLheads); % correction de la taille du tableau "d"
        [M,I]=min(d(:)); % trouve la distance minimale du n�ud � CH
        [Row, Col] = ind2sub(size(d),I); % affiche �galement le num�ro de cluster auquel ce n�ud appartient
        SN(i).cluster=Col; % attribue un n�ud au cluster
        SN(i).dtch= d(Col); % attribue la distance du n�ud � CH
        SN(i).chid=CL(Col).id;
        end
       end
       
          
       
              %%%%%% --------------- Phase Steady-State ------------- %%%%%%
                      
  
% Dissipation d'�nergie pour les n�uds normaux%
    
    for i=1:n
       if (SN(i).cond==1) && (SN(i).role==0) && (CLheads>0)
       	if SN(i).E>0
            ETx= Eelec*k + Eamp * k * SN(i).dtch^2;
            SN(i).E=SN(i).E - ETx;
            energy=energy+ETx;
            
        % Dissipation pour la t�te de cluster pendant la r�ception
        if SN(SN(i).chid).E>0 && SN(SN(i).chid).cond==1 && SN(SN(i).chid).role==1
            ERx=(Eelec+EDA)*k;
            energy=energy+ERx;
            SN(SN(i).chid).E=SN(SN(i).chid).E - ERx;
             if SN(SN(i).chid).E<=0  % si l'�nergie des t�tes de cluster s'�puise avec la r�ception
                SN(SN(i).chid).cond=0;
                SN(SN(i).chid).rop=rnd;
                dead_nodes=dead_nodes +1;
                operating_nodes= operating_nodes - 1
             end
        end
        end
        
        
        if SN(i).E<=0       % si l'�nergie des n�uds s'�puise avec la transmission
        dead_nodes=dead_nodes +1;
        operating_nodes= operating_nodes - 1
        SN(i).cond=0;
        SN(i).chid=0;
        SN(i).rop=rnd;
        end
        
      end
    end            
    
    
    
%Dissipation d'�nergie pour les n�uds principaux du cluster%
   
   for i=1:n
     if (SN(i).cond==1)  && (SN(i).role==1)
         if SN(i).E>0
            ETx= (Eelec+EDA)*k + Eamp * k * SN(i).dts^2;
            SN(i).E=SN(i).E - ETx;
            energy=energy+ETx;
         end
         if  SN(i).E<=0     % si l'�nergie des CH s'�puise avec la transmission
         dead_nodes=dead_nodes +1;
         operating_nodes = operating_nodes - 1
         SN(i).cond=0;
         SN(i).rop=rnd;
         end
     end
   end

   

  
    if operating_nodes<n && temp_val==0
        temp_val=1;
        flag1stdead=rnd
    end
    
    % Afficher le nombre de chefs de cluster de ce tour %
 
    transmissions=transmissions+1;
    bitsRecuParSB=bitsRecuParSB+(k*operating_nodes);
    if CLheads==0
    bitsRecuParSB=bitsRecuParSB-(k*operating_nodes);    
    transmissions=transmissions-1;
    end
    
 
    %Tour suivant%
    rnd= rnd +1;
    
    tr(transmissions)=operating_nodes;
    op(rnd)=operating_nodes;
    

    if energy>0
    nrg(transmissions)=energy;
    end
    
    
      for i=1:n
       
         hold on;
         grid on;
         
         if sinkExist==0
            scatter3(sinkx,sinky,sinkz,200,...
            's','b', 'filled');
            text(sinkx-2.5, sinky+13, 'Sink');
            sinkExist=1;
         end
         
         if nodesExist<n
               if i<=nB
                   scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'm', 'filled',...
                       'MarkerEdgeColor','black');
                   plot3([SN(i).x, SN(i+1).x], [SN(i).y, SN(i+1).y], [SN(i).z, SN(i+1).z], '--red', 'LineWidth', 0.1); 
               end
               
               if i<=nB+nF && i>nB
                   scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'k', 'filled',...
                   'MarkerEdgeColor','black');
               end 
               
               if i<=nB+nF+nH && i>nB+nF
                   scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'c', 'filled',...
                       'MarkerEdgeColor','black');
               end 
              
               
               
               if i<=nB+nF+nH+nE  && i>nB+nF+nH 
                   scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'g', 'filled',...
                       'MarkerEdgeColor','black');
               end 
               
               if i==n
                   scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'y', 'filled',...
                       'MarkerEdgeColor','black');
               end  
               
               nodesExist=nodesExist+1;
         end
         
         if i~=1
            if CLheads > 0 && SN(i).chid > 0 && SN(i).chid ~= SN(i-1).chid
                  scatter3(SN(SN(i).chid).x,SN(SN(i).chid).y,SN(SN(i).chid).z ,...
                          88,...
                          'MarkerEdgeColor','b',...
                          'MarkerFaceColor','r');
               
            end
         end   
            
            title (sprintf('  Round=%d, Dead nodes=%d, operating nodes=%d  ', rnd , dead_nodes , operating_nodes ));
            xlabel 'distance en (m)';
            ylabel 'distance en (m)';
            zlabel 'distance en (m)';
            xlim([0 xm]);
            ylim([0 ym]);
            zlim([0 zm]);

        
    end
   
    
    
    for i=1:n
       if CLheads > 0 && SN(i).chid > 0
            plot3([SN(i).x, SN(SN(i).chid).x], [SN(i).y, SN(SN(i).chid).y], [SN(i).z, SN(SN(i).chid).z], '--red', 'LineWidth', 0.1); 
            plot3([sinkx, SN(SN(i).chid).x], [sinky, SN(SN(i).chid).y], [sinkz, SN(SN(i).chid).z], '--blue', 'LineWidth', 1);
       end 
    end
   
    
    
    for i=1:n
        if (SN(i).E<=0)
            pause(0.5);
            
            if i<=nB
                scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'white', 'filled',...
                'MarkerEdgeColor','m');
            end
               
            if i<=nB+nF && i>nB
                scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'white', 'filled',...
                'MarkerEdgeColor','k');
            end 
               
            if i<=nB+nF+nH && i>nB+nF
                scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'white', 'filled',...
                'MarkerEdgeColor','c');
            end 
              
            if i<=nB+nF+nH+nE  && i>nB+nF+nH 
                scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'white', 'filled',...
                'MarkerEdgeColor','g');
            end 
               
            if i==n
                scatter3(SN(i).x,SN(i).y,SN(i).z,36, 'white', 'filled',...
                'MarkerEdgeColor','y');
            end
            
         end
    end    
    
  
    pause(1);
    delete(findobj(gcf, 'Type', 'line', 'Color', 'red', 'LineWidth', 0.1));
    delete(findobj(gcf, 'Type', 'line', 'Color', 'blue', 'LineWidth', 1));
    delete(findobj(gca, 'Type', 'rectangle', 'Curvature', [1,1]));    
  
  
    

end


sum=0;
for i=1:flag1stdead
    sum=nrg(i) + sum;
end

temp1=sum/flag1stdead;
temp2=temp1/n;

for i=1:flag1stdead
avg_node(i)=temp2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          LEACH-E Protocol                              %
% Protocoles �conomes en �nergie dans les r�seaux de capteurs sans fil   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Param�tres d'�tablissement du r�seau %%%%%%%%%%%%%%%%%%%%

%%% Zone d'op�ration (m�me zone de LEACH) %%%

% Nombre de n�uds sur le terrain %
n=33;
% Nombre de capteurs d'empreintes%
nE=5;
% Nombre de capteurs de bruit %
nB=10;
% Nombre de capteurs de fum�e %
nF=12;
% Nombre de capteurs d'humidit� %
nH=5;
% Nombre de n�uds morts au d�but %
dead_nodes_e=0;
% Coordonn�es de la SB(l'emplacement est pr�d�termin� dans cette simulation) %
sinkx=0.5*xm;
sinky=ym;

%Coordonn�es du lecteur RFID
lRFIDx=xm;
lRFIDy=(5.2/7.5)*ym;


%%% Les valeurs d �nergies (comme les pr�c�dants)%%%
Eelec_e=50*10^(-9); % unit�s en Joules/bit
ETx_e=50*10^(-9); % unit�s en Joules/bit
ERx_e=50*10^(-9); % unit�s en Joules/bit
Eamp_e=100*10^(-12); % unit�s en Joules/bit/m^2 
EDA=5*10^(-9); % unit�s en Joules/bit
k=4000; % unit�s en Joules/bit
p=0.10; 
No=p*n; 
rnd_e=0;
% Coefficient LEACH-EASA %
kn=5;
operating_nodes_e=n;
transmissions_e=0;
bitsRecuParSB_e=0;
temp_val_e=0;
flag1stdead_e=0;

sinkExist_e=0;
nodesExist_e=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%% fin des Parameteres %%%%%%%%%%%%%%%%%%%%%%%%%%%%



            %%% Creation de ;;; Wireless Sensor Network ;;; %%%

% Plotting the WSN %
for i=1:n
    
    SN_e(i).id=i;	% sensor's ID number
    if i > p*n
        SN_e(i).E=Eo;     % normal nodes energy levels (initially set to be equal to "Eo"
    else 
        SN_e(i).E=Eo*(1+a);     % advanced nodes energy levels (initially set to be equal to "Eo" with amplification
    end 
    SN_e(i).role=0;   % node acts as normal if the value is '0', if elected as a cluster head it  gets the value '1' (initially all nodes are normal)
    SN_e(i).cluster=0;	% the cluster which a node belongs to
    SN_e(i).cond=1;	% States the current condition of the node. when the node is operational its value is =1 and when dead =0
    SN_e(i).rop=0;	% number of rounds node was operational
    SN_e(i).rleft=0;  % rounds left for node to become available for Cluster Head election
    SN_e(i).dtch=0;	% nodes distance from the cluster head of the cluster in which he belongs
    SN_e(i).dts=0;    % nodes distance from the sink
    SN_e(i).tel=0;	% states how many times the node was elected as a Cluster Head
    SN_e(i).rn=0;     % round node got elected as cluster head
    SN_e(i).chid=0;   % node ID of the cluster head which the "i" normal node belongs to
     
    
    
    
end
 


    
    
    for i=1:n
        SN_e(i).x=SN(i).x;
        SN_e(i).y=SN(i).y;
        SN_e(i).z=SN(i).z;
    end    
        
   
                      %%%%%% la phase Set-Up %%%%%% 
                      
             
m=1;
while operating_nodes_e>0
    
    % Round actuel %     
    rnd_e     
	
    
    % Valeur de seuil d'energie %
    Et=0;
    for i=1:n
       if SN_e(i).E>=0
           Et = (Et+SN_e(i).E);
       end 
    end
    Emoy = (Et/operating_nodes_e);
 
 
	% R�initialisation du nombre pr�c�dent de chefs de cluster dans le r�seau %
	CLheads_e=0;
    
    % R�initialisation de la quantit� d'�nergie pr�c�dente consomm�e dans le r�seau lors du cycle pr�c�dent%
    energy_e=0;
 
        
        
% Election des Cluster Heads %
        delete(findobj(gca, 'Type', 'scatter', 'MarkerFaceColor', 'r'));
        for i=1:n
            SN_e(i).cluster=0;    % r�intialiser le cluster de noeud
            SN_e(i).role=0;       % r�intialiser le role de noeud
            SN_e(i).chid=0;       % r�intialiser le ID de CH
            if SN_e(i).rleft>0
               SN_e(i).rleft=SN_e(i).rleft-1;
            end
            if (SN_e(i).E>=Emoy*0.75) && (SN_e(i).rleft==0) 
                generate=rand;
                P(i)=min((SN_e(i).E/Et)*kn,1);
                t_e=(P(i)/(1-P(i)*(mod(rnd_e,1/P(i)))));
                tleft_e=mod(rnd_e,1/p);
                    if generate< t_e
                    SN_e(i).role=1;	% attribuer le role au noeud
                    SN_e(i).rn=rnd_e;	% attribuer le round ou le CH �tait �lu
                    SN_e(i).tel=SN_e(i).tel + 1; 
                    SN_e(i).rleft=1/p-tleft_e;    % rounds pour chaque noeud pourra pas etre un CH
                    SN_e(i).dts=sqrt((sinkx-SN_e(i).x)^2 + (sinky-SN_e(i).y)^2 + (sinkz-SN_e(i).z)^2); % calculates the distance between the sink and the cluster hea
                    CLheads_e=CLheads_e+1;	
                    SN_e(i).cluster=CLheads_e; 
                    CL_e(CLheads_e).x=SN_e(i).x; 
                    CL_e(CLheads_e).y=SN_e(i).y; 
                    CL_e(CLheads_e).z=SN_e(i).z;  
                    CL_e(CLheads_e).id=i; 
                    end
                    
            end   
           
           
        end
        
        
	% Fixing the size of "CL" array %
	CL_e=CL_e(1:CLheads_e);
  
    
% Groupe les noeud en clusteret on calcule les distances pour determiner le CH le plus proche %
     
       for i=1:n
        if  (SN_e(i).role==0) && (SN_e(i).E>0) && (CLheads_e>0) % si noeud est ordinaire
            for j=1:CLheads_e
            d_e(j)=sqrt((CL_e(j).x-SN_e(i).x)^2 + (CL_e(j).y-SN_e(i).y)^2 + (CL_e(j).z-SN_e(i).z)^2 );
            end
        d_e=d_e(1:CLheads_e); 
        [M,I]=min(d_e(:)); 
        [Row, Col] = ind2sub(size(d_e),I); 
        SN_e(i).cluster=Col;
        SN_e(i).dtch= d_e(Col); 
        SN_e(i).chid=CL_e(Col).id;
        end
       end
       
          
       
                           %%%%%%  Phase Steady-State %%%%%%
                      
  
% Consommation pour noeud odinaire %
    
    for i=1:n
       if (SN_e(i).cond==1) && (SN_e(i).role==0) && (CLheads_e>0)
       	if SN_e(i).E>0
            ETx_e= Eelec_e*k + Eamp_e * k * SN_e(i).dtch^2;
            SN_e(i).E=SN_e(i).E - ETx_e;
            energy_e=energy_e+ETx_e;
            
        % Dissipation pour cluster head pendant la reception
        if SN_e(SN_e(i).chid).E>0 && SN_e(SN_e(i).chid).cond==1 && SN_e(SN_e(i).chid).role==1
            ERx_e=(Eelec_e+EDA)*k;
            energy_e=energy_e+ERx_e;
            SN_e(SN_e(i).chid).E=SN_e(SN_e(i).chid).E - ERx_e;
             if SN_e(SN_e(i).chid).E<=0  % si lenergie de CH finit avec transmission
                SN_e(SN_e(i).chid).cond=0;
                SN_e(SN_e(i).chid).rop=rnd_e;
                dead_nodes_e=dead_nodes_e +1;
                operating_nodes_e= operating_nodes_e - 1;
             end
        end
        end
        
        
        if SN_e(i).E<=0       % si lenergie de noeud finit avec transmission
        dead_nodes_e=dead_nodes_e +1;
        operating_nodes_e = operating_nodes_e - 1
        SN_e(i).cond=0;
        SN_e(i).chid=0;
        SN_e(i).rop=rnd_e;
        end
        
      end
    end            
    
    
    
% Consommation pour noeuds CHs %
   
   for i=1:n
     if (SN_e(i).cond==1)  && (SN_e(i).role==1)
         if SN_e(i).E>0
            ETx_e= (Eelec_e+EDA)*k + Eamp_e * k * SN_e(i).dts^2;
            SN_e(i).E=SN_e(i).E - ETx_e;
            energy_e=energy_e+ETx_e;
         end
         if  SN_e(i).E<=0     % si lenergie de noeud CH finit avec transmission
         dead_nodes_e=dead_nodes_e +1;
         operating_nodes_e = operating_nodes_e - 1
         SN_e(i).cond=0;
         SN_e(i).rop=rnd_e;
         end
     end
   end

   

  
    if operating_nodes_e<n && temp_val_e==0
        temp_val_e=1;
        flag1stdead_e=rnd_e
    end
    % Afficher nombre des CHs dans ce round %
    %CLheads;
   
    
    transmissions_e=transmissions_e+1;
    bitsRecuParSB_e=bitsRecuParSB_e+(k*operating_nodes_e);
    if CLheads_e==0
    bitsRecuParSB_e=bitsRecuParSB_e-(k*operating_nodes_e);    
    transmissions_e=transmissions_e-1;
    end
    
 
    %  Round suivant %
    rnd_e= rnd_e +1;
    
    tr_e(transmissions_e)=operating_nodes_e;
    op_e(rnd_e)=operating_nodes_e;
    

    if energy_e>0
        nrg_e(transmissions_e)=energy_e;
    else
        nrg_e(transmissions_e+m)=energy_e;
        m=m+1;
    end
    
    
%          for i=1:n
%        
%          hold on;
%          grid on;
%          
%          if sinkExist==0
%             scatter3(sinkx,sinky,sinkz,200,...
%             's','b', 'filled');
%             text(sinkx-2.5, sinky+13, 'Sink');
%             sinkExist=1;
%          end
%          
%          if nodesExist<n
%                if i<=nB
%                    scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'm', 'filled',...
%                        'MarkerEdgeColor','black');
%                    plot3([SN_e(i).x, SN_e(i+1).x], [SN_e(i).y, SN_e(i+1).y], [SN_e(i).z, SN_e(i+1).z], '--red', 'LineWidth', 0.1); 
%                end
%                
%                if i<=nB+nF && i>nB
%                    scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'k', 'filled',...
%                    'MarkerEdgeColor','black');
%                end 
%                
%                if i<=nB+nF+nH && i>nB+nF
%                    scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'c', 'filled',...
%                        'MarkerEdgeColor','black');
%                end 
%               
%                
%                
%                if i<=nB+nF+nH+nE  && i>nB+nF+nH 
%                    scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'g', 'filled',...
%                        'MarkerEdgeColor','black');
%                end 
%                
%                if i==n
%                    scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'y', 'filled',...
%                        'MarkerEdgeColor','black');
%                end  
%                
%                nodesExist=nodesExist+1;
%          end
%          
%          if i~=1
%             if CLheads > 0 && SN_e(i).chid > 0 && SN_e(i).chid ~= SN_e(i-1).chid
%                   scatter3(SN_e(SN_e(i).chid).x,SN_e(SN_e(i).chid).y,SN_e(SN_e(i).chid).z ,...
%                           88,...
%                           'MarkerEdgeColor','b',...
%                           'MarkerFaceColor','r');
%                
%             end
%          end   
%             
%             title (sprintf('  Round=%d, Dead nodes=%d, operating nodes=%d  ', rnd_e, dead_nodes_e, operating_nodes_e));
%             xlabel 'distance en (m)';
%             ylabel 'distance en (m)';
%             zlabel 'distance en (m)';
%             xlim([0 xm]);
%             ylim([0 ym]);
%             zlim([0 zm]);
% 
%         
%     end
%    
%     
%     
%     for i=1:n
%        if CLheads > 0 && SN_e(i).chid > 0
%             plot3([SN_e(i).x, SN_e(SN_e(i).chid).x], [SN_e(i).y, SN_e(SN_e(i).chid).y], [SN_e(i).z, SN_e(SN_e(i).chid).z], '--red', 'LineWidth', 0.1); 
%             plot3([sinkx, SN_e(SN_e(i).chid).x], [sinky, SN_e(SN_e(i).chid).y], [sinkz, SN_e(SN_e(i).chid).z], '--blue', 'LineWidth', 1);
%        end 
%     end
%    
%     
%     
%     for i=1:n
%         if (SN_e(i).E<=0)
%             pause(0.5);
%             
%             if i<=nB
%                 scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'white', 'filled',...
%                 'MarkerEdgeColor','m');
%             end
%                
%             if i<=nB+nF && i>nB
%                 scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'white', 'filled',...
%                 'MarkerEdgeColor','k');
%             end 
%                
%             if i<=nB+nF+nH && i>nB+nF
%                 scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'white', 'filled',...
%                 'MarkerEdgeColor','c');
%             end 
%               
%             if i<=nB+nF+nH+nE  && i>nB+nF+nH 
%                 scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'white', 'filled',...
%                 'MarkerEdgeColor','g');
%             end 
%                
%             if i==n
%                 scatter3(SN_e(i).x,SN_e(i).y,SN_e(i).z,36, 'white', 'filled',...
%                 'MarkerEdgeColor','y');
%             end
%             
%          end
%     end    
%     
%   
%     pause(1);
%     delete(findobj(gcf, 'Type', 'line', 'Color', 'red', 'LineWidth', 0.1));
%     delete(findobj(gcf, 'Type', 'line', 'Color', 'blue', 'LineWidth', 1));
%     delete(findobj(gca, 'Type', 'rectangle', 'Curvature', [1,1]));    
%   
%     
%     

end


sum_e=0;


for i=1:flag1stdead_e
    sum_e = nrg_e(i) + sum_e;
end

temp1_e=sum_e/flag1stdead_e;
temp2_e=temp1_e/n;

for i=1:flag1stdead_e
avg_node_e(i)=temp2_e;
end



    % R�sultat de simulation "Noeuds op�rationels par round" %
    figure(2)
    hold on;
    plot(1:rnd_e,op_e(1:rnd_e),'-r','Linewidth',2);
    plot(1:rnd,op(1:rnd),'-g','Linewidth',2);
    title ({'LEACH'; 'Noeuds op�rationels par Round';})
    xlabel 'Rounds';
    ylabel 'Noeuds op�rationels';
    legend('LEACH-EASA', 'LEACH');
    
    
    % R�sultat de simulation "Noeuds op�rationels par transmission"  %
    figure(3)
    hold on;
    plot(1:transmissions_e,tr_e(1:transmissions_e),'-r','Linewidth',2);
    plot(1:transmissions,tr(1:transmissions),'-g','Linewidth',2);
    title ({'LEACH'; 'Noeuds op�rationels par transmission';})
    xlabel 'Transmissions';
    ylabel 'Noeuds op�rationels';
    legend('LEACH-EASA', 'LEACH');
    
    
    %  R�sultat de simulation "Energie consomm�e par transmission"  %
    figure(4)
    hold on;
    plot(1:transmissions_e,nrg_e(1:transmissions_e),'-r','Linewidth',2);
    plot(1:transmissions,nrg(1:transmissions),'-g','Linewidth',2);
    title ({'LEACH'; 'Energie consomm�e par transmission';})
    xlabel 'Transmission';
    ylabel 'Energie ( J )';
    % xlim([0 flag1stdead]);
    legend('LEACH-EASA', 'LEACH');
    

    %  R�sultat de simulation "Energie moyenne consomm�e par noeud par transmission"  %
    figure(5)
    hold on;
    plot(1:transmissions_e,avg_node_e(1:transmissions_e),'-r','Linewidth',2);
    plot(1:transmissions,avg_node(1:transmissions),'-g','Linewidth',2);
    title ({'LEACH'; 'Energie moyenne'; 'consomm�e par noeud par transmission';})
    xlabel 'Transmissions';
    ylabel 'Energy ( J )';
    ylim([0 0.002]);
    legend('LEACH-EASA', 'LEACH');
    
    
    % R�sultat de simulation "Ensemble des paquets re�us par la station de base" %
    figure(6)
    hold on;
    plot(1:flag1stdead_e,bitsRecuParSB_e(1:flag1stdead_e),'-r','Linewidth',2);
    plot(1:flag1stdead,bitsRecuParSB(1:flag1stdead),'-g','Linewidth',2);
    title ({'LEACH'; 'Ensemble des paquets'; 're�us par la station de base';})
    xlabel 'Transmissions';
    ylabel 'bits'
    legend('LEACH-EASA', 'LEACH');
    
    