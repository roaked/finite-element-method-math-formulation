function grafico_isolinhas(n_elementos,matriz_dos_nos,centroX,centroY,tensaoxy,n_nos,tipoint)

%função que aprensenta graficamente as várias isolinhas

X = unique(centroX);                  %regista os valores únicos da coordenada x do centro de cada elemento
Y = unique(centroY);                   %regista os valores únicos da coordenada y do centro de cada elemento
numelX = numel(X);                        %numero de elementos de X
numelY = numel(Y);                       %numero de elementos de Y

for i = 1:n_nos                             %ciclo que percorre até ao número de nós
    X(numelX+i) = matriz_dos_nos(i,2);  %adição das coordenadas dos nós a X
    Y(numelY+i) = matriz_dos_nos(i,3);  %adição das coordenadas dos nós a Y
end

X = unique(X);                                      
Y = unique(Y);
[Xmesh,Ymesh]=meshgrid(X,Y);       %criação de uma matriz a partir dos valores únicos dos centros e nós de x e y
tmod = zeros(size(Xmesh));         %inicialização do array mod com a dimensão de Xmesh a zeros

for i=1:numel(Xmesh)                %ciclo que percorre até ao nº elementos no array Xmesh
    for j=1:n_elementos              %ciclo que percorre até ao nº elementos total
        if centroX(j)==Xmesh(i) && centroY(j)==Ymesh(i)  
            %substitui o valor do módulo na matriz se ambas as coordenadas do 
            %elementos corresponderem às da matriz gerada no meshgrid
            tmod(i)=tensaoxy(j);
        end
    end
end

[l,c] = size(tmod); %criação de uma matriz com as mesmas dimensões de tmod
isolinhas = tmod;   %colunas                                                         
for i = 2:(l-1)    %percorre da segunda linha até ao número de linhas - 1
    for j = 2:(c-1)  %percorre da segunda coluna até ao número de colunas - 1
        if tmod(i,j) == 0 && tmod(i,j-1) ~= 0 && tmod(i,j+1) ~= 0  %se o módulo da tensão de corte for zero e estiver entre duas colunas com valores diferentes de zero
                   isolinhas(i,j) = (tmod(i,j-1) + tmod(i,j+1))/2;  %calcular a média
            
        end
    end
end
tmod = isolinhas;   %linhas
for i = 2:(l-1)
    for j = 2:(c-1)
        if tmod(i,j) == 0 && tmod(i-1,j) ~= 0 && tmod(i+1,j) ~= 0  %se o módulo da tensão de corte for zero e estiver entre duas linhas com valores diferentes de zero
                   isolinhas(i,j) = (tmod(i+1,j) + tmod(i-1,j))/2;  %calcular a média
           
        end
    end
end   

figure
hold on
contour3(Xmesh,Ymesh,isolinhas,150);   %representação das isolinhas e respetiva intensidade
colorbar;                              %ver colorbar

if tipoint == 1
    title('Isolinhas de Tensão - Integração analítica');
elseif tipoint == 2
    title('Isolinhas de Tensão - Integração Gauss 2x2');
elseif tipoint == 3
    title('Isolinhas de Tensão - Integração Gauss 2x1');
elseif tipoint == 4
    title('Isolinhas de Tensão - Integração Gauss 1x2');
elseif tipoint == 5
    title('Isolinhas de Tensão - Integração Gauss 1x1');
end

%rotate3d on;
%view(3);

end
