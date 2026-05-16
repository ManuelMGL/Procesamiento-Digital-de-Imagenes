% Función para establecer el límite y los excesos
function [J, T] = cliplim(part, cliplim)

[n, r] = imhist(part);

L = size(r);
L = L(1);
e = zeros(size(r));
% c = zeros(size(r));
% e(r>cliplim == r - cliplim) ;
% r(r>cliplim) = cliplim;
% 

% for i = 1:L
%     if n(i) > cliplim
%         e(i) = n(i) - cliplim;        
%         n(i) = cliplim;      
%     end
% end

e(n>cliplim) = n(n>cliplim) - cliplim;
n(n>cliplim) = cliplim;


sum_e = sum(e);

exs_avg = floor(sum_e/L);

residuo = mod(sum_e, L);

n = n + exs_avg;
n(1:residuo) = n(1:residuo) + 1;


% Ecualizamos con los valores nuevos de las frecuencias
[M, N] = size(part);
MN = M*N;

nk = n;

pk = nk/MN;

sk = cumsum(pk)*(L-1);

T = round(sk);

J = uint8(T(part+1));

end