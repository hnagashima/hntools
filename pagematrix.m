classdef pagematrix < double
    % A class for multiplication of multipage matrices.
    %
    % Example:
    % In general, matrix times for multipage matrices need to be wrote as
    % followings.
    % 
    % a = rand(100,100,100); b = rand(100,100,100);
    % for k = 1:size(100)
    %   c(:,:,k) = a(:,:,k)*b(:,:,k);
    % end
    % 
    % Using this class, the following script is equivalent and faster.
    % a = rand(100,100,100); b = rand(100,100,100);
    % A = pagematrix(a); B = pagematrix(b);
    % C = A * B;
    % 
    % 
    % Function
    % mtimes
    % 
    % 
    %
    methods
        function C = mtimes(objA,objB)
            A = double(objA);
            B = double(objB);
            C = mtimesx(A,B);
            pagematrix(C);
        end
    end
    
    
    %% For test this matrix.
    methods (Static)
        function test(~)
            %% Test1
            sz = randi(1000);
            disp(['Matrix size is ' num2str(sz)]);
            a = rand(sz,sz,2); b = rand(sz,sz,2);
            
            tic;
            c = zeros(sz,sz,2);
            for k = 1:size(a,3)
                c(:,:,k) = a(:,:,k)*b(:,:,k);
            end
            toc;
            
            tic;
            A = pagematrix(a); B = pagematrix(b);
            C = A * B;
            toc;
            if ~isequal(C,c)
                error('calculation is wrong!');
            else
                disp('Test1 passed');
            end
            
            %% test2
            sz = randi(1000);
            disp(['Matrix size is ' num2str(sz)]);
            a = rand(sz,sz,2); b = rand(sz,sz,2); c = rand(sz,sz,2);
            
            tic;
            d = zeros(sz,sz,2);
            for k = 1:size(a,3)
                d(:,:,k) = a(:,:,k)*b(:,:,k)*c(:,:,k);
            end
            toc;
            
            tic;
            A = pagematrix(a); B = pagematrix(b); C = pagematrix(c);
            D = A * B * C;
            toc;
            if ~isequal(d,D)
                error('calculation is wrong!');
            else
                disp('Test2 passed');
            end
            
            
            
        end
    end
    
end