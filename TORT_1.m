function [A,U, beta] = TORT_1(A)
[m,n] = size(A);                %pentru a obtine matricea superior triunghiulara voi folosi reflectorii householder;
U = zeros(m,m);
if n < m-1                      %vreau sa aflu dimensiunea vectorului coloana beta;
    p = n;
else
    p = m-1;
end
beta = zeros(1,p);
for k=1:p
    s =0;
    for i=k:m
        s = s+ (A(i,k))^2;
    end
    if sign(A(k,k))>=0
    sig = sqrt(s);
    else
    sig = (-1) * sqrt(s);
    end
    if sig==0
        beta(1,k) = 0;
    else
         U(k,k)=A(k,k)+sig; %incep calcularea vectorului householder
         beta(1,k) = sig* U(k,k); % si scalarul asociat;
         for i=k+1:m
             U(i,k) = A(i,k);
         end
         A(k,k) = (-1)* sig;        %modific si intrarile lui A pe masura ce calculez vectorii coloana si scalarii folositi pentru reflector, pentru a ajunge la forma sa finala;
         for i=k+1:m
             A(i,k) = 0;
         end
         for j=k+1:n
             s=0;
             for i=k:m
                 s=s+U(i,k)*A(i,j);
             end
             tau=s/beta(1,k);
             for i=k:m
                 A(i,j) =A(i,j) - tau*U(i,k);
             end
         end
    end
end
end

    

