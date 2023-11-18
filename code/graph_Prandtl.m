function grafico_de_prandtl(solucao_nodal,n_nos,matriz_dos_nos,tipoint)
% Function to represent the Prandtl function value

X = unique(matriz_dos_nos(:,2));          % Registers the unique x-coordinate values of each node
Y = unique(matriz_dos_nos(:,3));          % Registers the unique y-coordinate values of each node
[Xmesh, Ymesh] = meshgrid(X, Y);         % Creates a matrix from the x and y values
Z = zeros(size(Xmesh));                  % Initializes a matrix with the length of Xmesh to zeros


for i = 1:numel(Xmesh)                   % Iterates up to the number of elements in Xmesh
    for j = 1:n_nos                      % Iterates up to the number of nodes
        if matriz_dos_nos(j,2) == Xmesh(i) && matriz_dos_nos(j,3) == Ymesh(i)  
            % Replaces the value of the nodal solution in the matrix if the coordinates
            % of that node match those in the created matrix
            Z(i) = solucao_nodal(j);
        end
    end
end

figure
hold on
surfc(Xmesh, Ymesh, Z);   % Generates the surface and contour lines below it (use rotate3d)
colorbar;

if tipoint == 1
    title('Nodal Solution - Analytical Integration');
elseif tipoint == 2
    title('Nodal Solution - Gauss Integration 2x2');
elseif tipoint == 3
    title('Nodal Solution - Gauss Integration 2x1');
elseif tipoint == 4
    title('Nodal Solution - Gauss Integration 1x2');
elseif tipoint == 5
    title('Nodal Solution - Gauss Integration 1x1');
end
%view(3);
%rotate3d on;
end
