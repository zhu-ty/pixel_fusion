function [fitresult, gof] = createFit(ax, ay)
%CREATEFIT(AX,AY)
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

%  由 MATLAB 于 04-Nov-2016 10:33:49 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( ax, ay );

% Set up fittype and options.
ft = fittype( 'poly2' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'Bisquare';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'ay vs. ax', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel ax
% ylabel ay
% grid on


