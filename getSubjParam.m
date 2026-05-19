function param = getSubjParam(pp)

%% participant-specific notes

%% set path and pp-specific file locations
unique_numbers = [68, 43, 75, 79, 29, 63, 77]; %needs to be in the right order

%% set path
param.path = '/Users/merelvansteenis/Documents//Users/merelvansteenis/Documents/m6.2 - auditory vs visual/';

%% Task-specific folders
param.path_a = fullfile(param.path, 'Auditory/');
param.path_v = fullfile(param.path, 'Visual/');

if pp < 10
    param.subjName = sprintf('pp0%d', pp);
else
    param.subjName = sprintf('pp%d', pp);
end

%% Determine the task type 
% Odd pp: Auditory = session 1, Visual = session 2
% Even pp: Auditory = session 2, Visual = session 1

if mod(pp,2) == 1
    session_a = 1;
    session_v = 2;
else
    session_a = 2;
    session_v = 1;
end

%% Behavioural files
% Auditory
log_string_a = sprintf('data_session_%d_%d.csv', pp, session_a);
param.log_a = fullfile(param.path_a, log_string_a);

% Visual
log_string_v = sprintf('data_session_%d_%d.csv', pp, session_v);
param.log_v = fullfile(param.path_v, log_string_v);

%% Eye data files
% Auditory
eds_string_a = sprintf('%d_%d_%d.asc', ...
    pp, unique_numbers(pp), session_a);
param.eds_a = fullfile(param.path_a, eds_string_a);

% Visual
eds_string_v = sprintf('%d_%d_%d.asc', ...
    pp, unique_numbers(pp), session_v);
param.eds_v = fullfile(param.path_v, eds_string_v);

end

%% deleting pp number 3 with unique number 75 since headphones was on the wrong way (possibly including this back into the data set later but trigger codes must be flipped L/R)