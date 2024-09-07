classdef Fir_error_tests < matlab.unittest.TestCase
    properties (SetAccess = private)
        fir
        sample
        ref_output
    end
    methods (TestClassSetup)
        function setup(self)
            close all;

            % reference design
            rng(100);
            self.fir = design_task_2_task_2_a_filter;
            number_of_taps = length(self.fir.Numerator);
            n = 100;
            self.sample = zeros(n, 1);
            self.sample(1) = 1;
            self.ref_output = filter(self.fir, self.sample);    

            figure;
            freqz(self.ref_output);
            title('Reference Magnitude');
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
            % fir_fixed.Arithmetic = "fixed";

            fixed_output = filter(fir_fixed, self.sample);
            
            figure;
            freqz(double(fixed_output));
            title('Fixed-point Magnitude');

            mse = mean((self.ref_output-fixed_output).^2);
            self.verifyLessThan(mse, 8.13e-12);
        end
    end
end
