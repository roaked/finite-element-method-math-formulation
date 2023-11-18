function [F] = Loads(matriz_de_incidencias, n_nos, a, b, carregamentos)
% Rectangle: (important)
% Nodes:
% 4 3
% 1 2

f = carregamentos(:, 2);        % Stores the loading intensities for each element
F = zeros(n_nos, 1);            % Initializes a matrix with n_nos rows filled with zeros
fe = zeros(4, 1);               % Initializes a matrix with 4 rows filled with zeros

for i = 1:1:size(matriz_de_incidencias, 1) % Iterates through the elements
    c = matriz_de_incidencias(i, 1:4);     % Nodes associated with the current element
    c1 = c(1, 1);  % Node #1 of the current element
    c2 = c(1, 2);  % Node #2 of the current element 
    c3 = c(1, 3);  % Node #3 of the current element
    c4 = c(1, 4);  % Node #4 of the current element
    
    % Elemental load vector
    fe(c1) = f(i) * a(i) * b(i) / 4;
    fe(c2) = f(i) * a(i) * b(i) / 4;
    fe(c3) = f(i) * a(i) * b(i) / 4;
    fe(c4) = f(i) * a(i) * b(i) / 4;
    
    % Assembling the elemental load vector into the global load vector
    for o = [c1, c2, c3, c4]
        F(o) = F(o) + fe(o); 
    end
end
    