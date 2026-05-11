clc;
clear;


x = [1 2 4 8 16 32 64 -128];

scale = 1;   % keep =1 for integer design

x_fixed = fix(x * scale);


fid = fopen('input.txt','w');

for i = 1:length(x_fixed)
    fprintf(fid,'%d\n', x_fixed(i));
end

fclose(fid);

X = fft(x_fixed);

fid_r = fopen('fft_real_matlab.txt','w');
fid_i = fopen('fft_imag_matlab.txt','w');

for k = 1:length(X)
    fprintf(fid_r,'%d\n', fix(real(X(k))));
    fprintf(fid_i,'%d\n', fix(imag(X(k))));
end

fclose(fid_r);
fclose(fid_i);

disp('MATLAB FFT Output:');
for k = 1:length(X)
    fprintf('Y[%d] = %d + j%d\n', ...
        k-1, fix(real(X(k))), fix(imag(X(k))));
end