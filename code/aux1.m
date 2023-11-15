function aux1(matriz_aux,n_elementos,tensaoxz,tensaoyz,tensaoxy,tensao_max,tensao_min,centro_max,J,centro_min,centroX,centroY)

% função que cria o documento de texto da distribuição de tensões por elemento

rt = (76*10^9)*J; % cálculo da rigidez torsional
fileID = fopen('Tensões de corte por elemento e rigidez J.txt','w');
fprintf(fileID, '%s   %s       %s       %s       %s       %s\r\n','Elemento','TensãoXZ','TensaoYZ','TensaoXY','CentroX','CentroY');           
%titulos das colunas
a = tensaoxz';
b = tensaoyz';
c = tensaoxy';
d = centroX';
e = centroY';
for i=1:n_elementos   %percorrer até ao número total de elementos
    fprintf(fileID, '\n%.1f      %f      %f      %f      %f      %f\r\n',matriz_aux(i,1),a(i),b(i),c(i),d(i),e(i));     
    %escrita das variáveis pretendidas para cada elemento, linha a linha
end
fprintf(fileID,'\r\n');
fprintf(fileID,'\n\nO valor máximo de tensão é %s Pa\n e situa-se no ponto de coordenadas x = %s m e y = %s m.\r\n',tensao_max,centro_max(1),centro_max(2));   %apresentação dos resultantes resultados pedidos no enunciado
fprintf(fileID,'\n\nO valor mínimo de tensão é %s Pa\n e situa-se no ponto de coordenadas x = %s m e y = %s m.\r\n',tensao_min,centro_min(1),centro_min(2));
fprintf(fileID,'\n\nO valor de constante de torção é %s m^4.\r\n', J);
fprintf(fileID,'\n\nO valor da Rigidez Torsional é %s Pa.m^4.\r\n', rt);
fclose(fileID);
end
