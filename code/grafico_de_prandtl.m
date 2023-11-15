function grafico_de_prandtl(solucao_nodal,n_nos,matriz_dos_nos,tipoint)

%função que representa o valor da função de prandtl

X = unique(matriz_dos_nos(:,2));                %regista os valores únicos da coordenada x de cada nó
Y = unique(matriz_dos_nos(:,3));                 %regista os valores únicos da coordenada y de cada nó
[Xmesh,Ymesh] = meshgrid(X,Y);                    %criação de uma matriz a partir dos valores de x e y
Z = zeros(size(Xmesh));                         %inicialização a zeros de uma matriz com o comprimento de Xmesh
for i=1:numel(Xmesh)                            %percorre até ao número de elementos do Xmesh
    for j=1:n_nos                                %percorre até ao número de nós
        if matriz_dos_nos(j,2)==Xmesh(i) && matriz_dos_nos(j,3)==Ymesh(i)  
            %substitui o valor da solução nodal na matriz se as coordenadas
            %desse nó, corresponderem às da matriz criada
            Z(i)=solucao_nodal(j);
        end
    end
end

figure
hold on
surfc(Xmesh,Ymesh,Z);   %comando que gera a superficie e as isolinhas por baixo desta(usar rotate3d)
colorbar;

if tipoint == 1
    title('Solução Nodal - Integração analítica');
elseif tipoint == 2
    title('Solução Nodal - Integração Gauss 2x2');
elseif tipoint == 3
    title('Solução Nodal - Integração Gauss 2x1');
elseif tipoint == 4
    title('Solução Nodal - Integração Gauss 1x2');
elseif tipoint == 5
    title('Solução Nodal - Integração Gauss 1x1');
end
%view(3);
%rotate3d on;



end

