function img_out = ecualizar(img_in)

    f = double(img_in);
    [M, N] = size(f);
    L = 256;

    counts = histcounts(f, 0:L);
    p = counts / (M * N);

    sk = (L - 1) * cumsum(p);

    sk = round(sk);
    img_out = zeros(M, N);
    for k = 0:L-1
        img_out(f == k) = sk(k+1);
    end
    img_out = uint8(img_out);
end