clear all
close all
clc

%% set parameters and loops
display_percentage_ok = 1;
plot_individuals = 0;
plot_averages = 1;

pp2do = [1:7];
p = 0;

subplot_size = 1;

for pp = pp2do
    p = p+1;
    ppnum(p) = pp;
    figure_nr = 1;
    
    param = getSubjParam(pp);
    disp(['getting data from ', param.subjName]);
    
    %% load actual behavioural data seperatly for auditory vs visual
   behdata_a = readtable(param.log_a);
   behdata_v = readtable(param.log_v);

    %% check percentage oktrials for auditory task
    % select trials with reasonable decision times
    oktrials_a = abs(zscore(behdata_a.idle_reaction_time_in_ms))<=3; 
    percentageok_a(p,1) = mean(oktrials_a)*100;
  
   %% check percentage oktrials for visual task
    % select trials with reasonable decision times
    oktrials_v = abs(zscore(behdata_v.idle_reaction_time_in_ms))<=3; 
    percentageok_v(p,1) = mean(oktrials_v)*100;

    % display percentage ok trials
    if display_percentage_ok
        fprintf('%s AUDITORY has %.2f%% oktrials\n', ...
        param.subjName, percentageok_a(p,1));

    fprintf('%s VISUAL has %.2f%% oktrials\n\n', ...
        param.subjName, percentageok_v(p,1));
    end

    %% basic data checks, each pp in own subplot
    %% decision time   
    if plot_individuals
        figure(figure_nr);
        figure_nr = figure_nr+1; 
        % auditory
            subplot(1,2,1);
            histogram(behdata_a.idle_reaction_time_in_ms, 50);
            title(['Auditory task decision time - pp ', num2str(pp2do(p))]);
            xlim([0 2000]);
            ylim([0 150]);

         % visual
            subplot(1,2,2);
            histogram(behdata_v.idle_reaction_time_in_ms, 50);
            title(['Visual task decision time - pp ', num2str(pp2do(p))]);
            xlim([0 2000]);
            ylim([0 150]);
    
    %% response time
        figure(figure_nr);
        figure_nr = figure_nr + 1;
        % auditory
            subplot(1,2,1);
            histogram(behdata_a.response_time_in_ms, 50);
            title(['Auditory task response time - pp ', num2str(pp2do(p))]);
            xlim([0 2010]);
            ylim([0 150]);
        % visual
            subplot(1,2,2);
            histogram(behdata_v.response_time_in_ms, 50);
            title(['Visual task response time - pp ', num2str(pp2do(p))]);
            xlim([0 2010]);
            ylim([0 150]);

    %% performance   
        figure(figure_nr);
        figure_nr = figure_nr+1;
        % auditory
            subplot(1,2,1);
            histogram(behdata_a.performance, 50);
            title(['auditory task freq offset - pp ', num2str(pp2do(p))]);
            xlim([-10 10]);
        % visual
            subplot(1,2,2);
            histogram(behdata_v.performance, 50);
            title(['visual task freq offset - pp ', num2str(pp2do(p))]);
            xlim([-10 10]);

    %%absolute performance
        figure(figure_nr);
        figure_nr = figure_nr+1;
        % auditory
            subplot(1,2,1);
            histogram(behdata_a.performance_abs, 50);
            title(['auditory task abs performance - pp ', num2str(pp2do(p))]);
            xlim([0 10]);
        % visual
            subplot(1,2,2);
            histogram(behdata_v.performance_abs, 50);
            title(['visual task abs performance - pp ', num2str(pp2do(p))]);
            xlim([0 10]);
        end

    
    %% trial selections
    %auditory
    left_trials_a = ismember(behdata_a.target_position, {'left'});
    right_trials_a = ismember(behdata_a.target_position, {'right'});

    first_target_trials_a = behdata_a.target_item == 1;
    second_target_trials_a = behdata_a.target_item == 2;

    low_trials_a = ismember(behdata_a.target_pitch_cat, {'low'});
    high_trials_a = ismember(behdata_a.target_pitch_cat, {'high'});

    premature_trials_a = ismember(behdata_a.premature_pressed, {'True'});

    %% extract data of interest (AUDITORY)
    overall_dt_a(p,1) = mean(behdata_a.idle_reaction_time_in_ms(oktrials_a), "omitnan");
    overall_abs_error_a(p,1) = mean(behdata_a.performance_abs(oktrials_a), "omitnan");
    overall_error_a(p,1) = mean(behdata_a.performance(oktrials_a), "omitnan");

    labels = {'low', 'high'};

    % reaction time as function of pitch category (AUD)
    dt_pitch_a(p,1) = mean(behdata_a.idle_reaction_time_in_ms(low_trials_a & oktrials_a), "omitnan");
    dt_pitch_a(p,2) = mean(behdata_a.idle_reaction_time_in_ms(high_trials_a & oktrials_a), "omitnan");

    % error as function of pitch category (AUD)
    error_pitch_a(p,1) = mean(behdata_a.performance_abs(low_trials_a & oktrials_a), "omitnan");
    error_pitch_a(p,2) = mean(behdata_a.performance_abs(high_trials_a & oktrials_a), "omitnan");

    % response frequency (AUD)
    response_pitch_a(p,1) = mean(behdata_a.response_freq(low_trials_a & oktrials_a), "omitnan");
    response_pitch_a(p,2) = mean(behdata_a.response_freq(high_trials_a & oktrials_a), "omitnan");

    %% frequency loop (AUD)
    frequencies = [300, 316, 332, 350, 368, 408, 429, 451, 475, 500];

    i = 0;
    for freq = frequencies
        i = i + 1;

        trial_sel_a = behdata_a.target_pitch == freq;

        dt_pitches_a(p,i) = mean(behdata_a.idle_reaction_time_in_ms(trial_sel_a & oktrials_a), "omitnan");
        rt_pitches_a(p,i) = mean(behdata_a.response_time_in_ms(trial_sel_a & oktrials_a), "omitnan");
        response_pitches_a(p,i) = mean(behdata_a.response_freq(trial_sel_a & oktrials_a), "omitnan");
        error_pitches_a(p,i) = mean(behdata_a.performance(trial_sel_a & oktrials_a), "omitnan");
        abs_error_pitches_a(p,i) = mean(behdata_a.performance_abs(trial_sel_a & oktrials_a), "omitnan");
    end

    %visual
    left_trials_v = ismember(behdata_v.target_position, {'left'});
    right_trials_v = ismember(behdata_v.target_position, {'right'});

    first_target_trials_v = behdata_v.target_item == 1;
    second_target_trials_v = behdata_v.target_item == 2;

    low_trials_v = ismember(behdata_v.target_pitch_cat, {'low'});
    high_trials_v = ismember(behdata_v.target_pitch_cat, {'high'});

    premature_trials_v = ismember(behdata_v.premature_pressed, {'True'});

    %% extract data of interest (VISUAL)
    overall_dt_v(p,1) = mean(behdata_v.idle_reaction_time_in_ms(oktrials_v), "omitnan");
    overall_abs_error_v(p,1) = mean(behdata_v.performance_abs(oktrials_v), "omitnan");
    overall_error_v(p,1) = mean(behdata_v.performance(oktrials_v), "omitnan");

    % reaction time as function of pitch category (VIS)
    dt_pitch_v(p,1) = mean(behdata_v.idle_reaction_time_in_ms(low_trials_v & oktrials_v), "omitnan");
    dt_pitch_v(p,2) = mean(behdata_v.idle_reaction_time_in_ms(high_trials_v & oktrials_v), "omitnan");

    % error as function of pitch category (VIS)
    error_pitch_v(p,1) = mean(behdata_v.performance_abs(low_trials_v & oktrials_v), "omitnan");
    error_pitch_v(p,2) = mean(behdata_v.performance_abs(high_trials_v & oktrials_v), "omitnan");

    % response frequency (VIS)
    response_pitch_v(p,1) = mean(behdata_v.response_freq(low_trials_v & oktrials_v), "omitnan");
    response_pitch_v(p,2) = mean(behdata_v.response_freq(high_trials_v & oktrials_v), "omitnan");

    %% frequency loop (VIS)
    i = 0;
    for freq = frequencies
        i = i + 1;

        trial_sel_v = behdata_v.target_pitch == freq;

        dt_pitches_v(p,i) = mean(behdata_v.idle_reaction_time_in_ms(trial_sel_v & oktrials_v), "omitnan");
        rt_pitches_v(p,i) = mean(behdata_v.response_time_in_ms(trial_sel_v & oktrials_v), "omitnan");
        response_pitches_v(p,i) = mean(behdata_v.response_freq(trial_sel_v & oktrials_v), "omitnan");
        error_pitches_v(p,i) = mean(behdata_v.performance(trial_sel_v & oktrials_v), "omitnan");
        abs_error_pitches_v(p,i) = mean(behdata_v.performance_abs(trial_sel_v & oktrials_v), "omitnan");
    end
    
end

if plot_averages
 %% check performance
    figure; 
    subplot(4,1,1)
    hold on
    bar(ppnum-0.2, overall_dt_a(:,1), 0.4);
    bar(ppnum+0.2, overall_dt_v(:,1), 0.4);
    title('Overall decision time');
    ylabel('ms');
    xlabel('Participant');
    legend({'Auditory','Visual'});
    ylim([0 1200]);

    subplot(4,1,2)
    hold on
    bar(ppnum-0.2, overall_error_a(:,1), 0.4);
    bar(ppnum+0.2, overall_error_v(:,1), 0.4);
    title('Overall error');
    ylabel('Error');
    xlabel('Participant');
    legend({'Auditory','Visual'});
    ylim([-0.4 0.8]);

    subplot(4,1,3)
    hold on
    bar(ppnum-0.2, overall_abs_error_a(:,1), 0.4);
    bar(ppnum+0.2, overall_abs_error_v(:,1), 0.4);
    title('Overall ABS error');
    ylabel('ABS error');
    xlabel('Participant');
    legend({'Auditory','Visual'});
    ylim([0 3]);

    subplot(4,1,4)
    hold on
    bar(ppnum-0.2, percentageok_a(:,1), 0.4);
    bar(ppnum+0.2, percentageok_v(:,1), 0.4);
    title('Percentage OK trials');
    ylabel('%');
    xlabel('Participant');
    legend({'Auditory','Visual'});
    ylim([90 100]);

    %% effect of target pitch category on behaviour
    figure;
    subplot(1,3,1)
    hold on
    bar(mean(dt_pitch_a,1));
    bar(mean(dt_pitch_v,1));
    xticklabels(labels);
    ylabel('Decision time (ms)');
    title('Decision time');
    legend({'Auditory','Visual'});

    subplot(1,3,2)
    hold on
    bar(mean(error_pitch_a,1));
    bar(mean(error_pitch_v,1));
    xticklabels(labels);
    ylabel('Reproduction error');
    title('ABS Error');
    legend({'Auditory','Visual'});

    subplot(1,3,3)
    hold on
    bar(mean(response_pitch_a,1));
    bar(mean(response_pitch_v,1));
    xticklabels(labels);
    ylabel('Responded frequency (Hz)');
    title('Response frequency');
    legend({'Auditory','Visual'});

    %% effect of target pitch on behaviour
    figure;
    hold on
    plot(frequencies, mean(dt_pitches_a,1), '-o', 'LineWidth',2);
    plot(frequencies, mean(dt_pitches_v,1), '-o', 'LineWidth',2);

    xlabel('Target frequency (Hz)');
    ylabel('Decision time (ms)');
    title('Decision time by frequency');
    legend({'Auditory','Visual'});
    
    figure;
    hold on
    plot(frequencies, mean(rt_pitches_a,1), '-o', 'LineWidth',2);
    plot(frequencies, mean(rt_pitches_v,1), '-o', 'LineWidth',2);

    xlabel('Target frequency (Hz)');
    ylabel('Response time (ms)');
    title('Response time by frequency');
    legend({'Auditory','Visual'});

    figure;
    hold on
    plot(frequencies, mean(response_pitches_a,1), '-o', 'LineWidth',2);
    plot(frequencies, mean(response_pitches_v,1), '-o', 'LineWidth',2);

    % ideal response line
    plot(frequencies, frequencies, '--k', 'LineWidth',2);

    xlabel('Target frequency (Hz)');
    ylabel('Responded frequency (Hz)');
    title('Responded frequency');
    legend({'Auditory','Visual','Ideal response'});

    figure;
    hold on
    plot(frequencies, mean(error_pitches_a,1), '-o', 'LineWidth',2);
    plot(frequencies, mean(error_pitches_v,1), '-o', 'LineWidth',2);

    xlabel('Target frequency (Hz)');
    ylabel('Reproduction error');
    title(' Error');
    legend({'Auditory','Visual'});

    figure;
    hold on
    plot(frequencies, mean(abs_error_pitches_a,1), '-o', 'LineWidth',2);
    plot(frequencies, mean(abs_error_pitches_v,1), '-o', 'LineWidth',2);

    xlabel('Target frequency (Hz)');
    ylabel('ABS reproduction error');
    title('Absolute error');
    legend({'Auditory','Visual'});

end
