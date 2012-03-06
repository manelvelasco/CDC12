syms s
a=[0 1;0 0]
b=[0;1]
h=1
tau=0.01
n=size(a,2)


%controlador sin atrasos
polos=[0.5 -0.5];
[Ad Bd]=c2d(a,b,h);
K=-acker(Ad,Bd,polos);

Phid=Ad+Bd*K

%Modelo complejo


digits(4)

A=expm(a*h)
B1=expm(a*(h-tau))*int(expm(a*s),s,0,tau)*b
B2=int(expm(a*s),s,0,h-tau)*b


phi=[A B1;zeros(1,size(A,2)) 0]
gamma=[B2;1]

phi=double(vpa(phi))
gamma=double(vpa(gamma))

%L=-acker(phi,gamma,polos)
L=[K 0]
phi_cl=phi+gamma*L
eig(phi_cl)
COEFA=eye(n)
COEFB= -(A+B2*L(1:n))
COEFC= -(B1*L(1:n))
%polinomio
pol=vpa([COEFA COEFB COEFC ])

%Modelo en lazo cerrado del sistema con atrasos

I=eye(n);
Z=zeros(n,1);
S=[I Z];
P=[Z' 1 ; I Z];
[M E]=eig(phi_cl);
k=1;
Solucion_ecuacion=(S*M*P^k*S')*S*(M*P^k)^(-1)*phi_cl*(M*P^k)*S'*(S*M*P^k*S')^(-1)
Solucion_ecuacion_test=S*(M*P^k)^(-1)*phi_cl*(M*P^k)*S'
%Check for the model

vpa(COEFA*Solucion_ecuacion^2+COEFB*Solucion_ecuacion+COEFC,4)

%Simulación del sistema

[M_ E_]=eig(Solucion_ecuacion)
Matriz_cambio=M*S'*M_^(-1)

F=S*M*S'*M_^(-1);
Solucion_ecuacion=F*Solucion_ecuacion*F^(-1)

x_sis_comp=F^(-1)*[10;10];
estados_complejos=[x_sis_comp];
for j=0:10
  x_sis_comp=Solucion_ecuacion*x_sis_comp;
  estados_complejos=[estados_complejos x_sis_comp];
end

estados_reales=Matriz_cambio*estados_complejos;

estados_teoricos=zeros(3,5);
x_sis_amp=estados_reales(:,5);
for j=1:5
  x_sis_amp=phi_cl*x_sis_amp;
  estados_teoricos=[estados_teoricos x_sis_amp];
end

