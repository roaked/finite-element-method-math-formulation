function [centroX, centroY] = graph_shear_stresses(a,b,matriz_de_incidencias,matriz_dos_nos,n_elementos,tensaoxz,tensaoyz,tipoint)
% This function generates a plot displaying stress vectors and the location
% of the center for each element.

centroX = zeros(n_elementos,1);         % Initializes array centroX to zeros
centroY = zeros(n_elementos,1);         % Initializes array centroY to zeros
figure                                   % Creates a new figure for the plot

% Loops through each element to create rectangles representing the elements
for z = 1:n_elementos
    rectangle('Position',[matriz_dos_nos(matriz_de_incidencias(z,1),2),...
    matriz_dos_nos(matriz_de_incidencias(z,1),3), a(z), b(z)]);
    hold on    
end

% Determines the coordinates of the center for each element
for j = 1:n_elementos
    centroX(j) = matriz_dos_nos(matriz_de_incidencias(j,2),2)-(a(j))/2;
    centroY(j) = matriz_dos_nos(matriz_de_incidencias(j,4),3)-(b(j))/2;
end

% Plots stress vectors starting from the center of each element
quiver(centroX,centroY,tensaoxz,tensaoyz)

% Sets the title of the plot based on the integration type
if tipoint == 1   
    title('Shear Stresses - Analytical Integration');
elseif tipoint == 2
    title('Shear Stresses - Gaussian Integration 2x2');
elseif tipoint == 3
    title('Shear Stresses - Gaussian Integration 2x1');
elseif tipoint == 4
    title('Shear Stresses - Gaussian Integration 1x2');
elseif tipoint == 5
    title('Shear Stresses - Gaussian Integration 1x1');
end

end 
 
