function [centroX, centroY] = grafico_tensao_c(a,b,matriz_de_incidencias,matriz_dos_nos,n_elementos,tensaoxz,tensaoyz,tipoint)

%função que permite visualizar o gráfico com os vetores das tensões de corte
%e a respetiva localização do centro de cada elemento

centroX = zeros(n_elementos,1);         %inicilização a zero do array centroX
centroY = zeros(n_elementos,1);         %inicilização a zero do array centroY
figure

%o ciclo seguinte percorre vários elementos até ao último
%e vai unindo os vários nós (4) que estão associados a um dado elemento z

for z = 1:n_elementos   %este ciclo percorre vários elementos até ao último e representa
                        %um retângulo com os vários nós (4) que estão associados a um dado elemento z                                                   
        
        rectangle('Position',[matriz_dos_nos(matriz_de_incidencias(z,1),2),...
        matriz_dos_nos(matriz_de_incidencias(z,1),3), a(z), b(z)]);
        hold on    
end

for j = 1:n_elementos   %determinação do centro de coordenadas (x,y) para 
                        %cada elemento j, até ao nº máximo de elementos (n_elementos)
                        
    centroX(j) = matriz_dos_nos(matriz_de_incidencias(j,2),2)-(a(j))/2;
    centroY(j) = matriz_dos_nos(matriz_de_incidencias(j,4),3)-(b(j))/2;
   
end

%representação gráfica das direçoes e intensidades das tensões de corte
%partindo do centro do elemento i
quiver(centroX,centroY,tensaoxz,tensaoyz)

%dependendo do tipo de integração escolhida no MainMC, o display
%da figura será diferente 

if tipoint == 1   
    title('Tensões de corte - Integração analítica');
elseif tipoint == 2
    title('Tensões de corte - Integração Gauss 2x2');
elseif tipoint == 3
    title('Tensões de corte - Integração Gauss 2x1');
elseif tipoint == 4
    title('Tensões de corte - Integração Gauss 1x2');
elseif tipoint == 5
    title('Tensões de corte - Integração Gauss 1x1');
end

end 
 
