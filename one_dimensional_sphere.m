clear;
%% �������ߣ�
% ��������2010011732��
% ����ϵ��01��
% sunxb10@gmail.com
% Nov.16th, 2013
%% ���������
N = 8;  % S_N���ƵĽ���
K = 50*N; % ��r�����������
tol = 1e-8;  % �ж�S_N������������ֵ
%% �����ֵ��
sigma_t = 0.050; % ��۽�������(cm^(-1))
sigma_s = 0.030;
nusigma_f = 0.0225;
R = 145.5436;  % ��İ뾶(cm)
delta = R/K;  % ��ֲ���
mu = zeros(2*N+1,1);
wt = zeros(2*N+1,1);
[mu(2:2:2*N),wt(2:2:2*N)] = getGaussianQuadTuple(N);  % ����mu_{m}��wt_{2m}
mu(1:2*N:2*N+1) = [-1,1];
mu(3:2:2*N-1) = 0.5*(mu(2:2:2*N-2)+mu(4:2:2*N));
r = [0:delta/2:R]; % ����r_{k}
A = zeros(2*K+1,1);
A(1:2:2*K+1)=r(1:2:2*K+1).^2; % ����A_{2k+1}
V = zeros(2*K,1);
V(2:2:2*K)=(1/3)*(r(3:2:2*K+1).^3-r(1:2:2*K-1).^3); % ����V_{2k}
alpha = zeros(2*N+1,1);
for i = 1:N
   alpha(2*i+1) = alpha(2*i-1) - mu(2*i)*wt(2*i);  % ����alpha_{2m+1}
end
E = zeros(2*K,2*N);
E(2:2:2*K,2:2:2*N) = (A(1:2:2*K-1)+A(3:2:2*K+1))*abs(mu(2:2:2*N))'; % ����E_{2k,2m}
G = zeros(2*K,2*N);
G(2:2:2*K,2:2:2*N) = (A(3:2:2*K+1)-A(1:2:2*K-1))*((alpha(3:2:2*N+1)+alpha(1:2:2*N-1))./wt(2:2:2*N))'; % ����G_{2k,2m}
bad_grid = 1;  % bad_grid�ǵ���ǰ������tol�Ľڵ㣬��ʼ��Ϊ1
cycle_count = 0; % ͳ��ѭ����������
Psi = zeros(2*K+1,2*N+1); % ���ӽ�ͨ����ֵ
src = 1e13*ones(2*K,1); % Դ��
keff = ones(2*K,1); % ��Ч��ֳϵ��
Phi = zeros(2*K,1); % ����ͨ��
old_Phi = 1e13*ones(2*K,1);

%% �������㣺
t_Start = tic; % MATLAB��ʱ���
% �����ľ��幫ʽ����ı�����д��˵���ĵ�������һά���������S_Nģ���MATLABʵ��.pdf
while(bad_grid > 0)
    % mu = -1
    for k = K:(-1):1
        Psi(2*k,1) = (V(2*k)*src(2*k)+(A(2*k+1)+A(2*k-1))*Psi(2*k+1,1))/(A(2*k+1)+A(2*k-1)+sigma_t*V(2*k));
        Psi(2*k-1,1) = 2*Psi(2*k,1) - Psi(2*k+1,1);
    end
    % mu < 0
    for m = 1:(N/2)
        for k = K:(-1):1
            Psi(2*k,2*m) = (V(2*k)*src(2*k)+E(2*k,2*m)*Psi(2*k+1,2*m)+G(2*k,2*m)*Psi(2*k,2*m-1))/(E(2*k,2*m)+G(2*k,2*m)+sigma_t*V(2*k));
            if(Psi(2*k,2*m) < 0)
                Psi(2*k,2*m) = 0;
            end
            Psi(2*k-1,2*m) = 2*Psi(2*k,2*m) - Psi(2*k+1,2*m);
            if(Psi(2*k-1,2*m) < 0)
                Psi(2*k-1,2*m) = 0;
            end
            Psi(2*k,2*m+1) = 2*Psi(2*k,2*m) - Psi(2*k,2*m-1);
            if(Psi(2*k,2*m+1) < 0)
                Psi(2*k,2*m+1) = 0;
            end
        end
    end
    % mu > 0
    for m = (N/2+1):N
        Psi(1,2*m) = Psi(1,2*N+2-2*m); % ���ĶԳ�����
        for k = 1:K
            Psi(2*k,2*m) = (V(2*k)*src(2*k)+E(2*k,2*m)*Psi(2*k-1,2*m)+G(2*k,2*m)*Psi(2*k,2*m-1))/(E(2*k,2*m)+G(2*k,2*m)+sigma_t*V(2*k));
            if(Psi(2*k,2*m) < 0)
                Psi(2*k,2*m) = 0;
            end
            Psi(2*k+1,2*m) = 2*Psi(2*k,2*m) - Psi(2*k-1,2*m);
            if(Psi(2*k+1,2*m) < 0)
                Psi(2*k+1,2*m) = 0;
            end
            Psi(2*k,2*m+1) = 2*Psi(2*k,2*m) - Psi(2*k,2*m-1);
            if(Psi(2*k,2*m+1) < 0)
                Psi(2*k,2*m+1) = 0;
            end
        end
    end
    % ����Դ��
    src(2:2:2*K) = (sigma_s + nusigma_f)/2*Psi(2:2:2*K,2:2:2*N)*wt(2:2:2*N);
    % ����Ƿ�ﵽ����Ҫ��
    bad_grid = 0;
    for k = 1:K
        Phi(2*k) = Psi(2*k,2:2:2*N)*wt(2:2:2*N);  % ���ݽ�ע���ʼ���ע���ʣ���˹���֣�
        keff_temp = Phi(2*k)/old_Phi(2*k);  % ���㵱ǰ������Ч��ֵϵ��
        if(abs((keff_temp-keff(2*k))/keff(2*k))>=tol)  % ������Ч��ֵϵ�����ж��Ƿ�ﵽҪ��
           bad_grid = bad_grid + 1;
        end
        keff(2*k) = keff_temp;
    end
    old_Phi = Phi;
    cycle_count = cycle_count + 1;
end
elapsed_time = toc(t_Start); % MATLAB��ʱ���

%% �����������
fp = fopen('1D_sphere_outputs.txt','wt');
fprintf(fp,'��Ч��ֵϵ����ƽ��ֵ���� %.8g\n',mean(keff(2:2:2*K)));
fprintf(fp,'��Ч��ֵϵ�������ֵ���� %.8g\n',max(keff(2:2:2*K)));
fprintf(fp,'��Ч��ֵϵ������Сֵ���� %.8g\n',min(keff(2:2:2*K)));
fprintf(fp,'ѭ�������ܴ����� %d\n',cycle_count);
fprintf(fp,'ѭ��������ʱ���� %.3g s\n\n\n',elapsed_time);
fprintf(fp,'************************************\n');
fprintf(fp,'*           ����ͨ��У��           *\n');
fprintf(fp,'************************************\n');
Phi_center = Phi(2); % ����ͨ��
fprintf(fp,'   У���λ��           ģ����\n');
fprintf(fp,'  ��RΪ��뾶��     ������ͨ����һ��\n');
fprintf(fp,'------------------------------------\n');
fprintf(fp,'     0.25R             %.9g\n',Phi(uint32(0.25*R/(delta/2)))/Phi_center); % ������ͨ����һ
fprintf(fp,'     0.50R             %.9g\n',Phi(uint32(0.50*R/(delta/2)))/Phi_center);
fprintf(fp,'     0.75R             %.9g\n',Phi(uint32(0.75*R/(delta/2)))/Phi_center);
fprintf(fp,'     1.00R             %.9g\n',Phi(uint32(1.00*R/(delta/2)))/Phi_center);
fclose(fp);

%% ��������ͨ���ֲ�����
plot(r(2:2:2*K),Phi(2:2:2*K),'-r','linewidth',1.5);
xlabel('$r$','FontSize',16,'Interpreter','latex','FontWeight','bold');
ylabel('Fluence Rate $\phi$','FontSize',16,'Interpreter','latex','FontWeight','bold');
print('-depsc2','1D_sphere_neutron_flux.eps'); % ������ͨ���ֲ����ߴ���PDF�ļ�����