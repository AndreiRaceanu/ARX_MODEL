function [x] = UTRIS_1(R,b)         
    n = size(R,1);
    x = zeros(n,1);
    for i = n:-1:1      %iterez prin fiecare linie de la sfarsit la inceput
        s= b(i,1);              %suma are initial valoarea asociata din vectorul de rezultate 
        for k=i+1:n             %iterez prin elementele la dreapta celui dorit sa fie aflat pentru a le elimina din suma
            s=s-R(i,k)*x(k,1);
        end
        x(i,1) = s/R(i,i);          %valoarea dorita este suma ramasa impartita la coeficientul din matricea U corespunzator;
    end
end