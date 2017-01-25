% Perform simulations to plot the first-contact distribution of a random
% network using a PPP as its ground process.

origin = [0 0];

noNetworkInstances = 20;

noAlohaInstances = 1000;

nodeDensity = 1;    % units are users per square unit distance

contactDistance = zeros(1,noInstances);
contactDirection = zeros(1,noInstances);

networkRadius = 8;

tic;

for networkInstanceIndex = 1:noNetworkInstances

    [nodeLocation, nodeDirection] = createRandomNetwork(networkRadius,nodeDensity,'disc');   

    for alohaProbabilityIndex = 1:20

        for instanceIndex = 1:noInstances

            [thinnedLocation,thinnedOrientation] = thinNetwork(nodeLocation,nodeDirection,0.05*alohaProbabilityIndex,0);

            if isempty(thinnedLocation)

                contactDistance(instanceIndex) = NaN;

            else

                [thinnedLocation,~] = sortNetwork(thinnedLocation,thinnedOrientation,origin);

                contactDistance(instanceIndex) = euclideanDistance(origin,thinnedLocation(1,:)); 

            end

        end

        collectedContactDistance(networkInstanceIndex,alohaProbabilityIndex) = mean(contactDistance);

    end
    

end

for alohaProbabilityIndex = 1:20
    
    calculatedAverageContactDistance(alohaProbabilityIndex) = 1/(2*sqrt(nodeDensity*0.05*alohaProbabilityIndex));

    averageContactDistance(alohaProbabilityIndex) = mean(collectedContactDistance(:,alohaProbabilityIndex));
    
end

toc;

plot(0.05*[1:20],calculatedAverageContactDistance,'DisplayName',['Calculated Average Contact Distance']);

hold on;
    
plot(0.05*[1:20],averageContactDistance,'DisplayName',['Simulated Average Contact Distance']);

xlabel('ALOHA Transmission Probability');
ylabel('Distance (m)');

legend(gca,'show','Location','NorthEast');