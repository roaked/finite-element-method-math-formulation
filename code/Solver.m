function [solucao_nodal] = Solver(K,F,cfronteira,n_nos)
% Function that returns the solution at each node

nos_scf = n_nos - length(cfronteira); % Nodes without boundary conditions set to 0
Kred = zeros(nos_scf); % Initializing the reduced stiffness matrix Kred to zeros
Fred = zeros(nos_scf, 1); % Initializing the reduced force vector Fred to zeros

vaux = [];
for p = 1:1:n_nos
    % Creating a vector containing the indices of nodes without boundary conditions
    o = find(cfronteira(:,1) == p, 1);
    if isempty(o)
        vaux = [vaux p];
    end
end

for i = 1:1:length(vaux)
    % Loop through nodes without boundary conditions
    for p = 1:length(vaux)
        % Within this loop, the reduced stiffness matrix Kred is created. This matrix corresponds to the global matrix 
        % but excludes rows and columns where nodal solutions are zero
        Kred(i,p) = K(vaux(i), vaux(p)); 
        % Extracting elements from the global stiffness matrix to form the reduced stiffness matrix
    end
end


for z = 1:1:length(vaux)
    % Loop through nodes without boundary conditions
    Fred(z, 1) = F(vaux(z), 1);
    % Building the reduced force vector Fred by selecting values corresponding to nodes without boundary conditions
end

psis = (Kred^-1) * Fred;
% Solving for the solution through matrix inversion: using the inverse of the reduced stiffness matrix to solve for nodal displacements

solucao_nodal = zeros(n_nos, 1);
for z = 1:1:length(vaux)
    % Loop through nodes without boundary conditions
    solucao_nodal(vaux(z)) = psis(z);
    % Creating the total solution vector including nodes where the solution is zero
end

end

