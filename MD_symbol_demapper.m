function bin_seq = MD_symbol_demapper(sym_seq, M, d, name)
    %Implement a PAM demapper
    %   sym_seq: input symbol sequence
    %   M: modulation order
    %   d: distance between symbols
    %   name: name of the modulation scheme
    %   bin_seq: output binary sequence
    %   Example: bin_seq = MD_symbol_demapper(sym_seq, 4, 2, 'PAM')
    if strcmp(name, 'PAM')
        %group the binary sequence into log2(M) bits
        E_p = (d/2)^2;
        sym_seq = -sym_seq./sqrt(E_p);
        sym_seq = pamdemod(sym_seq, M, 0, 'gray');
        % ori_seq = zeros(1, length(bin_seq)/log2(M));
        % for i = 1:length(ori_bin_seq)/log2(M)
        %     ori_seq(i) = bi2de(ori_bin_seq((i-1)*log2(M)+1:i*log2(M)), 'left-msb');
        % end
        
        % change the symbol sequence into binary sequence
        bin_seq = de2bi(sym_seq, log2(M), 'left-msb');
        % bin_seq(8)
    
    elseif strcmp(name, 'PSK')
        E_p = (d/(2*sin(pi/M)))^2;
        sym_seq = sym_seq./sqrt(E_p);
        sym_seq = pskdemod(sym_seq, M, 0, 'gray');
        % sym_seq
        %change the symbol sequence into binary sequence and put them in one row
        bin_seq = de2bi(sym_seq, log2(M), 'left-msb');
        % bin_seq(1)
        
        
    elseif strcmp(name, 'QAM')
        E_p = (d/2)^2;
        sym_seq = conj(sym_seq);
        sym_seq = sym_seq./sqrt(E_p);
        sym_seq = qamdemod(sym_seq, M, 'gray');
        %change the symbol sequence into binary sequence
        bin_seq = de2bi(sym_seq, log2(M), 'left-msb');
        
        
        % sym_seq
        % do complex conjugate
        
    else
        error('Invalid modulation scheme name.');
    end
end
