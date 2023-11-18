function [K] = KAnalitico(matriz_de_incidencias, n_nos, a, b, propriedades)
% Square
% Nodes
% 4 3
% 1 2

% Function to compute the global stiffness matrix for the analytical integration method

k = propriedades(1, 2);  % Constant value (k = 1)
K = zeros(n_nos);        % Initializes the global stiffness matrix with zeros

ke = zeros(4);           % Initializes the elemental stiffness matrix with zeros (4x4)

for i = 1:1:size(matriz_de_incidencias, 1) % Iterates through the elements
    c = matriz_de_incidencias(i, 1:4);     % Nodes associated with the current element
    c1 = c(1, 1);  % Node #1 of the current element
    c2 = c(1, 2);  % Node #2 of the current element
    c3 = c(1, 3);  % Node #3 of the current element
    c4 = c(1, 4);  % Node #4 of the current element
    
    % Elemental stiffness matrix calculation
    ke(c1, c1) = k / (6 * a(i) * b(i)) * 2 * (a(i)^2 + b(i)^2);
    ke(c1, c2) = k / (6 * a(i) * b(i)) * (a(i)^2 - 2 * b(i)^2);
    ke(c1, c3) = k / (6 * a(i) * b(i)) * (-1) * (a(i)^2 + b(i)^2);
    ke(c1, c4) = k / (6 * a(i) * b(i)) * (-2 * a(i)^2 + b(i)^2);
    
    ke(c2, c1) = ke(c1, c2);
    ke(c2, c2) = ke(c1, c1);
    ke(c2, c3) = ke(c1, c4);
    ke(c2, c4) = ke(c1, c3);
    
    ke(c3, c1) = ke(c1, c3);
    ke(c3, c2) = ke(c2, c3);
    ke(c3, c3) = ke(c1, c1);
    ke(c3, c4) = ke(c1, c2);
    
    ke(c4, c1) = ke(c1, c4);
    ke(c4, c2) = ke(c2, c4);
    ke(c4, c3) = ke(c3, c4);
    ke(c4, c4) = ke(c1, c1);
    
    % Assembling the elemental stiffness matrix into the global stiffness matrix
    for o = [c1, c2, c3, c4]
        for j = [c1, c2, c3, c4]
            K(o, j) = K(o, j) + ke(o, j);
        end
    end
end
    