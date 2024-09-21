classdef Fir_error_tests < matlab.unittest.TestCase
    properties (SetAccess = private)
        fir
        sample
        ref_output
    end
    methods (TestClassSetup)
        function setup(self)
            close all;

            self.compute_reference_output;
            self.draw_frequency_response(self.ref_output, 'Reference');
            self.write_data_to_file(self.sample, 'input.txt');
            self.write_coefficients(self.fir, 'coeffs.txt');
            self.write_data_to_file(self.ref_output, 'reference.txt');

        end
    end
    methods(Test)
        function fixed_point_should_be_within_error_tolerance_with_reference(self)
            signed = 1;
            fraction_bits = 16;
            word_length = fraction_bits;
            fir_fixed = copy(self.fir);
            fir_fixed.Numerator = fi(fir_fixed.Numerator, signed, ...
                                    word_length, fraction_bits);
            fir_fixed.Arithmetic = "fixed";
            fir_fixed.FilterInternals = "SpecifyPrecision";
            fir_fixed.CoeffAutoScale = false;

            fir_fixed.InputWordLength = 16;
            fir_fixed.InputFracLength = 15;
            fir_fixed.OutputWordLength = 32;
            fir_fixed.OutputFracLength = 30;
            fir_fixed.CoeffWordLength = 16;
            fir_fixed.NumFracLength = 16;
            fir_fixed.AccumWordLength = 32;
            fir_fixed.AccumFracLength = 30;
            fir_fixed.ProductWordLength = 32;
            fir_fixed.ProductFracLength = 30;
            fir_fixed.OverflowMode = 'wrap';
            fir_fixed.RoundMode = 'ceil';

            % self.get_filter_specs(fir_fixed);
            fixed_output = filter(fir_fixed, self.sample);

            self.write_data_to_file(fixed_output, 'design_output.txt')

            self.draw_frequency_response(fixed_output, 'Fixed-point');

            mse = mean((self.ref_output-fixed_output).^2);
            self.verifyLessThan(mse, 9.32e-10);
        end
    end
    methods
        function compute_reference_output(self)
            rng(100);
            self.fir = design_task_2_task_2_a_filter;
            number_of_taps = length(self.fir.Numerator);
            n = number_of_taps + 1;
            self.sample = zeros(n, 1);
            self.sample(1) = 1;
            self.ref_output = filter(self.fir, self.sample);
        end

        function draw_frequency_response(self, signal, signal_name)
            figure;
            freqz(double(signal));
            title(append(signal_name, ' Magnitude'));
        end

        function get_filter_specs(self, filter)
            filename = 'filter_specs.txt';
            delete(filename);
            diary(filename);
            get(filter)
            diary off;
        end

        function write_coefficients(self, filter, filename)
            coeffs = filter.Numerator;
            fileID = fopen(filename, 'w');
            for i = 1:length(coeffs)
                if i == length(coeffs)
                    fprintf(fileID, '%f', coeffs(i)); % Last coefficient without a comma
                else
                    fprintf(fileID, '%f,\n', coeffs(i));
                end
            end
            fclose(fileID);
        end

        function write_data_to_file(self, data, filename)
            fileID = fopen(filename, 'w');
            fprintf(fileID, '%f\n', data);
            fclose(fileID);
        end
    end
end
