function [K] = KGauss(opcao, matriz_de_incidencias, n_nos, a, b, propriedades)
%função  que calcula a matriz de rigidez globais para tipo de integração
%númerica de gauss 
%Retangulo:
% nós:
% 4 3
% 1 2

K = zeros(n_nos); %inicialização a zeros com o comprimento igual ao nº de nós
k = propriedades(1,2);  %k=1

if opcao == 2
%Integral de Gauss 2x2
w=1;    

dfix1 = zeros(1,n_nos);%inicialização a zeros
dfix2 = zeros(1,n_nos);%inicialização a zeros
dfiy1 = zeros(1,n_nos);%inicialização a zeros
dfiy2 = zeros(1,n_nos);%inicialização a zeros

for i = 1:1:size(matriz_de_incidencias) %percorre até ao nº elementos
    x1 = a(i)/2*(1-sqrt(1/3));
    x2 = a(i)/2*(1+sqrt(1/3));
    y1 = b(i)/2*(1-sqrt(1/3));
    y2 = b(i)/2*(1+sqrt(1/3));
    c = matriz_de_incidencias(i,1:4); %guarda os valores dos nós associados
                                       %ao elementos i
    c1 = c(1,1);%nó #1 do elemento i
    c2 = c(1,2);%nó #2 do elemento i
    c3 = c(1,3);%nó #3 do elemento i
    c4 = c(1,4);%nó #4 do elemento i
    
    %definição das derivadas da função de forma
    dfix1(c1) = -1/a(i)*(1-y1/b(i));
    dfiy1(c1) = -1/b(i)*(1-x1/a(i));
    dfix1(c2) = 1/a(i)*(1-y1/b(i));
    dfiy1(c2) = -1/b(i)*(x1/a(i));
    dfix1(c3) = 1/a(i)*(y1/b(i));
    dfiy1(c3) = 1/b(i)*(x1/a(i));
    dfix1(c4) = -1/a(i)*(y1/b(i));
    dfiy1(c4) = 1/b(i)*(1-x1/a(i));
        
    dfix2(c1) = -1/a(i)*(1-y2/b(i));
    dfiy2(c1) = -1/b(i)*(1-x2/a(i));
    dfix2(c2) = 1/a(i)*(1-y2/b(i));
    dfiy2(c2) = -1/b(i)*(x2/a(i));
    dfix2(c3) = 1/a(i)*(y2/b(i));
    dfiy2(c3) = 1/b(i)*(x2/a(i));
    dfix2(c4) = -1/a(i)*(y2/b(i));
    dfiy2(c4) = 1/b(i)*(1-x2/a(i));
    
     %construção da matriz K com a transformação de coordenadas e sucessiva
     %assemblagem
    for o = [c1,c2,c3,c4]  
        for j = [c1,c2,c3,c4]
            K(o,j) = K(o,j) + ((dfix1(o)*dfix1(j)+dfiy1(o)*dfiy1(j))... 
            + (dfix1(o)*dfix1(j)+dfiy2(o)*dfiy2(j)) + (dfix2(o)*dfix2(j)+dfiy1(o)*dfiy1(j))...
            + (dfix2(o)*dfix2(j)+dfiy2(o)*dfiy2(j))) *k*w*(a(i)*b(i)/4); 
        end
    end
end
    

elseif opcao == 3
%Integral de Gauss 2x1
w1=2;
w2=2;
dfix = zeros(1,n_nos);
dfiy1 = zeros(1,n_nos);
dfiy2 = zeros(1,n_nos);

for i = 1:1:size(matriz_de_incidencias)
    x1 = a(i)/2*(1-sqrt(1/3));
    x2 = a(i)/2*(1+sqrt(1/3));
    y = b(i)/2;
    c = matriz_de_incidencias(i,1:4);
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);
    
    dfix(c1) = -1/a(i)*(1-y/b(i));
    dfiy1(c1) = -1/b(i)*(1-x1/a(i));
    dfix(c2) = 1/a(i)*(1-y/b(i));
    dfiy1(c2) = -1/b(i)*(x1/a(i));
    dfix(c3) = 1/a(i)*(y/b(i));
    dfiy1(c3) = 1/b(i)*(x1/a(i));
    dfix(c4) = -1/a(i)*(y/b(i));
    dfiy1(c4) = 1/b(i)*(1-x1/a(i));
   
        
    dfiy2(c1) = -1/b(i)*(1-x2/a(i));
    dfiy2(c2) = -1/b(i)*(x2/a(i));
    dfiy2(c3) = 1/b(i)*(x2/a(i));
    dfiy2(c4) = 1/b(i)*(1-x2/a(i));
   
    
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            K(o,j) = K(o,j) + ((((dfix(o)*dfix(j))+(dfiy1(o)*dfiy1(j))) * w1)... 
            + (((dfix(o)*dfix(j))+(dfiy2(o)*dfiy2(j))) * w2)) *k*(a(i)*b(i)/4); 
        end
    end
end
 

elseif opcao == 4
%Integral de Gauss 1x2    
w1=2;
w2=2;

dfix1 = zeros(1,n_nos);
dfix2 = zeros(1,n_nos);
dfiy = zeros(1,n_nos);

for i = 1:1:size(matriz_de_incidencias)
    x = a(i)/2;
    y1 = b(i)/2*(1-sqrt(1/3));
    y2 = b(i)/2*(1+sqrt(1/3));
    c = matriz_de_incidencias(i,1:4);
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);
    
    dfix1(c1) = -1/a(i)*(1-y1/b(i));
    dfiy(c1) = -1/b(i)*(1-x/a(i));
    dfix1(c2) = 1/a(i)*(1-y1/b(i));
    dfiy(c2) = -1/b(i)*(x/a(i));
    dfix1(c4) = -1/a(i)*(y1/b(i));
    dfiy(c4) = 1/b(i)*(1-x/a(i));
    dfix1(c3) = 1/a(i)*(y1/b(i));
    dfiy(c3) = 1/b(i)*(x/a(i));

    dfix2(c1) = -1/a(i)*(1-y2/b(i));
    dfix2(c2) = 1/a(i)*(1-y2/b(i));
    dfix2(c4) = -1/a(i)*(y2/b(i));
    dfix2(c3) = 1/a(i)*(y2/b(i));
    
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            K(o,j) = K(o,j) + ((((dfix1(o)*dfix1(j))+(dfiy(o)*dfiy(j))) * w1)...
            + (((dfix2(o)*dfix2(j))+(dfiy(o)*dfiy(j))) * w2)) *k*(a(i)*b(i)/4); 
        end
    end
end


elseif opcao == 5
%Integral de Gauss 1x1    
w1 = 4; 

dfix = zeros(1,n_nos);
dfiy = zeros(1,n_nos);

for i = 1:1:size(matriz_de_incidencias)
    x = a(i)/2;
    y = b(i)/2; 
    c = matriz_de_incidencias(i,1:4);
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);
    dfix(c1) = -1/a(i)*(1-y/b(i));
    dfiy(c1) = -1/b(i)*(1-x/a(i));
    dfix(c2) = 1/a(i)*(1-y/b(i));
    dfiy(c2) = -1/b(i)*(x/a(i));
    dfix(c4) = -1/a(i)*(y/b(i));
    dfiy(c4) = 1/b(i)*(1-x/a(i));
    dfix(c3) = 1/a(i)*(y/b(i));
    dfiy(c3) = 1/b(i)*(x/a(i));
        
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            K(o,j) = K(o,j) + ((dfix(o)*dfix(j))+(dfiy(o)*dfiy(j))) * k*(a(i)*b(i)/4*w1);    
        end
    end
end

end


end