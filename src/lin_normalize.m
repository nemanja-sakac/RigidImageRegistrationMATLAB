function norm_img = lin_normalize(img, new_min, new_max)
% LIN_NORMALIZE normalizes an image of any dynamic range to a desired
% dynamic range

norm_img = (img - min(img(:))) .* (new_max - new_min)...
    / (max(img(:)) - min(img(:))) + new_min;