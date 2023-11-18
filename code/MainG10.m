%
%
%Ricardo Chin
%
%
%

clc

fprintf('\nFormulating a Finite Element Analysis Model\n');
fprintf('This program solves torsion problems of prismatic bars.\n');
nome = input('Enter the data file name ("name.txt"): \n','s');


[n_nos,matriz_dos_nos,n_elementos,matriz_de_incidencias,n_propriedades,...
    propriedades,n_carregamentos,carregamentos,n_cfront,cfronteira,n_pontual,pontual,...
    n_fluxofront,fluxofront,n_convec,convec,a,b,nome,matriz_aux] = DataReading(nome);
% Call function DataReading


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

for i = 1:n_cfront % loops up to the number of nodes with boundary condition
    if cfronteira(i,2) ~=  0 % if boundary condition is different from 0
        fprintf('\nWarning! The boundary conditions are invalid for the torsion problem!\n');
        fprintf('The imposed psis at the boundary must be equal to zero.\n')
        fprintf('It is suggested to terminate the program and change the values.\n');
    end    
end

if propriedades(1,2) ~= 1 % if property k is not 1
    fprintf('\nWarning! The material property is not suitable for the torsion problem!\n');
    fprintf('It is suggested to terminate the program and change the property value to 1.\n');
end

if n_carregamentos ~= n_elementos % if the number of loads does not equal the number of elements
    fprintf('\nWarning! There are elements without applied distributed loads!\n');
    fprintf('It is suggested to terminate the program and modify the data file.\n');
end

grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
%plots of mesh with nodes and elements
hold on

selec = 0;
resolvido = 0;

while (selec == 0)
    % Waiting.....
    fprintf('\nChoose an option, starting with the type of integration:\n');
    fprintf('1: Analytical Integration\n');
    fprintf('2: Numerical Integration - Gauss 2x2\n');
    fprintf('3: Reduced Integration - Gauss 2x1\n');
    fprintf('4: Reduced Integration - Gauss 1x2\n');
    fprintf('5: Reduced Integration - Gauss 1x1\n');
    fprintf('6: Obtain Prandtl solution, shear stresses, and stress contour plots\n');
    fprintf('7: Replot the mesh\n');
    fprintf('0: Exit the program\n');
    opcao = input('');
    valido = 0;
   
    switch(opcao)
        case{0,1,2,3,4,5,6,7}
            valido=1;
    end
    if(valido==0)
        fprintf('\nERROR! Invalid option!\n');
    end

switch(opcao) %Interface integration options
    case{1,2,3,4,5}
        if opcao==1
           [K] = KAnalitico(matriz_de_incidencias,n_nos,a,b,propriedades);          
        else
           [K] = KGauss(opcao, matriz_de_incidencias, n_nos, a, b, propriedades); 
        end
        tipoint = opcao;
        
        [F] = Forcas(matriz_de_incidencias,n_nos,a,b,carregamentos );
        
        [solucao_nodal] = Solver(K,F,cfronteira,n_nos);
        
        [Je, J] = torsionconstantJ(solucao_nodal,a,b,n_elementos,matriz_de_incidencias);
        
        [centro_max,centro_min,tensao_max,tensao_min,tensaoxy,tensaoxz,tensaoyz] = Stresses(n_elementos, matriz_dos_nos, matriz_de_incidencias,a,b,J,solucao_nodal);
        
        resolvido = 1;
        fprintf('\nIntegration completed. Choose the next option:\n');
        
    case{6} % Displays plots after integration type is chosen
        if resolvido==0
            fprintf('\nError! No integration has been performed yet!\n');
            fprintf('Choose an integration type (1, 2, 3, 4, or 5) first.\n');
        else
           
            grafico_de_prandtl(solucao_nodal,n_nos,matriz_dos_nos,tipoint)
            hold on
                
            [centroX, centroY] = graph_shear_stresses(a,b,matriz_de_incidencias,matriz_dos_nos,n_elementos,tensaoxz,tensaoyz,tipoint);
            hold on
                
            stress_contour_plos(n_elementos,matriz_dos_nos,centroX,centroY,tensaoxy,n_nos,tipoint)
            hold on
            
            fprintf('\nPlots obtained. Choose the next option:\n');    
        end
        
    case{7} % Displays the mesh plot if the user wants
        figure
        grafico_da_malha(n_nos,n_elementos,matriz_dos_nos,matriz_de_incidencias,a,b)
        hold on
        
        fprintf('\nMesh plot obtained. Choose the next option:\n');
        
    case{0} % Option to terminate the program
        selec=1;
        fprintf('\n\nProgram terminated.\n');             
end



end

aux1(matriz_aux,n_elementos,tensaoxz,tensaoyz,tensaoxy,tensao_max,tensao_min,centro_max,J,centro_min,centroX,centroY)

clear i selec valido resolvido warning matriz_aux;


       
