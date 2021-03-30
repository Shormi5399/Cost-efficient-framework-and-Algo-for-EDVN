function N = EDI(M)
%EDI:Embedding Desity Index
%   input       - M: Substrate Matrix
%   output      - N: the EDI


[nR, nC] = size(M);
N = 0;

for r =1:nR
    for c =1:nC
        if(M(r, c)~=0)
            M(r, c) = 1;
            if(r>1)
            N = N + xor(M(r-1,c), M(r, c));
            end        
            if(r< nR)
            N = N + xor(M(r+1,c), M(r, c));
            end
            if(c>1)
                N = N + xor(M(r,c-1), M(r, c));
            end
            if(c<nC)
                N = N + xor(M(r,c+1), M(r, c));
            end
        end
    end

end

