function aux1(matriz_aux,n_elementos,tensaoxz,tensaoyz,tensaoxy,tensao_max,tensao_min,centro_max,J,centro_min,centroX,centroY)

% function that creates the text document of stress distribution per element

rt = (76*10^9)*J; % calculation of torsional stiffness
fileID = fopen('Shear Stresses per Element and J stiffness.txt','w');
fprintf(fileID, '%s   %s       %s       %s       %s       %s\r\n','Elemento','TensaoXZ','TensaoYZ','TensaoXY','CentroX','CentroY');           
% column titles
a = tensaoxz';
b = tensaoyz';
c = tensaoxy';
d = centroX';
e = centroY';
for i=1:n_elementos   % loop through the total number of elements
    fprintf(fileID, '\n%.1f      %f      %f      %f      %f      %f\r\n',matriz_aux(i,1),a(i),b(i),c(i),d(i),e(i));     
    % writing desired variables for each element, line by line
end
fprintf(fileID,'\r\n');
fprintf(fileID,'\n\nThe maximum stress value is %s Pa\n and is located at coordinates x = %s m and y = %s m.\r\n',tensao_max,centro_max(1),centro_max(2));
fprintf(fileID,'\n\nThe minimum stress value is %s Pa\n and is located at coordinates x = %s m and y = %s m.\r\n',tensao_min,centro_min(1),centro_min(2));
fprintf(fileID,'\n\nThe torsion constant value is %s m^4.\r\n', J);
fprintf(fileID,'\n\nThe Torsional Stiffness value is %s Pa.m^4.\r\n', rt);
fclose(fileID);
end
