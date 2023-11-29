function encoded_data = conv_enc(binary_data, impulse_response)
    impulse_size = size(impulse_response);
    % impulse_size
    len_output = impulse_size(1);
    num_states = impulse_size(2);
    num_states = num_states-1;
    num_input_bits = size(binary_data, 2);
    
    state = zeros(1, num_states);
    encoded_data = zeros(1, len_output * num_input_bits);
    current_pos = 1;
    new_state = zeros(1, num_states);
    for i = 1:num_input_bits
        input_bit = binary_data(i);
        c = zeros(1, len_output);

        
        new_state = [input_bit, state(1:end-1)];
        shift_reg = [input_bit, state];
        for j = 1:len_output
            c(j) = mod(impulse_response(j, :) * shift_reg', 2);
            encoded_data(current_pos) = mod(impulse_response(j, :) * shift_reg', 2);
            current_pos = current_pos+1;
        end
        state = new_state;
    end
end
