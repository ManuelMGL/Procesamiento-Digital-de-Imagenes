function J = ecualizar(I)

[M, N] = size(I);
MN = M*N;

[nk, rk] = imhist(I);

pk = nk/MN;

% Obtenemos el rango dinamico de la imagen
L = max(rk) + 1;

sk = zeros(1, L);

% cumsum para sumas acumuladas

% for i=1:L
%     sk(i) = (L-1)*pk(i);
%     
%     if i > 1
%         sk(i) = sk(i) + sk(i-1);
%     end
% end

sk = cumsum(pk)*(L-1);

T = round(sk);

J = zeros(M, N);

% for i = 1:128
%     for j = 1:128
%         rk_aux = I(i, j);
%         J(i, j) = T(rk_aux+1);
%     end
% end

J = uint8(T(I+1));







