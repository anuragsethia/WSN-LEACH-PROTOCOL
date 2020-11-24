function [STATISTICS1,FD1,TD1,AD1]=leach(IniEng,NetSize,NoOfNode,NoOfRound,cluster_head_percentage)


xm=NetSize;
ym=NetSize;

sink.x=0.5*xm;
sink.y=1.35*ym;

n=NoOfNode;

p=cluster_head_percentage;

Eo=IniEng;%Initial energy
%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;
%Transmit Amplifier types
Efs=10*0.000000000001;
Emp=0.0013*0.000000000001;
%Data Aggregation Energy
EDA=5*0.000000001;

a=0;

rmax=NoOfRound;

do=sqrt(Efs/Emp);
do

figure(1) % 1

for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    %XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    %YR(i)=S(i).yd;
    S(i).G=0;
    S(i).E=Eo*(1+rand*a);
    %initially there are no cluster heads only nodes
    S(i).type='N';
     % 2
end
for i=1:1:n
%     figure(1);
    plot(S(i).xd,S(i).yd,'o');
    hold on;
end
S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x');
    
        
%First Iteration
figure(1);
countCHs=0;
cluster=1;
flag_first_dead=0;
flag_teenth_dead=0;
flag_all_dead=0;

dead=0;
first_dead=0;
teenth_dead=0;
all_dead=0;

allive=n;
%counter for bit transmitted to Bases Station and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
% figure(1);%3
for r=0:1:rmax     
    r
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            %S(i).cl=0; 
        end
    end
    hold off;
    figure(1);
    dead=0;
    for i=1:1:n
        if (S(i).E<=0)
            plot(S(i).xd,S(i).yd,'red .');
            
            dead=dead+1;  
            if (dead==1)
                if(flag_first_dead==0)
                    first_dead=r;
                    flag_first_dead=1;
                end
            end   
            if(dead==0.1*n)
                if(flag_teenth_dead==0)
                    teenth_dead=r;
                    flag_teenth_dead=1;
                end
            end
            if(dead==n)
                if(flag_all_dead==0)
                    all_dead=r;
                    flag_all_dead=1;
                end
            end
            hold on;
        end
        if S(i).E>0
            S(i).type='N';
            plot(S(i).xd,S(i).yd,'o'); % 4
            hold on;
        end
    end
    plot(S(n+1).xd,S(n+1).yd,'x'); %5
    
    STATISTICS.DEAD(r+1)=dead;
    STATISTICS.ALLIVE(r+1)=allive-dead;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TotalNetworkEnergy=0;
    for i=1:n
        if S(i).E>0
            TotalNetworkEnergy=TotalNetworkEnergy+S(i).E;
        end
    end
    STATISTICS.TotalEnergy(r+1)=TotalNetworkEnergy;
    STATISTICS.AvgEnergy(r+1)=TotalNetworkEnergy/n;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    countCHs=0;
    cluster=1;
    for i=1:1:n
        if(S(i).E>0)
            temp_rand=rand;     
            if ( (S(i).G)<=0)    
                if(temp_rand<= (p/(1-p*mod(r,round(1/p)))))
                    countCHs=countCHs+1;
                    packets_TO_BS=packets_TO_BS+1;
                    PACKETS_TO_BS(r+1)=packets_TO_BS;
                    S(i).type='C';
                    plot(S(i).xd,S(i).yd,'k*'); % 6
                    hold on;
%                     STATISTICS.CLUSTERHEAD(r+1) = C(cluster).id;
                    S(i).G=round(1/p)-1; %% Yeh raaz issi ke saath chala gaya
                    C(cluster).xd=S(i).xd; %% Print krna hai har round mein kitne CH bane 
                    C(cluster).yd=S(i).yd;
                    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
                    C(cluster).distance=distance;
                    C(cluster).id=i;
                    X(cluster)=S(i).xd; %% Ham kara skte hai cluster head se base station ka distance
                    Y(cluster)=S(i).yd;
                    cluster=cluster+1;
                    
                    distance;
                    if (distance>do)
                        S(i).E=S(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
                    end
                    if (distance<=do)
                        S(i).E=S(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
                    end
                end     
            end
        % S(i).G=S(i).G-1;  
        end 
    end
    for z = 1:1:cluster-1
        z;
        STATISTICS.clusterhead(z,(r+1)) = C(z).id;
        STATISTICS.clusterposition(z,2*(r+1)-1) = C(z).xd;
        STATISTICS.clusterposition(z,2*(r+1)) = C(z).yd;
%         STATISTICS.clusterposition_y(z,(r+1)) = ;
    end
    STATISTICS.COUNTCHS(r+1)=countCHs;
    %pause;
    
    for i=1:1:n
        if ( S(i).type=='N' && S(i).E>0 )
            if(cluster-1>=1)
                min_dis=Inf;
                min_dis_cluster=0;
                for c=1:1:cluster-1
                    temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
                    if ( temp<min_dis )
                        min_dis=temp;
                        min_dis_cluster=c;
                    end
                end 
                min_dis;
                if (min_dis>do)
                    S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
                end
                if (min_dis<=do)
                    S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
                end
                S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
                packets_TO_CH=packets_TO_CH+1;    
                S(i).min_dis=min_dis;
                S(i).min_dis_cluster=min_dis_cluster;
            else
                min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
                if (min_dis>do)
                    S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
                end
                if (min_dis<=do)
                    S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
                end
                packets_TO_BS=packets_TO_BS+1;
            end
        end
    end
    STATISTICS.PACKETS_TO_CH(r+1)=packets_TO_CH;
    STATISTICS.PACKETS_TO_BS(r+1)=packets_TO_BS;
hold on;
end
STATISTICS1=STATISTICS;
FD1=first_dead;
TD1=teenth_dead;
AD1=all_dead;
STATISTICS.DEAD(r+1);
STATISTICS.ALLIVE(r+1);
STATISTICS.PACKETS_TO_CH(r+1);
STATISTICS.PACKETS_TO_BS(r+1);
STATISTICS.COUNTCHS(r+1);




