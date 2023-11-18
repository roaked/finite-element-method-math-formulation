function [K] = KGauss(opcao, matriz_de_incidencias, n_nos, a, b, propriedades)
% Function that calculates the global stiffness matrix for numerical Gaussian integration
% Rectangle:
% Nodes:
% 4 3
% 1 2

K = zeros(n_nos); % Initialization to zeros with length equal to the number of nodes    
k = propriedades(1,2);  %k=1

if opcao == 2
% Gaussian Integration 2x2
w=1; % Weight   

dfix1 = zeros(1,n_nos);% Initialization to zeros
dfix2 = zeros(1,n_nos);% Initialization to zeros
dfiy1 = zeros(1,n_nos);% Initialization to zeros
dfiy2 = zeros(1,n_nos);% Initialization to zeros

for i = 1:1:size(matriz_de_incidencias) % Loop through the number of elements
    x1 = a(i)/2*(1-sqrt(1/3)); % Calculate x1 for element i
    x2 = a(i)/2*(1+sqrt(1/3)); % Calculate x2 for element i
    y1 = b(i)/2*(1-sqrt(1/3)); % Calculate y1 for element i
    y2 = b(i)/2*(1+sqrt(1/3)); % Calculate y2 for element i
    c = matriz_de_incidencias(i,1:4); % Store the values of nodes associated with element i


    % Store individual node values for element i
    c1 = c(1,1); % Node #1 of element i
    c2 = c(1,2); % Node #2 of element i
    c3 = c(1,3); % Node #3 of element i
    c4 = c(1,4); % Node #4 of element i
    
    % Definition of the derivatives of the shape function
    % Derivatives with respect to x1 and y1
    dfix1(c1) = -1/a(i)*(1-y1/b(i));
    dfiy1(c1) = -1/b(i)*(1-x1/a(i));
    dfix1(c2) = 1/a(i)*(1-y1/b(i));
    dfiy1(c2) = -1/b(i)*(x1/a(i));
    dfix1(c3) = 1/a(i)*(y1/b(i));
    dfiy1(c3) = 1/b(i)*(x1/a(i));
    dfix1(c4) = -1/a(i)*(y1/b(i));
    dfiy1(c4) = 1/b(i)*(1-x1/a(i));

    % Derivatives with respect to x2 and y2
    dfix2(c1) = -1/a(i)*(1-y2/b(i));
    dfiy2(c1) = -1/b(i)*(1-x2/a(i));
    dfix2(c2) = 1/a(i)*(1-y2/b(i));
    dfiy2(c2) = -1/b(i)*(x2/a(i));
    dfix2(c3) = 1/a(i)*(y2/b(i));
    dfiy2(c3) = 1/b(i)*(x2/a(i));
    dfix2(c4) = -1/a(i)*(y2/b(i));
    dfiy2(c4) = 1/b(i)*(1-x2/a(i)); 
    
     % Construction of matrix K with coordinate transformation and subsequent assembly

    for o = [c1,c2,c3,c4]  
        for j = [c1,c2,c3,c4]
            % Calculation of matrix K elements
            K(o,j) = K(o,j) + ((dfix1(o)*dfix1(j)+dfiy1(o)*dfiy1(j))... 
            + (dfix1(o)*dfix1(j)+dfiy2(o)*dfiy2(j)) + (dfix2(o)*dfix2(j)+dfiy1(o)*dfiy1(j))...
            + (dfix2(o)*dfix2(j)+dfiy2(o)*dfiy2(j))) *k*w*(a(i)*b(i)/4); 
            % ^ This line calculates and assembles the stiffness matrix
        end
    end
end
    

elseif option == 3
% Gaussian Integration 2x1 / Weights
w1=2;
w2=2;
dfix = zeros(1,n_nos); % Initializing array for derivative with respect to x
dfiy1 = zeros(1,n_nos); % Initializing array for derivative with respect to y1
dfiy2 = zeros(1,n_nos); % Initializing array for derivative with respect to y2

for i = 1:1:size(matriz_de_incidencias)
    x1 = a(i)/2*(1-sqrt(1/3)); % Calculation of x1 for element i
    x2 = a(i)/2*(1+sqrt(1/3)); % Calculation of x2 for element i
    y = b(i)/2;  % Calculation of y for element i
    c = matriz_de_incidencias(i,1:4); % Getting node indices for element i
    % Node 1,2,3,4 of element i
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);
    
    % Calculating derivatives for nodes with respect to x and y1
    dfix(c1) = -1/a(i)*(1-y/b(i));
    dfiy1(c1) = -1/b(i)*(1-x1/a(i));
    dfix(c2) = 1/a(i)*(1-y/b(i));
    dfiy1(c2) = -1/b(i)*(x1/a(i));
    dfix(c3) = 1/a(i)*(y/b(i));
    dfiy1(c3) = 1/b(i)*(x1/a(i));
    dfix(c4) = -1/a(i)*(y/b(i));
    dfiy1(c4) = 1/b(i)*(1-x1/a(i));
   
    % Calculating derivatives for y2
    dfiy2(c1) = -1/b(i)*(1-x2/a(i));
    dfiy2(c2) = -1/b(i)*(x2/a(i));
    dfiy2(c3) = 1/b(i)*(x2/a(i));
    dfiy2(c4) = 1/b(i)*(1-x2/a(i));
   
    % Loop to calculate matrix K
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            % Calculation and assembly of the stiffness matrix elements
            K(o,j) = K(o,j) + ((((dfix(o)*dfix(j))+(dfiy1(o)*dfiy1(j))) * w1)... 
            + (((dfix(o)*dfix(j))+(dfiy2(o)*dfiy2(j))) * w2)) *k*(a(i)*b(i)/4); 
        end
    end
end
 

elseif opcao == 4
% Gaussian Integration 1x2 / Weights
w1=2;
w2=2;

dfix1 = zeros(1,n_nos); % Initializing array for derivative with respect to x1
dfix2 = zeros(1,n_nos); % Initializing array for derivative with respect to x2
dfiy = zeros(1,n_nos); % Initializing array for derivative with respect to y

for i = 1:1:size(matriz_de_incidencias)
    x = a(i)/2; % Calculation of x for element i
    y1 = b(i)/2*(1-sqrt(1/3));  % Calculation of y1 for element i
    y2 = b(i)/2*(1+sqrt(1/3));  % Calculation of y2 for element i
    c = matriz_de_incidencias(i,1:4); % Getting node indices for element i
    % Node 1,2,3,4 of element i
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);
    
    % Calculating derivatives for x1 and y
    dfix1(c1) = -1/a(i)*(1-y1/b(i));
    dfiy(c1) = -1/b(i)*(1-x/a(i));
    dfix1(c2) = 1/a(i)*(1-y1/b(i));
    dfiy(c2) = -1/b(i)*(x/a(i));
    dfix1(c4) = -1/a(i)*(y1/b(i));
    dfiy(c4) = 1/b(i)*(1-x/a(i));
    dfix1(c3) = 1/a(i)*(y1/b(i));
    dfiy(c3) = 1/b(i)*(x/a(i));

    % Calculating derivatives for x2
    dfix2(c1) = -1/a(i)*(1-y2/b(i));
    dfix2(c2) = 1/a(i)*(1-y2/b(i));
    dfix2(c4) = -1/a(i)*(y2/b(i));
    dfix2(c3) = 1/a(i)*(y2/b(i));
    
    % Loop to calculate matrix K
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            % Calculation and assembly of the stiffness matrix elements
            K(o,j) = K(o,j) + ((((dfix1(o)*dfix1(j))+(dfiy(o)*dfiy(j))) * w1)...
            + (((dfix2(o)*dfix2(j))+(dfiy(o)*dfiy(j))) * w2)) *k*(a(i)*b(i)/4); 
        end
    end
end


elseif opcao == 5
% Gaussian Integration 1x1  
w1 = 4;  % Weight for the Gauss point

dfix = zeros(1,n_nos); % Initializing array for derivative with respect to x
dfiy = zeros(1,n_nos); % Initializing array for derivative with respect to y

for i = 1:1:size(matriz_de_incidencias)
    x = a(i)/2;% Calculation of x for element i
    y = b(i)/2; % Calculation of y for element i
    c = matriz_de_incidencias(i,1:4); % Getting node indices for element i
    % Node
    c1 = c(1,1);
    c2 = c(1,2);
    c3 = c(1,3);
    c4 = c(1,4);

    % Calculating derivatives for x and y
    dfix(c1) = -1/a(i)*(1-y/b(i));
    dfiy(c1) = -1/b(i)*(1-x/a(i));
    dfix(c2) = 1/a(i)*(1-y/b(i));
    dfiy(c2) = -1/b(i)*(x/a(i));
    dfix(c4) = -1/a(i)*(y/b(i));
    dfiy(c4) = 1/b(i)*(1-x/a(i));
    dfix(c3) = 1/a(i)*(y/b(i));
    dfiy(c3) = 1/b(i)*(x/a(i));
        
    % Loop to calculate matrix K
    for o = [c1,c2,c3,c4]
        for j = [c1,c2,c3,c4]
            % Calculation and assembly of the stiffness matrix elements
            K(o,j) = K(o,j) + ((dfix(o)*dfix(j))+(dfiy(o)*dfiy(j))) * k*(a(i)*b(i)/4*w1);    
        end
    end
end

end


end