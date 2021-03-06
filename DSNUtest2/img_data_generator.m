function [y_list, x_list] = img_data_generator(I, b1, b2, PIC_MAX_ROW, PIC_MAX_COL, SAMP_ROW_LEN, SAMP_COL_LEN)
%IMG_X_GENERATER 此处显示有关此函数的摘要
%   此处显示详细说明

    y_list = zeros(2, PIC_MAX_COL);
    x_list = zeros(2 * SAMP_ROW_LEN, PIC_MAX_COL);
    
    I = I - b2;
    
    I_pt1 = I(1 : PIC_MAX_ROW / 2, :);
    I_pt1 = flipud(I_pt1);
    I_pt2 = I(PIC_MAX_ROW / 2 + 1 : end, :);
    
    I_pt1 = double(I_pt1) - repmat(b1(1, :), PIC_MAX_ROW / 2, 1);
    I_pt2 = double(I_pt2) - repmat(b1(2, :), PIC_MAX_ROW / 2, 1);
    
    if(mod(SAMP_COL_LEN, 2) == 0)
        return;
    end
    
    %Remember that we have fliped the matrix.
    x_list(1 : SAMP_ROW_LEN, :) = I_pt1(1 : SAMP_ROW_LEN, :);
    x_list(SAMP_ROW_LEN + 1 : end, :) = I_pt2(1 : SAMP_ROW_LEN, :);
    
    BORDER_WID = round(SAMP_COL_LEN / 2);
    
    avg_lu = mean(mean(I_pt1(1 : SAMP_ROW_LEN, 1 : SAMP_COL_LEN)));
    avg_ld = mean(mean(I_pt2(1 : SAMP_ROW_LEN, 1 : SAMP_COL_LEN)));
    tmp_I_pt1 = fliplr(I_pt1);
    tmp_I_pt2 = fliplr(I_pt2);
    avg_ru = mean(mean(tmp_I_pt1(1 : SAMP_ROW_LEN, 1 : SAMP_COL_LEN)));
    avg_rd = mean(mean(tmp_I_pt2(1 : SAMP_ROW_LEN, 1 : SAMP_COL_LEN)));
    clear tmp_I_pt1;
    clear tmp_I_pt2;
    y_list(1,1 : BORDER_WID) = avg_lu;
    y_list(2,1 : BORDER_WID) = avg_ld;
    y_list(1,PIC_MAX_COL - BORDER_WID + 1 : end) = avg_ru;
    y_list(2,PIC_MAX_COL - BORDER_WID + 1 : end) = avg_rd;
    
    for i = BORDER_WID + 1 : PIC_MAX_COL - BORDER_WID
        y_list(1, i) = mean(mean(I_pt1(1 : SAMP_ROW_LEN, i - BORDER_WID + 1 : i + BORDER_WID - 1)));
        y_list(2, i) = mean(mean(I_pt2(1 : SAMP_ROW_LEN, i - BORDER_WID + 1 : i + BORDER_WID - 1)));
    end
    
end

