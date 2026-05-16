function J = randomErase(I, p, value)
% J = randomErase(I, p, value)  
% Borra una región rectangular aleatoria de la imagen
%
% I     : imagen de entrada (grises)
% p     : probabilidad de aplicar el borrado (0–1)
% value : valor con el que se rellena la región borrada

I = double(I);          % Asegurar tipo
J = I;                  % Copia de salida

[M, N] = size(I);       % Dimensiones de la imagen

% Decidir si se aplica el borrado
if rand < (1 - p)
    return              % No se borra nada
end

% Elegir tamaño del rectángulo
alto  = randi([round(0.2*M), round(0.4*M)]);
ancho = randi([round(0.2*N), round(0.4*N)]);

% Elegir posición aleatoria válida
fila = randi(M - alto  + 1);
col  = randi(N - ancho + 1);

% Borrar la región seleccionada
J(fila:fila+alto-1, col:col+ancho-1) = value;
end