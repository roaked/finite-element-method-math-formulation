function [centro_max,centro_min,tensao_max,tensao_min,tensaoxy,tensaoxz,tensaoyz] = Tensoes(n_elementos, matriz_dos_nos, matriz_de_incidencias,a,b,J,solucao_nodal)
% Function to calculate shear stress intensities and locate maximum and minimum stresses


tensaoxz = zeros(n_elementos,1); % Initialization of array XZ for shear stresses
tensaoxy = zeros(n_elementos,1); % Initialization of array XY for shear stresses
tensaoyz = zeros(n_elementos,1); % Initialization of array YZ for shear stresses

for i = 1:n_elementos % Loop through the elements
    
    x = a(i)/2; % Coordinates of the center
    y = b(i)/2;

    % Definition of derivatives of the shape function
    df1y = (1-x/a(i))*(-1/b(i));                                    
    df2y = (-x/(a(i)*b(i)));      
    df3y = x/(a(i)*b(i));
    df4y = (1-x/a(i))*1/b(i);
    
    df1x = (1-y/b(i))*(-1/a(i));
    df2x = (1-y/b(i))*(1/a(i));
    df3x = y/(a(i)*b(i));
    df4x = -y/(a(i)*b(i));
    
    % Calculation of shear stresses using theoretical formulas
    
    tensaoxz(i) = (1/J)*(solucao_nodal(matriz_de_incidencias(i,1))*df1y...
    + solucao_nodal(matriz_de_incidencias(i,2))*df2y + solucao_nodal(matriz_de_incidencias(i,3))*df3y...
    + solucao_nodal(matriz_de_incidencias(i,4))*df4y);

    tensaoyz(i) = (-1/J)*(solucao_nodal(matriz_de_incidencias(i,1))*df1x...
    + solucao_nodal(matriz_de_incidencias(i,2))*df2x + solucao_nodal(matriz_de_incidencias(i,3))*df3x...
    + solucao_nodal(matriz_de_incidencias(i,4))*df4x);
    
    % Calculation of the absolute shear stress
    tensaoxy(i) = (sqrt((tensaoxz(i))^2 + (tensaoyz(i))^2));
end


tensao_max = max(tensaoxy);  % Calculation of maximum shear stress
tensao_min = min(tensaoxy);  % Calculation of minimum shear stress

for j = 1:n_elementos % Loop through the elements
    % Finding the elements with maximum and minimum stresses
    if tensaoxy(j) == tensao_max
        emax = j; % Element number with maximum stress
    end
    if tensaoxy(j) == tensao_min
        emin = j;  % Element number with minimum stress
    end
end

% Calculation of the centers of the elements with maximum and minimum stresses
centro_max(1) = matriz_dos_nos(matriz_de_incidencias(emax,2),2)-(a(emax))/2;              
centro_max(2) = matriz_dos_nos(matriz_de_incidencias(emax,4),3)-(b(emax))/2;
centro_min(1) = matriz_dos_nos(matriz_de_incidencias(emin,2),2)-(a(emin))/2;              
centro_min(2) = matriz_dos_nos(matriz_de_incidencias(emin,4),3)-(b(emin))/2;

end
