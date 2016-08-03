

elements = 4;

sidelobeAttenuation = 9;

for angleIndex = 1:20
    
    steeringAngle = angleIndex * (20/360) * 2 * pi;
    
    weights = dolphTArray(elements,sidelobeAttenuation) .* exp(1i*[1:elements]*steeringAngle);
    
    scanningBeamformer;
    
    azPatterns(elements,angleIndex,:) = pattern(91,:);

    azPatternCDFs(elements,angleIndex,:) = azPatternCDF;
   
    
end

figure;
hold on;
for i = 4:4
    for j = 1:20
        plot(cdfRange,squeeze(azPatternCDFs(i,j,:)),'DisplayName',[num2str(i) ' elements, ' num2str(j * 20) ' Degrees shift']);
    end
end

legend(gca,'show')