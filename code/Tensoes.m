function [centro_max,centro_min,tensao_max,tensao_min,tensaoxy,tensaoxz,tensaoyz] = Tensoes(n_elementos, matriz_dos_nos, matriz_de_incidencias,a,b,J,solucao_nodal)
%funcao que calcula a intensidade das tensoes de corte existentes e
%localiza a posiçao da tensao máxima e minima

tensaoxz = zeros(n_elementos,1); %inicialização a zeros de um array com n_elementos 
tensaoxy = zeros(n_elementos,1); %inicialização a zeros de um array com n_elementos
tensaoyz = zeros(n_elementos,1); %inicialização a zeros de um array com n_elementos

for i = 1:n_elementos %percorre até ao numero de elementos
    
    x = a(i)/2; %coordenadas do centro
    y = b(i)/2;
    df1y = (1-x/a(i))*(-1/b(i));  %definição das derivadas da função de                                     
    df2y = (-x/(a(i)*b(i)));      %forma para somar no vetor
    df3y = x/(a(i)*b(i));
    df4y = (1-x/a(i))*1/b(i);
    
    df1x = (1-y/b(i))*(-1/a(i));
    df2x = (1-y/b(i))*(1/a(i));
    df3x = y/(a(i)*b(i));
    df4x = -y/(a(i)*b(i));
    
    %calculo das tensoes a partir das formulas teóricas (ver relatório)
    
    tensaoxz(i) = (1/J)*(solucao_nodal(matriz_de_incidencias(i,1))*df1y...
    + solucao_nodal(matriz_de_incidencias(i,2))*df2y + solucao_nodal(matriz_de_incidencias(i,3))*df3y...
    + solucao_nodal(matriz_de_incidencias(i,4))*df4y);

    tensaoyz(i) = (-1/J)*(solucao_nodal(matriz_de_incidencias(i,1))*df1x...
    + solucao_nodal(matriz_de_incidencias(i,2))*df2x + solucao_nodal(matriz_de_incidencias(i,3))*df3x...
    + solucao_nodal(matriz_de_incidencias(i,4))*df4x);
    
    %determinação dos módulos de tensão obtido pela soma das duas tensões
    tensaoxy(i) = (sqrt((tensaoxz(i))^2 + (tensaoyz(i))^2));
end


tensao_max = max(tensaoxy);  %cálculo da tensão máxima
tensao_min = min(tensaoxy);  %cálculo da tensão minima

for j = 1:n_elementos %percorre até nº elementos
    if tensaoxy(j) == tensao_max
        emax = j; %obtenção do numero do elemento onde a tensão é máxima
    end
    if tensaoxy(j) == tensao_min
        emin = j;  %obtenção do numero do elemento onde a tensão é minima
    end
end

%cálculo do centro do elemento onde existe a tensão máxima e mínima
centro_max(1) = matriz_dos_nos(matriz_de_incidencias(emax,2),2)-(a(emax))/2;              %obtenção das coordenadas do centro geométrico do elemento que contém a tensão máxima
centro_max(2) = matriz_dos_nos(matriz_de_incidencias(emax,4),3)-(b(emax))/2;
centro_min(1) = matriz_dos_nos(matriz_de_incidencias(emin,2),2)-(a(emin))/2;              %obtenção das coordenadas do centro geométrico do elemento que contém a tensão minima
centro_min(2) = matriz_dos_nos(matriz_de_incidencias(emin,4),3)-(b(emin))/2;

end
