function sym_seq = symbol_mapper(bin_seq, M, d, name)
    % sym_seq is the symbol sequence consisting of the symbols in the constellation set
    % bin_seq is the input binary sequence.
    % M is the number of points in the signal constellation set. For PAM and PSK, M = 2,4,8,16. For QAM, M = 4,16,64.
    % d is a parameter related to the minimum distance among the constellation points.
    % name is the name of the modulation scheme. It can be 'PAM', 'PSK', or 'QAM'.
    % The function maps the input binary sequence to the symbol sequence.
    % finish the function here
    if strcmp(name, 'PAM')
        %group the binary sequence into log2(M) bits
        % len = length(bin_seq)/log2(M)
        sym_seq = zeros(1, length(bin_seq)/log2(M));
        % bin_seq
        for i = 1:length(bin_seq)/log2(M)
            % bin_seq((i-1)*log2(M)+1:i*log2(M))
            sym_seq(i) = bi2de(bin_seq((i-1)*log2(M)+1:i*log2(M)), 'left-msb');
        end
        sym_seq = pammod(sym_seq, M, 0, 'gray');
        E_p = (d/2)^2;
        sym_seq = -sqrt(E_p).*sym_seq;

    
    elseif strcmp(name, 'PSK')
        sym_seq = zeros(1, length(bin_seq)/log2(M));
        for i = 1:length(bin_seq)/log2(M)
            sym_seq(i) = bi2de(bin_seq((i-1)*log2(M)+1:i*log2(M)), 'left-msb');
        end
        % sym_seq = exp(1j*2*pi*sym_seq/M);
        % sym_seq
        sym_seq = pskmod(sym_seq, M, 0, 'gray');
        E_p = (d/(2*sin(pi/M)))^2;
        sym_seq = sqrt(E_p).*sym_seq;
    elseif strcmp(name, 'QAM')
        sym_seq = zeros(1, length(bin_seq)/log2(M));
        for i = 1:length(bin_seq)/log2(M)
            sym_seq(i) = bi2de(bin_seq((i-1)*log2(M)+1:i*log2(M)), 'left-msb');
        end
        % sym_seq = (sym_seq - (M-1)/2)*d + (sym_seq - (M-1)/2)*d*1j;
        % sym_seq
        sym_seq = qammod(sym_seq, M, 'gray');
        E_p = (d/2)^2;
        sym_seq = sqrt(E_p).*sym_seq;
        % sym_seq
        % do complex conjugate
        sym_seq = conj(sym_seq);
    else
        error('Invalid modulation scheme name.');
    end
end
