function G = escalaBilineal(I, Sx, Sy)
% G = escalaBilineal(I, Sx, Sy)  
% Escala la imagen original I con Sx y Sy
%
% I  : imagen base
% Sx : escala para el eje x
% Sy : escala para el eje y


% Transformar la imagen a tipo double
I = double(I);

[M, N] = size(I);

% Tamaño para la imagen resultante
MJ = floor(M * Sx);
NJ = floor(N * Sy);

G = zeros(MJ, NJ);

for x_ast = 1:MJ
    for y_ast = 1:NJ
        
        % Coordenadas en la imagen original
        x_prima = x_ast / Sx;
        y_prima = y_ast / Sy;
        
        x_prima = min(max(x_prima, 1), M-1);
        y_prima = min(max(y_prima, 1), N-1);
        
        x = floor(x_prima);
        y = floor(y_prima);
        
        x2 = x + 1;
        y2 = y + 1;
                
        % Cálculo de distancias y pesos
        dx = x_prima - x;
        dy = y_prima - y;
        
        Av = dx;
        Ah = dy;
        
        Bv = 1 - dx;
        Bh = 1 - dy;
        
        % Interpolación bilineal
        Ix_y   = 0;  Ix_y2  = 0;
        Ix2_y  = 0;  Ix2_y2 = 0;
        
        if x >= 1 && x <= M
            if y  >= 1 && y  <= N, Ix_y  = I(x,y);  end
            if y2 >= 1 && y2 <= N, Ix_y2 = I(x,y2); end
        end
        
        if x2 >= 1 && x2 <= M
            if y  >= 1 && y  <= N, Ix2_y  = I(x2,y);  end
            if y2 >= 1 && y2 <= N, Ix2_y2 = I(x2,y2); end
        end       
             
        
        G(x_ast, y_ast) = ...
            Bv*Bh*Ix_y + ...
            Bv*Ah*Ix_y2 + ...
            Av*Bh*Ix2_y + ...
            Av*Ah*Ix2_y2;
    end
end

