function [ distance ] = euclideanDistance( point1, point2 )
%EUCLIDEANDISTANCE Returns a scalar distance between the two points passed as [x y] coordinate pairs

distance = sqrt((point1(1)-point2(1))^2 + (point1(2)-point2(2))^2);

end

