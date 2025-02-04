% FIR_FILTER_CODEGEN   Generate static library fir_filter from fir_filter.
% 
% Script generated from project 'fir_filter.prj' on 04-Feb-2025.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.EmbeddedCodeConfig'.
cfg = coder.config('lib','ecoder',true);
cfg.TargetLang = 'C++';
cfg.GenerateReport = true;
cfg.MaxIdLength = 1024;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'fir_filter'.
ARGS = cell(1,1);
ARGS{1} = cell(1,1);
ARGS{1}{1} = coder.typeof(0);

%% Invoke MATLAB Coder.
codegen -config cfg fir_filter -args ARGS{1}

