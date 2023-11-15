function grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)  %função que apresenta o gráfico com a malha do ficheiro de texto e numera os nós
%função que apresenta o gráfico com a malha do ficheiro de texto e numera os nós

figure    
for z=1:n_elementos             %percorre até ao número total de elementos
    rectangle('Position',[matriz_dos_nos(matriz_de_incidencias(z,1),2), matriz_dos_nos(matriz_de_incidencias(z,1),3), a(z), b(z)])
    %desenha o rectângulo para cada elemento
    hold on    
end
    
for t=1:n_nos                    %percorre até ao número total de nós
    text(matriz_dos_nos(t,2),matriz_dos_nos(t,3),num2str(t));
    %numera os nós na sua posição
end


centroX = zeros(n_elementos,1);                 %inicia a zeros uma matriz com dimensões n_elementos linhas x 1 coluna
centroY = zeros(n_elementos,1);                 %inicia a zeros uma matriz com dimensões n_elementos linhas x 1 coluna

for j = 1:n_elementos                           %percorre até ao número de elementos
    centroX(j) = matriz_dos_nos(matriz_de_incidencias(j,2),2)-(a(j))/2;     %calcula o centro em X de cada elemento
    centroY(j) = matriz_dos_nos(matriz_de_incidencias(j,4),3)-(b(j))/2;  %calcula o centro em Y de cada elemento
    text(centroX(j),centroY(j),num2str(j),'Color','r');                 %numera o centro (x,y) de cada elemento
end


title('Malha com nós e elementos numerados');

end

