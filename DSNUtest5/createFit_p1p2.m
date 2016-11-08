function [fitresult, gof] = createFit_p1p2(ax, ay)
%CREATEFIT1(AX,AY)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : ax
%      Y Output: ay
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 08-Nov-2016 11:21:03 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( ax, ay );

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'Bisquare';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



