function G = rotacionBilineal(I, ang)
% G = rotacionBilineal(I, ang)
% Rota la imagen original un ángulo ang en grados, sobre el centro de la imagen [a, b]
%
% I   : imagen base
% ang : ángulo de rotación (grados)

% Transformar la imagen a tipo double
I = double(I);

[M, N] = size(I);

% La rotación se hace respecto al centro de la imagen, [a, b]
theta = ang * pi / 180;

% Cálculo del centro de la imagen
a = (M+1)/2;
b = (N+1)/2;

% Se definen las matrices de transformación
Mtras = [1 0 a; 0 1 b; 0 0 1];
Mrot = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
Mtras_inv = [1 0 -a; 0 1 -b; 0 0 1];

M_T_R_Tinv = Mtras*Mrot*Mtras_inv;

G = zeros(M, N);

for i_ast = 1:M
    for j_ast = 1:N
        pos = M_T_R_Tinv \ [i_ast j_ast 1]';
        
        x_prima = pos(1);
        y_prima = pos(2);
        
        % Limitar para bilineal
        x_prima = max(1, min(x_prima, M-1));
        y_prima = max(1, min(y_prima, N-1));
        
        if x_prima < 1 || x_prima > M-1 || y_prima < 1 || y_prima > N-1
            continue;   % deja el píxel negro
        end
        
        x = floor(x_prima);
        y = floor(y_prima);
        
        x2 = x + 1;
        y2 = y + 1;
        
        % Cálculo de pesos
        dx = x_prima - x;
        dy = y_prima - y;
        
        Av = dx;
        Ah = dy;
        
        Bv = 1 - dx;
        Bh = 1 - dy;
        
        % Interpolación bilineal
        G(i_ast, j_ast) = ...
            Bv*Bh*I(x, y) + ...
            Bv*Ah*I(x, y2) + ...
            Av*Bh*I(x2, y) + ...
            Av*Ah*I(x2, y2);
        
    end
end


