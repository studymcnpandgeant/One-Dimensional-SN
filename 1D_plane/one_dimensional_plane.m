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
a0 = 66.0053;  % ƽ�����(cm)
delta = a0/K;  % ��ֲ���
x = [0:delta:a0];
[mu,wt] = getGaussianQuadTuple(N);  % ��ȡ����飬�ڵ�mu��Ȩ��wt��Ԫ�سɶԳ��֣�����mu��Ԫ�ذ��ա�����������������˳�򽻴����У�ż��λ�ϵ�Ԫ�ؽ�Ϊ��
l = zeros(N,1);
keff = zeros(2*K+1,1);  % ��Ч��ֵϵ��
Phi = zeros(2*K+1,1);  % ����ע����
old_Phi = 100*ones(2*K+1,1);  % ����ǰ������ע���ʳ�ֵ��Ϊ10
src = 1e12*ones(2*K+1,N); % Դ���ֵ��Ϊ1e10
Psi = zeros(2*K+1,N);  % ���ӽ�ע����
bad_grid = 1;  % bad_grid�ǵ���ǰ������tol�Ľڵ㣬��ʼ��Ϊ1
cycle_count = 0; % ͳ��ѭ����������

% f��f_mu���ڴ����������ɢ�����⣨��Ҫ������ʵĵ�Чԭ������MA��
% % ɢ�亯�������õ�չ��
% f_mu =  @(mu) (sqrt(mu.^2+MA^2-1)+mu).^2./(2*MA*sqrt(mu.^2+MA^2-1));
% f = zeros(N,1,'double');
% for i= 1:N   
%     f(i) = myRomberg(@(mu) f_mu(mu).*myLegendre((i-1),mu),-1,1);
% end
% MatLegendre = getLegendreList(N,mu);  % ����ɢ�Ƕȵ����õº���ֵ������ǰ��ò�������MatLegendre�У���˿ɱ����ظ�����

%% �������㣺
t_Start = tic; % MATLAB��ʱ���
while(bad_grid > 0)
    % mu<0�Ĳ���
    for i = 1:(N/2)
        l(i) = delta*sigma_t/mu(i);
        Psi(2*K+1,i) = 0;  % �Ҳ���ձ߽�
        for k = K:(-1):1  % ��ǰ����
           Psi(2*k-1,i) = (2+l(i))/(2-l(i))*Psi(2*k+1,i)-2*l(i)/(2-l(i))*src(2*k)/sigma_t;
           Psi(2*k,i) = (Psi(2*k+1,i)+Psi(2*k-1,i))/2;
        end
    end
    % mu>0�Ĳ���
    for i = (N/2+1):N
        l(i) = delta*sigma_t/mu(i);
        Psi(1,i) = Psi(1,N+1-i);  % ���Գ�����
        for k = 1:K  % ������
           Psi(2*k+1,i) = (2-l(i))/(2+l(i))*Psi(2*k-1,i)+2*l(i)/(2+l(i))*src(2*k)/sigma_t;
           Psi(2*k,i) = (Psi(2*k+1,i)+Psi(2*k-1,i))/2;
        end
    end
    % ����Դ��
    for i = 1:K
        src(2*i) = (sigma_s+nusigma_f)/4*wt*(Psi(2*i-1,:)+Psi(2*i+1,:))';
%         % ʹ�ø�������ɢ�亯������Դ��
%         for p = 1:N
%             src(2*i,p) = 0;
%             for q = 1:N
%                 src(2*i,p) = src(2*i,p) + (2*q-1)/4*sigma_s*f(q)*MatLegendre(p,q)*(wt*((psi(2*i-1,:)+psi(2*i+1,:))'.*MatLegendre(:,q)));
%             end
%             src(2*i,p) = src(2*i,p) + nusigma_f/4*wt*(psi(2*i-1,:)+psi(2*i+1,:))';
%         end
    end
    % ����Ƿ�ﵽ����Ҫ��
    bad_grid = 0;
    for i = 1:(2*K+1)
        Phi(i) = wt*Psi(i,:)';  % ���ݽ�ע���ʼ���ע���ʣ���˹���֣�
        keff_temp = Phi(i)/old_Phi(i);  % ���㵱ǰ������Ч��ֵϵ��
        if(abs((keff_temp-keff(i))/keff(i))>=tol)  % ������Ч��ֵϵ�����ж��Ƿ�ﵽҪ��
           bad_grid = bad_grid + 1;
        end
        keff(i) = keff_temp;
    end
    old_Phi = Phi;
    cycle_count = cycle_count + 1;
end
elapsed_time = toc(t_Start); % MATLAB��ʱ���

%% �����������
fp = fopen('1D_plane_outputs.txt','wt');
fprintf(fp,'��Ч��ֵϵ����ƽ��ֵ���� %.8g\n',mean(keff));
fprintf(fp,'��Ч��ֵϵ�������ֵ���� %.8g\n',max(keff));
fprintf(fp,'��Ч��ֵϵ������Сֵ���� %.8g\n',min(keff));
fprintf(fp,'ѭ�������ܴ����� %d\n',cycle_count);
fprintf(fp,'ѭ��������ʱ���� %.3g s\n\n\n',elapsed_time);
fprintf(fp,'************************************\n');
fprintf(fp,'*           ����ͨ��У��           *\n');
fprintf(fp,'************************************\n');
phi_center = Phi(1); % ����ͨ��
fprintf(fp,'   У���λ��           ģ����\n');
fprintf(fp,'��aΪƽ����ȣ�   ������ͨ����һ��\n');
fprintf(fp,'------------------------------------\n');
fprintf(fp,'     0.25a             %.9g\n',Phi(uint32(0.25*a0/(delta/2)))/phi_center); % ������ͨ����һ
fprintf(fp,'     0.50a             %.9g\n',Phi(uint32(0.50*a0/(delta/2)))/phi_center);
fprintf(fp,'     0.75a             %.9g\n',Phi(uint32(0.75*a0/(delta/2)))/phi_center);
fprintf(fp,'     1.00a             %.9g\n',Phi(uint32(1.00*a0/(delta/2)))/phi_center);
fclose(fp);

%% ��������ͨ���ֲ����ߣ�
plot(x,Phi(1:2:(2*K+1)),'-r','linewidth',1.5);
xlabel('$x$','FontSize',16,'Interpreter','latex','FontWeight','bold');
ylabel('Fluence Rate $\phi$','FontSize',16,'Interpreter','latex','FontWeight','bold');
print('-depsc2','1D_plane_neutron_flux.eps'); % ������ͨ���ֲ����ߴ���PDF�ļ�����