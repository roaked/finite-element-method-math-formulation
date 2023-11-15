function [solucao_nodal] = Solver(K,F,cfronteira,n_nos)
%funcao que devolve a solucao em cada nó

nos_scf = n_nos-length(cfronteira);%nós sem condiçao de fronteira a 0
Kred = zeros(nos_scf);%inicialização a zeros do Kred
Fred = zeros(nos_scf,1);%inicialização a zeros do Fred

vaux = [];                                           
for p = 1:1:n_nos  %criação de um vetor que contém os índices dos nós em que não exixtem
                    %condições de fronteira
    o = find(cfronteira(:,1)==p,1);
    if isempty(o)
        vaux = [vaux p];
    end
end 


for i = 1:1:length(vaux) %percorre até ao nº de nós que não têm condição de fronteira
    for p = 1:length(vaux) 
        %neste ciclo é criada a matriz de rigidez Kred que corresponde à matriz global
        %já sem as linhas e colunas onde as soluções nodais são nulas
        Kred(i,p) = K(vaux(i),vaux(p)); 
        
    end
end
for z = 1:1:length(vaux) %neste ciclo é executado exatamente o mesmo processo mas                                          
    Fred(z,1) = F(vaux(z),1);  %agora para o vetor de cargas global
end                                            
psis = (Kred^-1)*Fred;  %calcula da solução através da inversa da matriz global
solucao_nodal = zeros(n_nos,1);
for z = 1:1:length(vaux)
    solucao_nodal(vaux(z)) = psis(z); %criação e apresentação do vetor com a solução total 
                                      %(incluindo os nós em que esta é nula)
end


end

