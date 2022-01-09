function [x] = CMMP_1(A,b) %functia CMMP ia drept input Matricea argumentelor si vectorul coloana al rezultatelor;
[m,n] = size(A);            %m va avea drept valoare dimensiunea pe linii a matricii A, iar n dimensiunea pe coloane a matricii A;
[R,U,beta] = TORT_1(A);       %pentru a rezolva mai usor problema CMMP voi folosi tr.ortognoala pentru a rezolva aceeasi problema insa pentru o matrice drept triunghiulara;
%calculul vectorului coloana al rezultatelor care il suprascrie pe cel initial:
for k=1:n
    s=0;
    for i=k:m
        s = s+U(i,k)*b(i,1);
    end
    tau = s/beta(1,k);
    for i=k:m
        b(i,1) = b(i,1) -tau*U(i,k);
    end
end
%Am modificat vectorul rezultatelor, iar sistemul ramas este unul de tip U*x =
%b;unde U este o matrice superior triunghiulara, iar b este noul vector de
%rezultate; astfel voi aplica UTRIS, iar cmmp este gata, solutia sistemului
%fiind x;
x=UTRIS_1(R(1:n,:),b(1:n,1));
end



