function T = traslation(I, Tx, Ty)
% T = traslation(I, Tx, Ty)
% Trasalada la imagen original Tx y Ty pixeles
%
% I  : imagen de entrada (grises)
% Tx : valor de traslado para el eje x
% Ty : valor de traslado para el eje y

Tx = fix(Tx);
Ty = fix(Ty);

[M, N] = size(I);

T = zeros(M, N);

% Cálculo para el traslado en el eje x
if Tx <= 0
    x_tras_T = 1:M+Tx;
    x_tras_I = -Tx+1:M;
else
    x_tras_T = Tx:M;
    x_tras_I = 1:M-Tx+1;
end    

% Cálculo para el traslado en el eje y
if Ty <= 0
    y_tras_T = 1:N+Ty;
    y_tras_I = -Ty+1:N;
else
    y_tras_T = Ty:N;
    y_tras_I = 1:N-Ty+1;
end   

% Asignacion de la imagen trasladada
T(x_tras_T, y_tras_T) = I(x_tras_I, y_tras_I);
