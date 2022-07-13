clear 
close all 
clc

%% Load Initial Parameters 

%       See ReadME for description of system and measurement data

load('params/vars.mat')
load('params/H9P1.mat')

%% Perform Integration of INS Accel. 

for i = 1:length(aINSu)-1  
   vINS = aINSu(i)*dt + vINS ; 
   xINS(i+1) = vINS*dt + xINS(i) ;  
end

%% Plot Uncorrected Position Data 

figure(1)
subplot(2,1,1)
plot((1:length(aINSu)), xINS, 'LineWidth',3) 
ylabel('Position (m)')
title("Uncorrected Position from INS and GPS")
legend("INS Integrated Position")
subplot(2,1,2)
plot((1:length(aINSu)), zGPS, 'LineWidth', 3)
xlabel('Time (s)') 
ylabel('Position (m)')
legend("GPS Position")

%% Performing Open Loop Kalman Filter

accel_bias_ol = zeros(1,length(aINSu)) ; 
pos_corr_ol   = zeros(1,length(aINSu)) ;
for k = 1:length(xINS) 
    % Observable Measurement Error 
    hk = xINS(k) + x_k_(1) ; 
    z_k = zGPS(k) - hk ; 
    
    % Updating Kalman Gain 
    K_k = P_k_*H_k'*inv(H_k*P_k_*H_k' + R_k) ; 
    
    % Posteriror Error Estimate 
    x_k = x_k_ + K_k*(z_k) ; 
    accel_bias_ol(k) = x_k(3) ; 

    % Propagate Estimate and Error Covariance
    P_k = (I - K_k*H_k)*P_k_ ; 
    x_k_ = phi_k*x_k + w_k ;  
    P_k_ = phi_k*P_k*phi_k' + Q_k ; 

    % Update Position Estimate
    xINSc = xINS(k) + 0.5*x_k(3)*k^2 ; 
    pos_corr_ol(k) = xINSc ; 
end

%% Plot Acceleration Bias

figure(2)
plot((1:length(aINSu)), -accel_bias_ol, 'LineWidth', 3) ; 
hold on 
plot((1:length(aINSu)), ones(1,length(aINSu))*b, 'LineWidth', 3) ; 
xlabel('Time (s)') 
ylabel('Accel. Bias (m/s^2)') 
legend("Estimated Bias", "Actual Bias")
title("Comparison of Estimated INS Accel. Bias with Actual Bias")

%% Plot Corrected Position compared with GPS Position

figure(3) 
plot((1:length(aINSu)), zGPS, 'LineWidth', 3)
hold on
plot((1:length(aINSu)), pos_corr_ol, 'LineWidth', 3); 
xlabel('Time (s)') 
ylabel('Position (m)') 
title("Comparing Open vs Closed Loop Performance with GPS Data")

%% Performing Closed Loop Kalman Filter

% Start with Fresh Workspace 
clear 
load('params/vars.mat')
load('params/H9P1.mat')

% Run KF Algorithm
accel_bias_cl = zeros(1,length(aINSu)) ; 
pos_corr_cl   = zeros(1,length(aINSu)) ;
xINSc         = 0 ;
for k = 1:length(xINS) 
    % Observable Measurement Error 
    hk = xINSc + x_k_(1) ; 
    z_k = zGPS(k) - hk ; 
    
    % Updating Kalman Gain 
    K_k = P_k_*H_k'*inv(H_k*P_k_*H_k' + R_k) ; 
    
    % Posteriror Error Estimate 
    x_k = x_k_ + K_k*(z_k) ; 
    accel_bias_cl(k) = x_k(3) ; 

    % Propagate Estimate and Error Covariance
    P_k = (I - K_k*H_k)*P_k_ ; 
    x_k_ = phi_k*x_k + w_k ;  
    P_k_ = phi_k*P_k*phi_k' + Q_k ; 

    % Update Position Estimate
    xINSc = xINSc + 0.5*x_k(3)*dt^2 ; 
    pos_corr_cl(k) = xINSc ; 
end

%% Plot Position Estimate with Closed Loop KF
figure(3)
plot((1:length(aINSu)), pos_corr_cl, 'LineWidth', 3); 
legend("GPS Position", "OL KF Position", "CL KF Position")
