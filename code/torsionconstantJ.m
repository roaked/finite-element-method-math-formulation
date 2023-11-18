function [Je, J] = torsionconstantJ(solucao_nodal, a, b, n_elementos, matriz_de_incidencias )
% Calculates contributions of each element for Je and computes the torsion constant J

J = 0; % Initialize total torsion constant J
for i = 1:n_elementos % Loop through all elements
    % Calculate contribution Je for each element using the nodal solution
    Je(i) = 1/2 * a(i) * b(i) * (solucao_nodal(matriz_de_incidencias(i, 1)) + ...
        solucao_nodal(matriz_de_incidencias(i, 2)) + solucao_nodal(matriz_de_incidencias(i, 3)) + ...
        solucao_nodal(matriz_de_incidencias(i, 4)));

    J = J + Je(i); % Accumulate contribution to the total torsion constant J
end

end