fir = design_task_2_task_2_a_filter;
number_of_taps = length(fir.Numerator);
n = number_of_taps + 1;
sample = zeros(n, 1);
sample(1) = 1;
ref_output = filter(fir, sample);
output = zeros(length(sample), 1);

for i = 0:length(sample)-1
    output(i+1) = fir_filter(sample(i+1));
end

% draw_frequency_response(output, 'Design output');

mse = mean(ref_output-output).^2;
assert(mse < 2.43e-11, "Test failed, MSE too high: " + mse);

function draw_frequency_response(signal, signal_name)
    figure;
    freqz(double(signal));
    title(append(signal_name, ' Magnitude'));
end