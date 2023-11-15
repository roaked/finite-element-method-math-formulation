%Projeto Mecânica Computacional 2017/18
%Torção de barras prismáticas
%Grupo 10
%Aluno Nº80998  Nome: Pedro Miguel Menezes Ramalho
%Aluno Nº83403  Nome: João Domingues Alves Cantante Pires
%Aluno Nº85183  Nome: Ricardo Miguel Diogo de Oliveira Chin


clc


fprintf('\nMecânica Computacional 2017/18\n');
fprintf('Este programa resolve problemas de torção de barras prismáticas.\n');
nome = input('Introduza o nome do ficheiro de dados ("nome.txt"): \n','s');


[n_nos,matriz_dos_nos,n_elementos,matriz_de_incidencias,n_propriedades,...
    propriedades,n_carregamentos,carregamentos,n_cfront,cfronteira,n_pontual,pontual,...
    n_fluxofront,fluxofront,n_convec,convec,a,b,nome,matriz_aux] = LeDados(nome);
%chama a função LeDados


warning=0;

if n_pontual ~= 0 %caso existam cargas pontuais
        fprintf('\nAtenção! O ficheiro de dados contém fontes/cargas pontuais impostas!\n');
        warning = 1;
end
if n_fluxofront ~= 0  %caso exista fluxo na fronteira 
        fprintf('\nAtenção! O ficheiro de dados contém fluxo imposto na fronteira!\n');
        warning = 1;
end
if n_convec ~=0 %caso exista convecção natural imposta
        fprintf('\nAtenção! O ficheiro de dados contém convecção natural imposta!\n');
        warning = 1;
end
if warning == 1
        fprintf('Existem condições de fronteira inválidas para o problema da torção!\n');
        fprintf('Condições de fronteira inválidas serão ignoradas pelo programa.\n');
        fprintf('Sugere-se terminar o programa e alterar os valores.\n');
end

for i = 1:n_carregamentos %percorre até ao nº de carregamentos
    if carregamentos(i,2) ~=  2 %caso carregamento diferente de 2
        fprintf('\nAtenção! Os carregamentos distribuídos não são adequados para o problema de torção!\n');
        fprintf('Sugere-se terminar o programa e alterar os valores das cargas para 2.\n');
    end    
end
for i = 1:n_cfront %percorre até ao nº nós com condiçao fronteira
    if cfronteira(i,2) ~=  0 %caso condiçao de fronteira diferente de 0
        fprintf('\nAtenção! As condições de fronteira são inválidas para o problema da torção!\n');
        fprintf('Os psis impostos na fronteira têm de ser iguais a zero.\n')
        fprintf('Sugere-se terminar o programa e alterar os valores.\n');
    end    
end
if propriedades(1,2) ~= 1 %caso propriedade k não for 1
    fprintf('\nAtenção! A propriedade do material não é adequada para o problema de torção!\n');
    fprintf('Sugere-se terminar o programa e alterar os valor da propriedade para 1.\n');
end
if n_carregamentos ~= n_elementos %caso o nº de carregamentos não igualar o nº elementos
    fprintf('\nAtenção! Existem elementos sem carregamentos distribuídos aplicados!\n');
    fprintf('Sugere-se terminar o programa e alterar o ficheiro de dados.\n');
end

grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
%plot da malha com nº nós e nº elementos
hold on

selec = 0;
resolvido = 0;

while(selec==0) %espera que o utilizador introduza uma opção
    fprintf('\nEscolher uma opção, começando pelo tipo de integração:\n');
    fprintf('1: Integração analítica\n');
    fprintf('2: Integração numérica de Gauss 2x2\n');
    fprintf('3: Integração reduzida de Gauss 2x1\n');
    fprintf('4: Integração reduzida de Gauss 1x2\n');
    fprintf('5: Integração reduzida de Gauss 1x1\n');
    fprintf('6: Obter gráficos solução Prandtl, tensões de corte e isolinhas de tensão\n');
    fprintf('7: Obter gráfico da malha novamente\n');
    fprintf('0: Sair do programa\n');
    opcao = input('');
    valido=0;  
   
    switch(opcao)
        case{0,1,2,3,4,5,6,7}
            valido=1;
    end
    if(valido==0)
        fprintf('\nErro! Escolha inválida!\n');
    end

switch(opcao) %opçoes de integraçao para escolha do utilizador
    case{1,2,3,4,5}
        if opcao==1
           [K] = KAnalitico(matriz_de_incidencias,n_nos,a,b,propriedades);          
        else
           [K] = KGauss(opcao, matriz_de_incidencias, n_nos, a, b, propriedades); 
        end
        tipoint = opcao;
        
        [F] = Forcas(matriz_de_incidencias,n_nos,a,b,carregamentos );
        
        [solucao_nodal] = Solver(K,F,cfronteira,n_nos);
        
        [Je, J] = rigidezJ (solucao_nodal,a,b,n_elementos,matriz_de_incidencias);
        
        [centro_max,centro_min,tensao_max,tensao_min,tensaoxy,tensaoxz,tensaoyz] = Tensoes(n_elementos, matriz_dos_nos, matriz_de_incidencias,a,b,J,solucao_nodal);
        
        resolvido = 1;
        fprintf('\nIntegração concluída. Escolha a próxima opção:\n');
        
    case{6} %apresenta os gráficos após escolhido o tipo de integração
        if resolvido==0
            fprintf('\nErro! Ainda não foi executado qualquer tipo de integração!\n');
            fprintf('Escolha um tipo de integração (1,2,3,4 ou 5) primeiro.\n');
        else
           
            grafico_de_prandtl(solucao_nodal,n_nos,matriz_dos_nos,tipoint)
            hold on
                
            [centroX, centroY] = grafico_tensao_c(a,b,matriz_de_incidencias,matriz_dos_nos,n_elementos,tensaoxz,tensaoyz,tipoint);
            hold on
                
            grafico_isolinhas(n_elementos,matriz_dos_nos,centroX,centroY,tensaoxy,n_nos,tipoint)
            hold on
            
            fprintf('\nGráficos obtidos. Escolha a próxima opção:\n');    
        end
        
    case{7} %volta a apresentar o gráfico da malha caso o utilizador queira
        figure
        grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
        hold on
        
        fprintf('\nGráfico obtido. Escolha a próxima opção:\n');
        
    case{0} %opçao para terminar o programa
        selec=1;
        fprintf('\n\nPrograma terminado.\n');          
end



end

aux1(matriz_aux,n_elementos,tensaoxz,tensaoyz,tensaoxy,tensao_max,tensao_min,centro_max,J,centro_min,centroX,centroY)

clear i selec valido resolvido warning matriz_aux;


       
