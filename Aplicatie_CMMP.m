function varargout = Aplicatie_CMMP_1(varargin)


    %Am folosit GUIDE pentru a genera interfata grafica pentru aplicatia
    %din proiect, mai jos este facuta initializarea, Atunci cand cineva
    %foloseste GUIDE, codul din spatele aplicatiei se va genera automat,
    %insa pot modifica codul pentru a extinde functionalitatile, aceste
    %functii noi introduse se numes call_back_functions;
    
% Last Modified by GUIDE v2.5 20-Jan-2022 18:56:40

%intre comentariile DO_NOT_EDIT este codul de initializare al GUI-ului;

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Aplicatie_CMMP_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Aplicatie_CMMP_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%codul de mai jos centreaza GUI-ul si pune titlul cu continutul de mai jos
function Aplicatie_CMMP_1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);
movegui('center')
title('Aproximarea unui sistem cu un model matematic de tip ARX')



% --- Outputs from this function are returned to the command line.
function varargout = Aplicatie_CMMP_1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)


%urmatoarea functie seteaza fontul aplicatiei


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

%urmtoarea functie aplica editarile facute de mine IN GUIDE din funtia anterioara;


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Se executa la apasarea butonului 2.
function pushbutton1_Callback(hObject, eventdata, handles)

[file,path] = uigetfile('*.mat')

 S=load(file); %loadeaza un fisier cu extensia .mat care contine 2 semnale
               %cu 81 de intrari fiecare, unul fiind cel de intrare(u),
               %celalalt cel de iesire(y); si o variabila care reprezinta
               %timpul final al simularii(tf);
 y=S(1,1).y.y    %initializarea semnalului de iesire
 u=S(1,1).u.u    %initializarea semnalului de intrare
 tfinal=S(1,1).tf %initializara timpului final pt simulare;
mas=size(y,1)     %nr de samplari e de dim 81;


%WHITE NOISE ~zgomotul

er=randn(mas,1) %se genereaza random un vector normat ce reprezinta zgomotul 
e = iddata([],er) %se converteste vectorul la un obiect de tip iddata


%mai departe este scris codul pentru a plota semnalul de iesire in functie
%de timp cu un pas setat;
pas=tfinal/(mas-1)
t=0:pas:tfinal
 plot(t,y,'r');
 hold on
 
n=mas; %numarul de masuratori = dim(u&y);

%pentru ca algoritmul sa functioneze, cand na e diferit de 0, nb trebuie
%sa fie mai mic sau egal decat na, cand na=0, nu se mai tine cont;
%unde na va fi nr de parametri pentru iesire, iar nb nr de parametri pentru
%intrare;

%preluarea valorilor din casutele editabile din interfata grafica
nb=str2num(get(handles.edit2,'string'));
na=str2num(get(handles.edit1,'string')); 

%primul caz, cand na=0, iar sistemul nu este autoregresiv;
if na==0                        
 d=u;
A=zeros(n-nb+1,nb);                     %calculez matricea A, phi in documentatie, avand valorile intrarilor;
for i=1:n-nb+1
    for j=1:nb
        A(i,j)=d(nb-j+i);
    end
end
b=y(nb:n);
er1=er(nb:n);       %initializarea vectorului de erori ajustat la nr de coef;

x=CMMP_1(A,b-er1);  %rezolv sistemul si aflu coeficientii modelului folosinf metoda CMMP_1, (din vectorul de rezultate scad eroarea)
b=x;
m0 = idpoly([1] ,x');     %creez un model polinomial pentru modelul ARX;
u = iddata([],u,1);     
end


if na>0 %cazul in care sistemul este autoregresiv; depinde atat de intrari cat si de iesirile anterioare
c=y;        %copiez intrarile si iesirile pentru a nu le modifica in alg
d=u;

n=size(c,1)         %n, nr liniilor din vectorul coloana c;
for i=1:n-na
    
b=c(n-i+1);
end
                    %aflu matricile A1 si A2 pentru a afla matricea
                    %sistemului prin concatenarea lor;
A1=zeros(n-na,na);
for i=1:n-na
    for j=1:na
        A1(i,j)=-1*c(n-i-j+1);  %matricea cu val iesirilor
    end
end
A2=zeros(n-na,nb);
for i=1:n-na
    
    for j=1:nb
        n-j-i+2;
        A2(i,j)=d(n-j-i+2);    %vectorul cu valorile intrarilor
    end
end

b=c(na+1:n);    %initializez vectorul de iesiri;


for i=1:n-na
    er1(i)=er(n-i+1); %vectorul de erori ajustat;
    
end
A=[A1 A2];      %am aflat matricea cu valorile intrarilor si iesirilor;

x=CMMP_1(A,b-er1')          %Linia asta e echivalenta cu x=A\(b-er1')   
   
 a=x(1:na); %vectorul paramatrilor care sund asociati iesirilor;
 b2=x(na+1:size(x,1)) %vectorul parametrilor care sunt asociati intrarilor
 m0 = idpoly([1 a'],b2');       %initializez modelul polinomial pentru solutia gasita
 b=b2;
u = iddata([],u,1); 
end


y1 = sim(m0,[u,e] ); %simulez iesirea aproximata prin CMMP_1
get(y1);
 plot(t,y1.y,'--')   %reprezentarea grafica a noii iesiri
if handles.radiobutton1.Value == 1
  hold on
  
 z = [S(1,1).y,u];
 
mm = arx(z,[na+1 nb 0])         %Simulez cu functia specializata arx iesirea;
y2=sim(mm,u);
y2.y
plot(t,y2.y,'g')
 legend('y_{sistem}','y_{aproximat}','y_{arx}');
 else
     legend('y_{sistem}','y_{aproximat}');
 end
 
 hold off
 
 %Am repreentat pe acelasi grafic iesirea data, iesirea simulata prin
 %modelul ARX implementat de mine si de cel obtinut prin functia
 %specializata ARX din matlab;
 
 
 %afisarea formulei matematice a modelului aproximat , precum si a
%coeficientilor aflati cu algoritmul CMMP_1
 
model='y(t)=';
msg='';
for i=1:na
  mm=strcat('a',num2str(i),'*y(t-', num2str(i),')+');
  model=strcat(model,mm);
  msg=strvcat(msg,sprintf('a%d=%d',i,a(i)));
end
  model=strcat(model,'b1*u(t)');
  msg=strvcat(msg,sprintf('b1=%d',b(1)));
  if nb~=1              %verific daca nb este egal sau nu cu 1;
      model=strcat(model,'+');
  end
for i=2:nb
    mm=strcat('b',num2str(i),'*u(t-', num2str(i-1),')');
  model=strcat(model,mm);
  msg=strvcat(msg,sprintf('b%d=%d',i,b(i)));
  if  i<nb
      model=strcat(model,'+');
  end
end

        %Am terminat de afisat modelul matematic care aproximeaa sistemul
        %SISO folosind CMMP si valorile aflate pentru coeficientii
        %modelului//in msg am pus coeficientii, in model functia;
 handles.text2.String = {'Aproximarea sistemului cu un model matematic de tip';'';model;'';msg};
 %title('aproximarea sistemului cu un model matematic de tip y(t)=b1*u(t)+b2*u(t-1)+b3*u(t-2)')
drawnow;



% --- Executes on button press in pushbutton1.
%mai jos am implementat acelasi lucru ca mai sus, insa in acest caz,
%utilizatorul a ales sa genereze 2 semnale random;
%se executa cand se apasa butonul 1
function pushbutton3_Callback(hObject, eventdata, handles)

mas=80 %masuratori
%se genereaza o intrare random binary si o functie de transfer cu 3 poli
u = iddata([],idinput(mas,'rbs'));
er=randn(mas,1)
e = iddata([],er);
np=3;
tfinal=2.5
pas=tfinal/(mas-1)
H=rss(np) %generarea random a functiei de transfer
t=0:pas:tfinal
y=sim(idpoly(H),[u,e]) %se simuleaza modelul iddata in vederea obtinerii iesirii


 plot(t,y.y,'r'); %se ploteaza iesirea sistemului generat random
 hold on
n=mas
nb=str2num(get(handles.edit2,'string'));
na=str2num(get(handles.edit1,'string'));
get(y)
  get(u)
if na==0
 d=u.u

A=zeros(n-nb+1,nb);
for i=1:n-nb+1
    for j=1:nb
        A(i,j)=d(nb-j+i);
    end
end
b=y.y(nb:n);
er1=er(nb:n);
x=CMMP_1(A,b-er1) %x=A\(b-er1);
m0 = idpoly(1 ,x');
b=x;
end
if na>0
c=y.y
d=u.u
n=size(c,1)
for i=1:n-na
    
b=c(n-i+1);
end

A1=zeros(n-na,na);
for i=1:n-na
    for j=1:na
        A1(i,j)=-1*c(n-i-j+1)
    end
end
A2=zeros(n-na,nb);

for i=1:n-na
    for j=1:nb
        n-j-i+2
        A2(i,j)=d(n-j-i+2);
    end
end

b=c(na+1:n);


for i=1:n-na
    er1(i)=er(n-i+1)
    
end


A=[A1 A2]
 x=CMMP_1(A,b-er1')%x=A\(b-er1')   
 a=x(1:na);
 b2=x(na+1:size(x,1));
 m0 = idpoly([1 a'],b2');
 b=b2;

end

y1 = sim(m0,[u,e] );

get(y1);
 plot(t,y1.y,'--')  

   hold on
 if handles.radiobutton1.Value == 1
  %y = iddata([],y,1);

 z = [y,u];
mm = arx(z,[na+1 nb 0]);
y2=sim(mm,u);

plot(t,y2.y,'g')
 legend('y_{sistem}','y_{aproximat}','y_{arx}');
 else
     legend('y_{sistem}','y_{aproximat}');
 end
 hold off
 
model='y(t)=';
msg='';
for i=1:na
  mm=strcat('a',num2str(i),'*y(t-', num2str(i),')+');
  model=strcat(model,mm);
  msg=strvcat(msg,sprintf('a%d=%d ',i,a(i)));
end

  model=strcat(model,'b1*u(t)');
  msg=strvcat(msg,sprintf('b1=%d',b(1)));
  if nb~=1
      model=strcat(model,'+');
  end
for i=2:nb
    mm=strcat('b',num2str(i),'*u(t-', num2str(i-1),')');
  model=strcat(model,mm);
  msg=strvcat(msg,sprintf('b%d=%d ',i,b(i)));
  if  i<nb
      model=strcat(model,'+');
  end
end

 handles.text2.String = {'Aproximarea sistemului cu un model matematic de tip';'';model;'';msg};
 drawnow;
 
 
 
 %cod pentru iesirea din aplicatie;

% --- Executes on button press in pushbutton3.
function pushbutton2_Callback(hObject, eventdata, handles)

close all
    
%metode generate automat cand am initializat GUI si l-am customizat prin
%GUIDE;

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text2.
function text2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
