clear;
clc;

P = sdpvar(2, 2);
F = sdpvar(2, 1);

A = [0 1; -2 -3];
C = [1 0];

alpha = 0;

s11 = P*A + A'*P + F*C + C'*F' + 2*alpha*P;
s12 = zeros(2, 2);
s22 = -eye(2);

LMI1 = [s11 s12; s12' s22];
LMI2 = P;

cons = [LMI1 <= 0; LMI2 >= 0];

solvesdp(cons)


pe = double(P)
f = double(F)

eig(pe)

Lo = -inv(pe)*f