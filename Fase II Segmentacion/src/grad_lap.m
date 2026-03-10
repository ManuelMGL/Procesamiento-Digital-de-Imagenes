function img_out = grad_lap(img_in)
    f = double(img_in);
    
    w_lap = [0 1 0; 1 -4 1; 0 1 0];
    L = imfilter(f, w_lap, 'replicate');
    R = f - L; 

    Gx = [-1 0 1; -2 0 2; -1 0 1];
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];
    mag_grad = abs(imfilter(f, Gx, 'replicate')) + abs(imfilter(f, Gy, 'replicate'));
    
    w_avg = fspecial('average', [5 5]);
    mag_smooth = imfilter(mag_grad, w_avg, 'replicate');
    

    mask = R .* (mag_smooth / max(mag_smooth(:)));
    
    g = f + mask;
    
    img_out = uint8(max(0, min(255, g)));
end