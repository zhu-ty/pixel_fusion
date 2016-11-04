function [x_list, y_list] = img_data_generator_row(I, b1, b2, PIC_MAX_ROW, PIC_MAX_COL, SAMP_ROW_LEN, SAMP_COL_LEN)
%IMG_X_GENERATER 此处显示有关此函数的摘要
%   此处显示详细说明

    x_list = zeros(PIC_MAX_ROW, 1);
    y_list = zeros(PIC_MAX_ROW, SAMP_COL_LEN);
    
    I = double(I) - b2;
    
    I = I - repmat(b1(:,1), 1, PIC_MAX_COL);
    
    if(mod(SAMP_COL_LEN, 2) ~= 0)
        return;
    end
    
    I = I(:, PIC_MAX_COL / 2 - SAMP_COL_LEN / 2 + 1 : PIC_MAX_COL / 2 + SAMP_COL_LEN / 2);
    
    %Remember that we have fliped the matrix.
    y_list = I;
    
    BORDER_WID = round(SAMP_ROW_LEN / 2);
    
    avg_u = mean(mean(I(1 : SAMP_ROW_LEN, :)));
    avg_d = mean(mean(I(end - SAMP_ROW_LEN + 1 : end, :)));

    x_list(1 : BORDER_WID, :) = avg_u;
    x_list(end - BORDER_WID + 1, :) = avg_d;
    
    for i = BORDER_WID + 1 : PIC_MAX_ROW - BORDER_WID
        x_list(i, :) = mean(mean(I(i - BORDER_WID + 1 : i + BORDER_WID - 1,:)));
    end
    
end

