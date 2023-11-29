function received_data = apply_binary_symmetric_channel(encoded_data, p)
    % 生成与编码数据相同长度的随机错误向量
    error_vector = rand(size(encoded_data)) < p;
    
    % 将编码数据的 0 转换为 1，1 转换为 0
    received_data = xor(encoded_data, error_vector);
end
