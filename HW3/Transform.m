function Result = Transform(theInput, mode)
    % The input should be a matrix, and it has to be 400 by 400 for the
    % sake of this HW. 
    % Param: 
    %   mode 1: means it's matrix to block vector.
    %   mode 2: means it's block vector to matrix. 
    
    [M, N] = size(theInput);
    
    if mode == 1
        % The input is a 80 by 80 matrix, the center of the Fourier
        % space of the 400 by 400 image. 
        if M ~= 80 || N ~= 80
            error("The input matrix must be 400 by 400 for the sake of the HW. ");
        end
        Result = zeros(20, 20, 16);
        Counter = 1;
        for Row = 1:20:80
           for Col = 1:20:80
               Result(:, :, Counter) = theInput(Col: Col + 19, Row: Row + 19);
               Counter = Counter + 1;
           end
        end
        
    elseif mode == 2
        % The input is a vector with length 16, containing all the 20 by 20
        % blocks needed to reconstruct the original matrix, the 80 by 80
        % center fourier sequence. 
        [M, N, O] = size(theInput); 
        if ~(M == 20 && N == 20 && O == 16)
            error("Input wrong Dimension, it should be 20x20x16"); 
        end
        Result = zeros(80, 80);
        for Block = 0: 15
            I = mod(Block, 4); 
            J = int16(floor(Block/4));
            % disp(strcat("I: ", num2str(I), " J: ", num2str(J)))
            Result(I*20 + 1:I*20 + 20, J*20 + 1: J*20 + 20) = ... 
                theInput(:, :, Block + 1);
        end
    end
    
end