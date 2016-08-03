
% Investigate the changes to antenna CDF as a function of number of
% elements


for elements = 4:4
    for sidelobeAttenuationIndex = 1:5
            
        sidelobeAttenuation = sidelobeAttenuationIndex * 3;
        
        weights = dolphTArray(elements,sidelobeAttenuation);
        
        scanningBeamformer;

        azPatterns(elements,sidelobeAttenuationIndex,:) = pattern(91,:);

        azPatternCDFs(elements,sidelobeAttenuationIndex,:) = azPatternCDF;
        
        cdfRanges(elements,sidelobeAttenuationIndex,:) = cdfRange;
        
    end
end

% figure;
% for i = 2:14
%     polar(az*180/pi,azPatterns(i,:));
%     hold on;
% end

figure;
hold on;
for i = 4:4
    for j = 1:5
        plot(squeeze(cdfRanges(i,j,:))/max(cdfRanges(i,j,:)),[0 squeeze(azPatternCDFs(i,j,:)).'],'DisplayName',[num2str(i) ' elements, ' num2str(j*3) ' dB Atten.']);
    end
end

legend(gca,'show')
