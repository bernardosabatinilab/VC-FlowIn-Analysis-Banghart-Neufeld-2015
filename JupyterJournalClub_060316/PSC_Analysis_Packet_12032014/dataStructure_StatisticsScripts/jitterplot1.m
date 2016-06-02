function jitterplot1(data1)

xJitter1 = jAxis(length(data1),1,0.03);

figure
axes1 = axes('Parent',figure(gcf),'XTickLabel','','XTick',zeros(1,0),...
    'FontSize',16,...
    'FontName','Iskoola Pota');
ylim(axes1,[0 1.2]);
xlim(axes1,[0.8 2.2]);
hold(axes1,'all');
plot(xJitter1,data1,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[.6 .6 .6],...
    'MarkerSize',15,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 0]);
hold on
errorbar(mean(data1),std(data1),'MarkerSize',50,'MarkerFaceColor',[0 0 0],'Marker','.',...
    'LineStyle','none',...
    'LineWidth',2.5,...
    'Color',[0 0 0]);

end