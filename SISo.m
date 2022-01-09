clear
R=0.4753716352;
L=0.4687172071;
Km=0.5155460393;
Kf=0.09507507404;
Kb=1.057240125;
J=0.01974944493;
K= 1.913232025;
T=0.09167217435;
p1=[L R];
p2=[J Kf]; 
inmul=conv(p1,p2);
p3=[0 0 Km*Kb];
inmul=inmul+p3;
p4=[T 1];
numitor=conv(inmul,p4);
G=tf(Km*K,numitor) ;
t=0:1:80
tt = 0:1e-2:0.8;
%u = heaviside(tt);
% u = iddata([],idinput(size(tt,2),'rbs'));
% u = iddata([],idinput(size(tt,2),'rgs'));
 u = iddata([],idinput(size(tt,2),'sine'));
er=randn(size(tt,2),1)
e = iddata([],er);
%u = iddata([],u,1e-3);
y=sim(idpoly(G),[u,e])

%y = sim(idpoly(G),u);
% y=lsim(G,u,tt)
%  u=u.u
% y=y.y
tf=tt(size(tt,2))
size(tt,2)
save('siso','u','y','tf')
