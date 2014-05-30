% Velocity form of Transfer function
% Just simulate the Motor itself - so don't include D/A Gain & Encoder Gain
numvs = [0 0 Kt*Ka]
denvs = [(La*Jt) (Ra*Jt + La*b) (Ra*b+Kb*Kt)]
syssv = tf(numvs,denvs)

Polesv = pole(syssv)/(2*pi) % to turn from radian roots frequency roots

% Calculate the systems frequency response
i=i+1;
figure(i)
bode(syssv)
grid on
titlestring = ['TF - Bode Plot of Open Loop Velocity System, Rd = ',num2str(rd),' m'];
title(titlestring);


% Calculate Root Locus of the open loop velocity system
i=i+1;
figure(i)
sgrid
% subplot(2,1,1),
rlocus(syssv);
titlestring = ['TF - Root Locus of Open Loop Velocity System, Rd = ',num2str(rd),' m'];
title(titlestring);
sgrid(.5,0)
sigrid(10)


i=i+1;
figure(i)
[w,t] = step(stepsize*syssv);
w = w*60/(2*pi); % Revs /min
% w = w/(2*pi);    %revs /sec
% subplot(2,1,2),
plot(t,w)
xlabel('Time (seconds)')
ylabel('Velocity (Rev/Min)')
titlestring = ['TF - Open Loop Angular Velocity Step Response, Rd = ',num2str(rd),' m'];
title(titlestring)
grid on
