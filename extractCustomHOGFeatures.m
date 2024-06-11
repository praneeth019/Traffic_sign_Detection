function features = extractCustomHOGFeatures(image)
    % Convert image to grayscale
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    % Image dimensions
    [rows, cols] = size(image);
    
    % Parameters
    cellSize = 8;
    numBins = 9;
    angleUnit = 180 / numBins;

    % Precompute some values
    angles = (0:numBins-1) * angleUnit;
    features = [];

    % Calculate gradients
    [Gx, Gy] = imgradientxy(image, 'sobel');
    [Gmag, Gdir] = imgradient(Gx, Gy);

    % Adjust gradient directions to be positive
    Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;

    % Processing each cell
    for i = 1:cellSize:rows-cellSize+1
        for j = 1:cellSize:cols-cellSize+1
            % Cell boundaries
            cellMag = Gmag(i:i+cellSize-1, j:j+cellSize-1);
            cellDir = Gdir(i:i+cellSize-1, j:j+cellSize-1);
            
            % Histogram of orientations
            cellHistogram = zeros(1, numBins);
            for bin = 1:numBins
                % Logical array for directions within the bin
                angleLow = angles(bin) - angleUnit/2;
                angleHigh = angles(bin) + angleUnit/2;
                angleMask = (cellDir >= angleLow) & (cellDir < angleHigh);
                
                % Weight histogram by gradient magnitude
                cellHistogram(bin) = sum(cellMag(angleMask));
            end
            
            % Append cell histogram to feature vector
            features = [features, cellHistogram];
        end
    end
end
