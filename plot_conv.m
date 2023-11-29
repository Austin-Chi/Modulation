function hi = plot_conv()

    info_bits = randi([0, 1], 1, 100000);  % 生成长度为 100000 的随机信息位序列
    %add two zeros at the end
    info_bits = [info_bits, 0, 0];

    impulse_response = [1, 0, 0; 1, 0, 1; 1, 1, 1]; %You can change the impulse response for (3)
    % impulse_response = [1, 1, 0; 1, 0, 1];

    p_values = 0:0.1:1;
    % p_values = [0, 0.5];

    bit_error_rates = zeros(size(p_values));

    for p_idx = 1:length(p_values)
        p = p_values(p_idx);
        p
        
        encoded_data = conv_enc(info_bits, impulse_response);
        
        received_data = apply_binary_symmetric_channel(encoded_data, p);
        
        decoded_data = conv_dec(received_data, impulse_response);

        bit_errors = sum(info_bits ~= decoded_data);
        bit_error_rate = bit_errors / length(info_bits);
        bit_error_rate
        
        bit_error_rates(p_idx) = bit_error_rate;
    end

    plot(p_values, bit_error_rates, 'o-');
    xlabel('p');
    ylabel('BER');
    title('BER vs. p');
    grid on;
    hi = 1;
end