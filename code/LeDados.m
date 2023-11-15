function [n_nos,matriz_dos_nos,n_elementos,matriz_de_incidencias,n_propriedades,...
    propriedades,n_carregamentos,carregamentos,n_cfront,cfronteira,n_pontual,pontual,...
    n_fluxofront,fluxofront,n_convec,convec,a,b,nome,matriz_aux] = LeDados(nome)

%(dados,abertura)
dados = fopen(nome,'r');

while dados==-1
    fprintf('\nErro! Nome do ficheiro inválido!\n');
    nome = input('Introduza um nome do ficheiro de dados válido ("nome.txt"):  \n', 's');
    dados = fopen(nome);
end

tline = fgetl(dados);
tline = fgetl(dados);
n_nos = fscanf (dados, '%f',(1));

%Matriz dos nos
tline = fgetl(dados);
matriz_dos_nos = fscanf (dados,'%e', [3 inf]);
matriz_dos_nos = matriz_dos_nos';

%Matriz de Incidencias
tline = fgetl(dados);
n_elementos = fscanf (dados, '%f', 1);
tline = fgetl(dados);
matriz_aux = fscanf (dados,'%e', [7 inf]);
matriz_aux = matriz_aux';
matriz_de_incidencias = matriz_aux(:,4:7);

%Propriedades do material
tline = fgetl(dados);
n_propriedades = fscanf (dados, '%f', 1);
propriedades = fscanf (dados,'%e', [2 inf]);
propriedades = propriedades';

%Carregamentos Distribuidos
tline = fgetl(dados);
n_carregamentos = fscanf (dados, '%f', 1);
carregamentos = fscanf (dados,'%e', [2 inf]);
carregamentos = carregamentos';

%Condição Fronteira Essencial
tline = fgetl(dados);
n_cfront = fscanf (dados, '%f', 1);
cfronteira = fscanf (dados,'%e', [2 inf]);
cfronteira = cfronteira';

%Carga Pontual
tline = fgetl(dados);
n_pontual = fscanf (dados, '%f', 1);
pontual = fscanf (dados,'%e', [3 inf]);
pontual = pontual';

%Tensão/Fluxo na fronteira
tline = fgetl(dados);
n_fluxofront = fscanf (dados, '%f', 1);
fluxofront = fscanf (dados,'%e', [5 inf]);
fluxofront = fluxofront';

%Conveccção Natural
tline = fgetl(dados);
n_convec = fscanf (dados, '%f', 1);
convec = fscanf (dados,'%e', [3 inf]);
convec = convec';


%tamanho dos elementos
a = zeros(n_elementos,1);                %comprimento do elemento
b = zeros(n_elementos,1);                %largura do elemento
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
