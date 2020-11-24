clear
clc

IniEng=0.5;%0.5; % Initial Energy of Every Node
NetSize=200; % Network Size
NoOfNode=200; % Number of Node
NoOfRound=2000; % Number of Round
cluster_head_percentage=0.1;

[STATISTICS1,FD1,TD1,AD1]=leach(IniEng,NetSize,NoOfNode,NoOfRound,cluster_head_percentage);%% Leach
[STATISTICS2,FD2,TD2,AD2]=Leach_Centralized(IniEng,NetSize,NoOfNode,NoOfRound,cluster_head_percentage); %% Centralized Leach
% [STATISTICS3,FD3,TD3,AD3]=TSILEACH(IniEng,NetSize,NoOfNode,NoOfRound,cluster_head_percentage); %% Improved Leach IICT, BUET


r=0:NoOfRound;

 
plot(r,STATISTICS1.DEAD,'k:',r,STATISTICS2.DEAD,'m-','LineWidth',2);
legend('LEACH','LEACH-C','Location','SouthEast');
xlabel('x(time)');
ylabel('No of Dead Nodes');
title('No of Allive Nodes Over Time');
 
figure
plot(r,STATISTICS1.ALLIVE,'k:',r,STATISTICS2.ALLIVE,'m-','LineWidth',2);
legend('LEACH','LEACH-C');
xlabel('x(time)');
ylabel('No of Allive Nodes');
title('No of Dead Nodes Over Time');
 
figure;
plot(r,STATISTICS1.PACKETS_TO_BS,'k:',r,STATISTICS2.PACKETS_TO_BS,'m-','LineWidth',2);
legend('LEACH','LEACH-C','Location','SouthEast'); 
xlabel('x(time)');
ylabel('No of Packets');
title('Number of packets send to Sink Node');

figure;
plot(r,STATISTICS1.TotalEnergy,'k:',r,STATISTICS2.TotalEnergy,'m-','LineWidth',2); 
xlabel('x(time)');
ylabel('Total Energy of Network in (Joule)');
title('The total Remaining Energy of the System in (J)');

figure;
bargraph=[FD1,FD2;TD1,TD2;AD1,AD2]; 
bar(bargraph,'group');
legend('LEACH','LEACH-C','Location','NorthWest'); 
title('The Time when First node die, Tenth node die and All nodes die');
xlabel('FIRST DEATH              TENTH DEATH              ALL DEATH');
ylabel('Number of rounds');



