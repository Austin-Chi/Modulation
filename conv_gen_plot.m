function BER = conv_gen_plot()
    % Generate a binary sequence {bi} of length 104 where each bit is drawn from a Bernoulli distribution with p = 1/2 (i.e. the bits are equiprobable).
    sequence = randi([0,1],1,(10^5));
    d=1;
    M=2;
    %do for M=2, 4, 8, 16 and dB = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 and plot the SER vs. Eb/N0
    g = [1,0,1;1,1,1];
    coded = conv_enc(sequence, g);
    BER = vpa(zeros(1,15));
    DB = zeros(1,15);
    i=1;

    E0 = (1/d)^2;
    sym_sequence = sqrt(E0)*(-1).^(coded);
    for dB = 0:0.5:7
        DB(1,i) = dB;
        % origin = sequence;
        % sym_sequence = symbol_mapper(sequence, M, d, "QAM");
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
        % E0 = (d^2)*(M-1)/(6*log2(M)); %QAM
        N0 = E0/(10^(dB/10));


        received_symbols = sym_sequence; 
    
        noise_real = sqrt(N0/2) * randn(1, length(received_symbols));
        noise_imaginary = sqrt(N0/2) * randn(1, length(received_symbols));

        noise = noise_real + 1i * noise_imaginary;


        received_symbols_with_noise = received_symbols + noise;
        rec_code = MD_symbol_demapper(received_symbols_with_noise, M, d, "PSK");
        rec_data = conv_dec(rec_code', g);
        ber = vpa(sum(rec_data~=sequence)/length(sequence))
        BER(1,i) = vpa(ber, 5)
        i=i+1
    end



    % plot the SER vs. Eb/N0
    figure;
    semilogy(DB,BER(1,:),'-o');
    % hold on;
    % theo = vpa(2*qfunc(sqrt((6*(log2(2))/3)*(10.^((0:10)/10)))))
    % temp = linspace(0,10, 1000);
    % [ber_2PAM, theo_2PAM] = berawgn(temp,'psk',M,'nondiff');
    % semilogy(temp,ber_2PAM);
    % hold off;
    


end
