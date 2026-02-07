function F = flipping(I, x, y)
% F = flipping(I, x, y)
% Realiza volteo de una imagen
% I        : imagen base
% x ~= 0 : volteo sobre el eje vertical
% y ~= 0 : volteo sobre el eje horizontal

% Inicialmente, la imagen de salida es igual a la original
F = I;

% Volteo vertical
% Se invierte el orden de las filas
if x ~= 0
    F = F(end:-1:1, :);
end

% Volteo horizontal
% Se invierte el orden de las columnas
if y ~= 0
    F = F(:, end:-1:1);
end

end
