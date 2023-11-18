function [n_nos,matriz_dos_nos,n_elementos,matriz_de_incidencias,n_propriedades,...
    propriedades,n_carregamentos,carregamentos,n_cfront,cfronteira,n_pontual,pontual,...
    n_fluxofront,fluxofront,n_convec,convec,a,b,nome,matriz_aux] = DataReading(nome)

% Reads data from a file and extracts structural parameters

dados = fopen(nome,'r'); % Open the file

while dados == -1
    fprintf('\nError! Invalid file name!\n');
    nome = input('Enter a valid data file name ("name.txt"):  \n', 's');
    dados = fopen(nome);
end

% Extract number of nodes
tline = fgetl(dados);
tline = fgetl(dados);
n_nos = fscanf(dados, '%f', 1);

% Extract node matrix
tline = fgetl(dados);
matriz_dos_nos = fscanf(dados, '%e', [3 inf]);
matriz_dos_nos = matriz_dos_nos';

% Extract Incidence Matrix
tline = fgetl(dados);
n_elementos = fscanf(dados, '%f', 1);
tline = fgetl(dados);
matriz_aux = fscanf(dados, '%e', [7 inf]);
matriz_aux = matriz_aux';
matriz_de_incidencias = matriz_aux(:, 4:7);

% Extract Material Properties
tline = fgetl(dados);
n_propriedades = fscanf (dados, '%f', 1);
propriedades = fscanf (dados,'%e', [2 inf]);
propriedades = propriedades';

% Extracting Distributed Loads
tline = fgetl(dados);
n_carregamentos = fscanf (dados, '%f', 1);
carregamentos = fscanf (dados,'%e', [2 inf]);
carregamentos = carregamentos';

% Extracting Boundary Conditions
tline = fgetl(dados);
n_cfront = fscanf (dados, '%f', 1);
cfronteira = fscanf (dados,'%e', [2 inf]);
cfronteira = cfronteira';

% Extracting Ponctual Loads
tline = fgetl(dados);
n_pontual = fscanf (dados, '%f', 1);
pontual = fscanf (dados,'%e', [3 inf]);
pontual = pontual';

% Extracting Flux and Stress at the Boundarys
tline = fgetl(dados);
n_fluxofront = fscanf (dados, '%f', 1);
fluxofront = fscanf (dados,'%e', [5 inf]);
fluxofront = fluxofront';

% Natural Convection
tline = fgetl(dados);
n_convec = fscanf (dados, '%f', 1);
convec = fscanf (dados,'%e', [3 inf]);
convec = convec';


% Calculate Element Sizes
a = zeros(n_elementos, 1); % Element length
b = zeros(n_elementos, 1); % Element width
for i = 1:n_elementos
    aux1 = matriz_de_incidencias(i,1);
    aux2 = matriz_de_incidencias(i,2);
    aux3 = matriz_de_incidencias(i,3);
    aux4 = matriz_de_incidencias(i,4);
    
   
    x = [matriz_dos_nos(aux1,2) matriz_dos_nos(aux2,2) matriz_dos_nos(aux3,2) matriz_dos_nos(aux4,2)];
    y = [matriz_dos_nos(aux1,3) matriz_dos_nos(aux2,3) matriz_dos_nos(aux3,3) matriz_dos_nos(aux4,3)];
    
    x_min = min(x);
    x_max = max(x);
    y_min = min(y);
    y_max = max(y);
   
    a(i) = (x_max-x_min);
    b(i) = (y_max-y_min);
end

end
