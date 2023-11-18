function stress_contour_plos(n_elementos,matriz_dos_nos,centroX,centroY,tensaoxy,n_nos,tipoint)
% This function generates graphical representations of various contour lines

X = unique(centroX);  % Registers unique values of the x-coordinate for each element center
Y = unique(centroY);  % Registers unique values of the y-coordinate for each element center
numelX = numel(X);    % Number of elements in X
numelY = numel(Y);    % Number of elements in Y

for i = 1:n_nos        % Iterates up to the number of nodes
    X(numelX + i) = matriz_dos_nos(i, 2);  % Adds node coordinates to X
    Y(numelY + i) = matriz_dos_nos(i, 3);  % Adds node coordinates to Y
end

X = unique(X);         % Unique values of X
Y = unique(Y);         % Unique values of Y
[Xmesh, Ymesh] = meshgrid(X, Y);  % Creates a matrix from the unique values of X and Y centers
tmod = zeros(size(Xmesh));        % Initializes 'mod' with zeros

for i = 1:numel(Xmesh)     % Iterates through the elements in Xmesh
    for j = 1:n_elementos  % Iterates through the total number of elements
        if centroX(j) == Xmesh(i) && centroY(j) == Ymesh(i)  
            % Replaces the value of the modulus in the matrix if both element coordinates
            % match those in the matrix generated in the meshgrid
            tmod(i) = tensaoxy(j);
        end
    end
end

[l, c] = size(tmod);   % Creates a matrix with the same dimensions as tmod
isolinhas = tmod;      % Columns            

for i = 2:(l-1)  % Iterates from the second row to the number of rows - 1
    for j = 2:(c-1)  % Iterates from the second column to the number of columns - 1
        if tmod(i,j) == 0 && tmod(i,j-1) ~= 0 && tmod(i,j+1) ~= 0  
        % If the shear stress modulus is zero and is between two columns with different nonzero values
                   isolinhas(i,j) = (tmod(i,j-1) + tmod(i,j+1))/2; % Calculates the average
            
        end
    end
end

tmod = isolinhas;   % Rows
for i = 2:(l-1)
    for j = 2:(c-1)
        if tmod(i,j) == 0 && tmod(i-1,j) ~= 0 && tmod(i+1,j) ~= 0  
            % If the shear stress modulus is zero and is between two rows with different nonzero values.
            isolinhas(i,j) = (tmod(i+1,j) + tmod(i-1,j))/2;  % Calculates the average
           
        end
    end
end   

figure
hold on
contour3(Xmesh, Ymesh, isolinhas, 150);  % Plots contour lines and their respective intensities
colorbar;                                % Shows the color bar

if tipoint == 1
    title('Stress Lines - Analytical Integration');
elseif tipoint == 2
    title('Stress Lines - Gauss Integration 2x2');
elseif tipoint == 3
    title('Stress Lines - Gauss Integration 2x1');
elseif tipoint == 4
    title('Stress Lines - Gauss Integration 1x2');
elseif tipoint == 5
    title('Stress Lines - Gauss Integration 1x1');
end

%rotate3d on;
%view(3);

end
