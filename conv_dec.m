function decoded_data = conv_dec(encoded_data, impulse_response)
    len_output = size(impulse_response, 1);
    num_states = size(impulse_response, 2);
    num_states = num_states - 1;
    num_input_bits = length(encoded_data) / len_output;
    

    num_paths = 2^num_states;  
    metrics = zeros(num_paths, num_input_bits + 1);
    survivors = zeros(num_paths, num_input_bits);
    decoded = zeros(num_paths, num_input_bits);
    

    metrics(1:num_paths, 1) = Inf;
    metrics(1, 1) = 0;
    

    survivors(1:num_paths, 1) = 0:num_paths-1;
    

    for i = 1:num_input_bits
        received_symbols = encoded_data((i - 1) * len_output + 1:i * len_output);

        metrics(1:num_paths, i+1) = Inf;
        % i
        for j = 1:num_paths
            % path = survivors(j, i);
            
            for k = 0:1
                shift_reg = [k, dec2bin(j-1, num_states) - '0'];
                % shift_reg
                new_state = shift_reg(1:end-1);
                % bin2dec(num2str(new_state))
                transition_bits = mod(impulse_response * shift_reg', 2);
                % transition_bits
                % received_symbols
                hamming_distance = sum(mod(transition_bits' + received_symbols, 2));
                % hamming_distance
                
                new_metric = metrics(j, i) + hamming_distance;
                % new_metric

                if new_metric < metrics(bin2dec(num2str(new_state))+1, i + 1)
                    % st = "yay"
                    % bin2dec(num2str(new_state))
                    metrics(bin2dec(num2str(new_state))+1, i + 1) = new_metric;
                    survivors(bin2dec(num2str(new_state))+1, i + 1) = j;
                    decoded(bin2dec(num2str(new_state))+1, i + 1) = k;
                    % st2 = "hhhh"
                end
            end
        end
    end
    % metrics
    % survivors

    best_path = 1;
    for j = 2:num_paths
        if metrics(j, num_input_bits + 1) < metrics(best_path, num_input_bits + 1)
            best_path = j;
        end
    end
    
    decoded_data = zeros(1, num_input_bits);
    for i = num_input_bits+1:-1:2
        decoded_data(i-1) = decoded(best_path, i);
        best_path = survivors(best_path, i);
    end
    
end
