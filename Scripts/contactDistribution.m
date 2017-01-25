% Perform simulations to plot the first-contact distribution of a random
% network using a PPP as its ground process.

origin = [0 0];

noInstances = 10000;

nodeDensity = 1;    % units are users per square unit distance

contactDistance = zeros(1,noInstances);
contactDirection = zeros(1,noInstances);

averageContactDistance = zeros(8,20);
calculatedAverageContactDistance = zeros(8,20);

tic;

for networkRadiusIndex = 1:6

    networkRadius = 8;

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

        averageContactDistance(networkRadiusIndex,alohaProbabilityIndex) = mean(contactDistance);
        calculatedAverageContactDistance(networkRadiusIndex,alohaProbabilityIndex) = 1/(2*sqrt(nodeDensity*0.05*alohaProbabilityIndex));

    end

end

toc;

plot(0.05*[1:20],calculatedAverageContactDistance(1,:),'DisplayName',['Calculated Average Contact Distance']);

hold on;

for networkRadiusIndex = 1:6
    
    plot(0.05*[1:20],averageContactDistance(networkRadiusIndex,:),'DisplayName',['Simulated Average Contact Distance (instance ' num2str(networkRadiusIndex) ')']);

end

xlabel('ALOHA Transmission Probability');
ylabel('Distance (m)');

legend(gca,'show','Location','NorthEast');