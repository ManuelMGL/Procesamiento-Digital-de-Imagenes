function J = cutMix(I1, I2, p)
% J = cutMix(I1, I2, p)  
% Inserta un parche de I2 dentro de I1
%
% I1 : imagen base
% I2 : imagen fuente del parche (mismo tamaño)
% p  : probabilidad de aplicar CutMix (0–1)

I1 = double(I1);
I2 = double(I2);

[M, N] = size(I1);

J = I1;    % Imagen de salida inicia como I1

% Decidir si se aplica CutMix
if rand < (1 - p)
    return
end

% Tamaño del parche
alto  = randi([round(0.2*M), round(0.4*M)]);
ancho = randi([round(0.2*N), round(0.4*N)]);

% Posición aleatoria válida
fila = randi(M - alto  + 1);
col  = randi(N - ancho + 1);

% Copiar parche de I2 sobre I1

parche = I2(fila:fila+alto-1, col:col+ancho-1);

J(fila:fila+alto-1, col:col+ancho-1) = parche;

end
