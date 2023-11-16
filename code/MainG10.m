%
%
%Ricardo Chin
%
%
%

clc

fprintf('\nFormulating a Finite Element Analysis Model\n');
fprintf('This program solves torsion problems of prismatic bars.\n');
nome = input('Enter the data file name ("nome.txt"): \n','s');


[n_nos,matriz_dos_nos,n_elementos,matriz_de_incidencias,n_propriedades,...
    propriedades,n_carregamentos,carregamentos,n_cfront,cfronteira,n_pontual,pontual,...
    n_fluxofront,fluxofront,n_convec,convec,a,b,nome,matriz_aux] = LeDados(nome);
%chama a funcaoo LeDados


aviso = 0;

if n_pontual ~= 0 % if there are point loads
    fprintf('\nWarning! The data file contains imposed point sources/loads!\n');
    aviso = 1;
end
if n_fluxofront ~= 0 % if there is flux at the boundary
    fprintf('\nWarning! The data file contains imposed flux at the boundary!\n');
    aviso = 1;
end
if n_convec ~= 0 % if there is imposed natural convection
    fprintf('\nWarning! The data file contains imposed natural convection!\n');
    aviso = 1;
end
if aviso == 1
    fprintf('There are invalid boundary conditions for the torsion problem!\n');
    fprintf('Invalid boundary conditions will be ignored by the program.\n');
    fprintf('It is suggested to terminate the program and change the values.\n');
end

for i = 1:n_carregamentos %% loops up to the number of loads
    if carregamentos(i,2) ~=  2 % if load is different from 2
        fprintf('\nWarning! Distributed loads are not suitable for the torsion problem!\n');
        fprintf('It is suggested to terminate the program and change the load values to 2.\n');
    end    
end

for i = 1:n_cfront %percorre at� ao n� n�s com condi�ao fronteira
    if cfronteira(i,2) ~=  0 %caso condi�ao de fronteira diferente de 0
        fprintf('\nAten��o! As condi��es de fronteira s�o inv�lidas para o problema da tor��o!\n');
        fprintf('Os psis impostos na fronteira t�m de ser iguais a zero.\n')
        fprintf('Sugere-se terminar o programa e alterar os valores.\n');
    end    
end
if propriedades(1,2) ~= 1 %caso propriedade k n�o for 1
    fprintf('\nAten��o! A propriedade do material n�o � adequada para o problema de tor��o!\n');
    fprintf('Sugere-se terminar o programa e alterar os valor da propriedade para 1.\n');
end
if n_carregamentos ~= n_elementos %caso o n� de carregamentos n�o igualar o n� elementos
    fprintf('\nAten��o! Existem elementos sem carregamentos distribu�dos aplicados!\n');
    fprintf('Sugere-se terminar o programa e alterar o ficheiro de dados.\n');
end

grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
%plot da malha com n� n�s e n� elementos
hold on

selec = 0;
resolvido = 0;

while(selec==0) %espera que o utilizador introduza uma op��o
    fprintf('\nEscolher uma op��o, come�ando pelo tipo de integra��o:\n');
    fprintf('1: Integra��o anal�tica\n');
    fprintf('2: Integra��o num�rica de Gauss 2x2\n');
    fprintf('3: Integra��o reduzida de Gauss 2x1\n');
    fprintf('4: Integra��o reduzida de Gauss 1x2\n');
    fprintf('5: Integra��o reduzida de Gauss 1x1\n');
    fprintf('6: Obter gr�ficos solu��o Prandtl, tens�es de corte e isolinhas de tens�o\n');
    fprintf('7: Obter gr�fico da malha novamente\n');
    fprintf('0: Sair do programa\n');
    opcao = input('');
    valido=0;  
   
    switch(opcao)
        case{0,1,2,3,4,5,6,7}
            valido=1;
    end
    if(valido==0)
        fprintf('\nErro! Escolha inv�lida!\n');
    end

switch(opcao) %op�oes de integra�ao para escolha do utilizador
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
        fprintf('\nIntegra��o conclu�da. Escolha a pr�xima op��o:\n');
        
    case{6} %apresenta os gr�ficos ap�s escolhido o tipo de integra��o
        if resolvido==0
            fprintf('\nErro! Ainda n�o foi executado qualquer tipo de integra��o!\n');
            fprintf('Escolha um tipo de integra��o (1,2,3,4 ou 5) primeiro.\n');
        else
           
            grafico_de_prandtl(solucao_nodal,n_nos,matriz_dos_nos,tipoint)
            hold on
                
            [centroX, centroY] = grafico_tensao_c(a,b,matriz_de_incidencias,matriz_dos_nos,n_elementos,tensaoxz,tensaoyz,tipoint);
            hold on
                
            grafico_isolinhas(n_elementos,matriz_dos_nos,centroX,centroY,tensaoxy,n_nos,tipoint)
            hold on
            
            fprintf('\nGr�ficos obtidos. Escolha a pr�xima op��o:\n');    
        end
        
    case{7} %volta a apresentar o gr�fico da malha caso o utilizador queira
        figure
        grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
        hold on
        
        fprintf('\nGr�fico obtido. Escolha a pr�xima op��o:\n');
        
    case{0} %op�ao para terminar o programa
        selec=1;
        fprintf('\n\nPrograma terminado.\n');          
end



end

aux1(matriz_aux,n_elementos,tensaoxz,tensaoyz,tensaoxy,tensao_max,tensao_min,centro_max,J,centro_min,centroX,centroY)

clear i selec valido resolvido warning matriz_aux;


       
