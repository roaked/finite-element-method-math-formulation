function [Je, J] = rigidezJ (solucao_nodal, a, b, n_elementos, matriz_de_incidencias )

%função que devolve como variáveis de saída as contribuições de cada elemento para o
%Je e que calcula a constante de torção J do material
J = 0;
for i = 1:n_elementos %percorre até o numero de elementos
    Je(i) = 1/2*a(i)*b(i)*(solucao_nodal(matriz_de_incidencias(i,1)) + solucao_nodal(matriz_de_incidencias(i,2))...
    + solucao_nodal(matriz_de_incidencias(i,3)) + solucao_nodal(matriz_de_incidencias(i,4)));       
    %calculo da contribuição Je correspondente a cada elemento
    
    J = J + Je(i);  %obtenção do valor de J total
end

end
