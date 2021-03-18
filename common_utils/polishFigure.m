function polishFigure
% This function makes your figure look publication worthy
%% use: polishFigure
% $KK 
set(gca,'TickDir', 'out');
set(gca,'ticklength',[0.019 0.019]);
set(gca, 'box', 'off');
set(gca,'FontName','Arial');
set(gca, 'FontSize',15);
set(gca, 'PlotBoxAspectRatio',[1 1 1]);
set(gca,'DefaultAxesFontName', 'Arial');
set(gca,'LineWidth',1);