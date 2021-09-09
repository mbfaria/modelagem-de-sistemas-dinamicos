% % Método polos e zeros
% Y = yt(7:end);
%    
% % Numero de regressores = 3
% psi = y_id_dec(6:end-1);
% psi = [psi u_id_dec(6:end-1)];
% psi = [psi y_id_dec(5:end-2)];
% theta_hat = pinv(psi)*Y;
% num = [theta_hat(2)];
% den = [1 -theta_hat(1) -theta_hat(3)];
% sys = tf(num, den, 1);
% 
% figure();
% pzmap(sys);
% axis('equal');
% 
% % Numero de regressores = 4
% psi = [psi u_id_dec(5:end-2)];
% theta_hat = pinv(psi)*Y;
% num = [theta_hat(2) theta_hat(4)];
% den = [1 -theta_hat(1) -theta_hat(3)];
% sys = tf(num, den, 1);
% 
% figure();
% pzmap(sys);
% axis('equal');
% 
% % Numero de regressores = 5
% psi = [psi y_id_dec(4:end-3)];
% theta_hat = pinv(psi)*Y;
% num = [theta_hat(2) theta_hat(4)];
% den = [1 -theta_hat(1) -theta_hat(3) -theta_hat(5)];
% sys = tf(num, den, 1);
% 
% figure();
% pzmap(sys);
% axis('equal');
% 
% % Numero de regressores = 6
% psi = [psi u_id_dec(4:end-3)];
% theta_hat = pinv(psi)*Y;
% num = [theta_hat(2) theta_hat(4) theta_hat(6)];
% den = [1 -theta_hat(1) -theta_hat(3) -theta_hat(5)];
% sys = tf(num, den, 1);
% 
% figure();
% pzmap(sys);
% axis('equal');