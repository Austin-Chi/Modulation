function SER = binary_gen_plot()
    % Generate a binary sequence {bi} of length 104 where each bit is drawn from a Bernoulli distribution with p = 1/2 (i.e. the bits are equiprobable).
    sequence = randi([0,1],1,3*(10^5));
    d=1;
    %do for M=2, 4, 8, 16 and dB = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 and plot the SER vs. Eb/N0
    SER = vpa(zeros(4,11));
    i=1;
    j=1;
    for M = [2,4,8,16]
        i=1;
        for dB = 0:10
            origin = sequence;
            sym_sequence = symbol_mapper(sequence, M, d, "PSK");
            M
            dB
            % sequence
            % Plot the two-dimensional histogram of the symbol sequence {un}. You can use the Matlab command histogram2
            % histogram2(real(sequence),imag(sequence));
            % hold off;
            % At the receiver’s side, the received symbol sequence {ri}i is given by ri = ui + n, where n is a circularly-symmetric complex Gaussian random variable with mean 0 and variance
            % N0. Plot the three 2-D histogram of {ri} for Eb/N0 = 0, 10, and 20dB. Depict the decision
            % regions on the histogram.
            % 已知参数
            % E0 = (d^2)*(M^2-1)/(12*log2(M)); %PAM
            % E0 = ((d/2)^2)/((sin(pi/M))^2*log2(M)); %PSK
            E0 = (d^2)*(M-1)/(6*log2(M)); %QAM
            N0 = E0/(10^(dB/10));


            received_symbols = sym_sequence; 
        
            noise_real = sqrt(N0/2) * randn(1, length(received_symbols));
            noise_imaginary = sqrt(N0/2) * randn(1, length(received_symbols));

            noise = noise_real + 1i * noise_imaginary;


            received_symbols_with_noise = received_symbols + noise;
            SER(j,i) = vpa(MD_symbol_demapper_compare(received_symbols_with_noise, M, d, "PSK", origin))
            i=i+1;
        end
        j=j+1;
    end

    % plot the SER vs. Eb/N0
    figure;
    semilogy(0:10,SER(1,:),'-o');
    hold on;
    % theo = vpa(2*qfunc(sqrt((6*(log2(2))/3)*(10.^((0:10)/10)))))
    temp = linspace(0,10, 1000);
    [ber_2PAM, theo_2PAM] = berawgn(temp,'psk',4,'nondiff');
    semilogy(temp,theo_2PAM);
    hold off;
    % plot in different figure
    figure;
    semilogy(0:10,SER(2,:),'-o');
    hold on;
    % theo = vpa(2*qfunc(sqrt((6*(log2(4))/(4^2-1))*(10.^((0:10)/10)))));
    [ber_4PAM, theo_4PAM] = berawgn(temp,'psk',16,'nondiff');
    semilogy(temp,theo_4PAM);
    hold off;

    figure;
    semilogy(0:10,SER(3,:),'-o');
    hold on;
    % theo = vpa(2*qfunc(sqrt((6*(log2(8))/(8^2-1))*(10.^((0:10)/10)))));
    [ber_8PAM, theo_8PAM] = berawgn(temp,'psk',64,'nondiff');
    semilogy(temp,theo_8PAM);
    hold off;

    % figure;
    % semilogy(0:10,SER(4,:),'-o');
    % hold on;
    % % theo = vpa(2*qfunc(sqrt((6*(log2(16))/(16^2-1))*(10.^((0:10)/10)))));
    % [ber_16PAM, theo_16PAM] = berawgn(temp,'psk',16,'nondiff');
    % semilogy(temp,theo_16PAM);
    % hold off;



    % M=4;
    % origin = sequence;
    % sequence = symbol_mapper(sequence, M, d, "PAM");
    % % sequence
    % % Plot the two-dimensional histogram of the symbol sequence {un}. You can use the Matlab command histogram2
    % % histogram2(real(sequence),imag(sequence));
    % % hold off;
    % % At the receiver’s side, the received symbol sequence {ri}i is given by ri = ui + n, where n is a circularly-symmetric complex Gaussian random variable with mean 0 and variance
    % % N0. Plot the three 2-D histogram of {ri} for Eb/N0 = 0, 10, and 20dB. Depict the decision
    % % regions on the histogram.
    % % 已知参数
    % E0 = (d^2)*(M-1)/(6*log2(M));
    % dB = 0;
    % N0 = E0/(10^(dB/10));


    % received_symbols = sequence; 
   
    % noise_real = sqrt(N0/2) * randn(1, length(received_symbols));
    % noise_imaginary = sqrt(N0/2) * randn(1, length(received_symbols));

    % noise = noise_real + 1i * noise_imaginary;


    % received_symbols_with_noise = received_symbols + noise;
    % SER = MD_symbol_demapper_compare(received_symbols_with_noise, M, d, "PAM", origin);
    % % histogram2(real(received_symbols_with_noise),imag(received_symbols_with_noise));


end
