function mesh_display(n_nos, n_elementos, matriz_dos_nos, matriz_de_incidencias, a, b)
% Function to display the mesh from the text file and number the nodes

figure
for z = 1:n_elementos % Iterates through all elements
    rectangle('Position',[matriz_dos_nos(matriz_de_incidencias(z,1),2), matriz_dos_nos(matriz_de_incidencias(z,1),3), a(z), b(z)])
    % Draws a rectangle for each element
    hold on
end

for t = 1:n_nos % Iterates through all nodes
    text(matriz_dos_nos(t,2), matriz_dos_nos(t,3), num2str(t));
    % Labels the nodes at their positions
end

centroX = zeros(n_elementos,1); % Initializes a matrix with dimensions n_elementos rows x 1 column filled with zeros
centroY = zeros(n_elementos,1); % Initializes a matrix with dimensions n_elementos rows x 1 column filled with zeros

for j = 1:n_elementos % Iterates through all elements
    centroX(j) = matriz_dos_nos(matriz_de_incidencias(j,2),2) - (a(j))/2; % Calculates the center in X for each element
    centroY(j) = matriz_dos_nos(matriz_de_incidencias(j,4),3) - (b(j))/2; % Calculates the center in Y for each element
    text(centroX(j), centroY(j), num2str(j), 'Color', 'r'); % Labels the center (x,y) of each element
end

title('Mesh with Nodes and Numbered Elements');
end
    
