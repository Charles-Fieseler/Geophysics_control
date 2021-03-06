%% Purdue AGU plots
% Scripts in different sections to generate various plots used in the AGU
% presentation
%
%
% INPUTS - Previously generated intermediate data files
%
% OUTPUTS - plots!
%
% EXAMPLES - go to a section and press ctr-enter
%
%
% Dependencies
%   .m files, .mat files, and MATLAB products required:(updated on 05-Dec-2019)
%         MATLAB (version 9.4)
%         PurdueProject.m
%         time_delay_embed.m
%
%   See also: OTHER_FUNCTION_NAME
%
%
%
% Author: Charles Fieseler
% University of Washington, Dept. of Physics
% Email address: charles.fieseler@gmail.com
% Website: coming soon
% Created: 05-Dec-2019
%========================================

%% 1: Data intro
% Example datasets that display clear features
%   Note: All from Distributed dataset
pp = PurdueProject();
fnames = pp.distributed_fnames;

% Lower frequency
i = 630;
dat = readtable(fnames{i});
% ind = dat{:,1} > 0; % Remove rise time
% dat = dat{ind,2}';
dat = dat{:,2}';

fig1 = figure('DefaultAxesFontSize',16);
plot(dat, 'linewidth', 2);
xlabel('Time'); ylabel('Acoustic Amplitude')
xlim([0, 800])
title('Example dataset: Lower Frequency')

% Higher frequency
i = 2784;
dat = readtable(fnames{i});
% ind = dat{:,1} > 0; % Remove rise time
% dat = dat{ind,2}';
dat = dat{:,2}';

fig2 = figure('DefaultAxesFontSize',16);
plot(dat, 'linewidth', 2);
xlabel('Time'); ylabel('Acoustic Amplitude')
xlim([0, 800])
title('Example dataset: Higher Frequency')
%% Save figures
fname = pp.presentation_foldername + "data_intro_";

saveas(fig1, fname+"lower.png");
saveas(fig2, fname+"higher.png");

%==========================================================================


%% 2: FFT analysis
% First do just Mortar, then all together
fname = "../intermediate/%s_fft.mat";

% Load in the data
tmp = sprintf(fname, "mortar");
dat_mortar = importdata(tmp);
tmp = sprintf(fname, "localized");
dat_localized = importdata(tmp);
tmp = sprintf(fname, "distributed");
dat_distributed = importdata(tmp);

% First, just plot Mortar
fig1 = figure('DefaultAxesFontSize',16);
histogram(dat_mortar.f(dat_mortar.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
xlabel('Frequency')
xlim([0.1 1.0])
title(sprintf('Frequency Peaks (Mortar)'))

% Second, add localized
fig2 = figure('DefaultAxesFontSize',16);
histogram(dat_mortar.f(dat_mortar.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
hold on
histogram(dat_mortar.f(dat_localized.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
xlabel('Frequency')
xlim([0.1 1.0])
title(sprintf('Frequency Peaks'))
legend({'Mortar', 'Localized'}, 'Location','northwest')

% Third, add distributed
fig3 = figure('DefaultAxesFontSize',16);
histogram(dat_mortar.f(dat_mortar.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
hold on
histogram(dat_mortar.f(dat_localized.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
histogram(dat_mortar.f(dat_distributed.all_locs), ...
    'BinWidth',0.025, 'Normalization','probability')
xlabel('Frequency')
xlim([0.1 1.0])
title(sprintf('Frequency Peaks'))
legend({'Mortar', 'Localized', 'Distributed'}, 'Location','northwest')
%% Save figures
fname = pp.presentation_foldername + "fft_histograms_";

saveas(fig1, fname+"mortar.png");
saveas(fig2, fname+"mortar_localized.png");
saveas(fig3, fname+"mortar_localized_distributed.png");

%==========================================================================



%% 3: DMD analysis
% Like above: Mortar, then others
fname = "../intermediate/%s_dmd_50aug.mat";

% Load in the data
tmp = sprintf(fname, "mortar");
dat_mortar = importdata(tmp);
tmp = sprintf(fname, "localized");
dat_localized = importdata(tmp);
tmp = sprintf(fname, "distributed");
dat_distributed = importdata(tmp);

% Get dominant TWO eigenvalues
for i = 1:size(dat_mortar.all_eigs,2)
    tmp = dat_mortar.all_eigs;
    mortar_dominant = [real(tmp(1,:)); imag(tmp(1,:));...
        real(tmp(3,:)); imag(tmp(3,:))]';
    tmp = dat_localized.all_eigs;
    localized_dominant = [real(tmp(1,:)); imag(tmp(1,:));...
        real(tmp(3,:)); imag(tmp(3,:))]';
    tmp = dat_distributed.all_eigs;
    distributed_dominant = [real(tmp(1,:)); imag(tmp(1,:));...
        real(tmp(3,:)); imag(tmp(3,:))]';
end

% First, just plot Mortar dominant eigenvalues
fig1 = figure('DefaultAxesFontSize',16);
plot(mortar_dominant(:,1),mortar_dominant(:,2), '.', 'linewidth', 2)
xlim([-0.1 0]); ylim([0.1, 1])
xlabel('Real (Growth or decay)'); ylabel('Imaginary (Oscillation)')
title(sprintf('Dominant DMD frequency (Mortar)'))

% Second, add localized
fig2 = figure('DefaultAxesFontSize',16);
plot(mortar_dominant(:,1),mortar_dominant(:,2), '.', 'linewidth', 2)
hold on
plot(localized_dominant(:,1),localized_dominant(:,2), '.', 'linewidth', 2)
xlim([-0.1 0]); ylim([0.1, 1])
xlabel('Real (Growth or decay)'); ylabel('Imaginary (Oscillation)')
title(sprintf('Dominant DMD frequency'))
legend({'Mortar', 'Localized'}, 'Location','southwest')

% Third, add distributed
fig3 = figure('DefaultAxesFontSize',16);
plot(mortar_dominant(:,1),mortar_dominant(:,2), '.', 'linewidth', 2)
hold on
plot(localized_dominant(:,1),localized_dominant(:,2), '.', 'linewidth', 2)
plot(distributed_dominant(:,1),distributed_dominant(:,2), ...
    '.', 'linewidth', 2)
xlim([-0.1 0]); ylim([0.1, 1])
xlabel('Real (Growth or decay)'); ylabel('Imaginary (Oscillation)')
title(sprintf('Dominant DMD frequency'))
legend({'Mortar', 'Localized', 'Distributed'}, 'Location','southwest')
%% Save figures
fname = pp.presentation_foldername + "dmd_dominant_";

saveas(fig1, fname+"mortar.png");
saveas(fig2, fname+"mortar_localized.png");
saveas(fig3, fname+"mortar_localized_distributed.png");

%==========================================================================



%% 4: DMDc analysis
%% Example for Mortar
fname = "../intermediate/%s_sra.mat";
% Load in the data
tmp = sprintf(fname, "mortar");
dat_mortar = importdata(tmp);
%---------------------------------------------
% Do DMDc
%---------------------------------------------
% Get data
i = 10;
fnames = pp.mortar_fnames;
dat = readtable(fnames{i});
dat = dat{1:1500,2}';

t = pp.read_time_of_test(fnames{i});
fprintf('Time of Mortar test: %s\n', duration(0,0,t));

U = dat_mortar.U_across_files(i,:);

% Time delay embed
aug = 20;
dat_embed = time_delay_embed(dat, aug);
% dat_embed = svd_truncate(dat_embed, 2);
% U_embed = U(:, aug+1:end);

% Build DMDc matrices and solve
X2 = dat_embed(:, 2:end);
n = size(X2, 1);

AB = X2/[dat_embed(:, 1:end-1); U];
A = AB(:, 1:n);
B = AB(:, (n+1):end);

% Reconstruction using the matrices
dat_reconstruction = zeros(size(dat_embed));
dat_reconstruction(:,1) = dat_embed(:, 1);
for i = 2:size(dat_embed, 2)
    dat_reconstruction(:, i) = A*dat_reconstruction(:, i-1) + B*U(:, i-1);
end

% Plot data, reconstruction, and control signal
plot_ind = 100:600;

fig1 = figure('DefaultAxesFontSize',16);
subplot(2,1,1)
plot(dat_embed(1,plot_ind), 'LineWidth',2)
hold on
plot(dat_reconstruction(1,plot_ind), 'LineWidth',2)
legend({'Data', 'Reconstruction'})
ylabel('Amplitude')
title('Example Mortar Dataset')

subplot(2,1,2)
plot(U(plot_ind), 'LineWidth',2)
legend('Learned Control Signal')
xlabel('Time')
ylabel('Amplitude')
%% Example for Localized
% First get the filenames with activity
fnames = pp.localized_fnames;
[all_dat, kept_ind] = pp.filter_by_activity(fnames);
kept_ind = find(kept_ind); % Note that the mortar data is much cleaner
%% Do dmdc and plot
fname = "../intermediate/%s_sra.mat";
% Load in the data
tmp = sprintf(fname, "localized");
dat_localized = importdata(tmp);
%---------------------------------------------
% Do DMDc
%---------------------------------------------
% Get data
% i = 36;%34;%29;
i = 153;%67;%10;%2;
% i = 67;%147;
dat = readtable(fnames{kept_ind(i)});
dat = dat{1:1500,2}';

t = pp.read_time_of_test(fnames{kept_ind(i)});
fprintf('Time of Localized test: %s\n', duration(0,0,t));

U = dat_localized.U_across_files(i,:);

% Time delay embed
aug = 20;
dat_embed = time_delay_embed(dat, aug);

% Build DMDc matrices and solve
X2 = dat_embed(:, 2:end);
n = size(X2, 1);

AB = X2/[dat_embed(:, 1:end-1); U];
A = AB(:, 1:n);
B = AB(:, (n+1):end);

% Reconstruction using the matrices
dat_reconstruction = zeros(size(dat_embed));
dat_reconstruction(:,1) = dat_embed(:, 1);
for i = 2:size(dat_embed, 2)
    dat_reconstruction(:, i) = A*dat_reconstruction(:, i-1) + B*U(:, i-1);
end

% Plot data, reconstruction, and control signal
plot_ind = 100:600;

fig2 = figure('DefaultAxesFontSize',16);
subplot(2,1,1)
plot(dat_embed(1,plot_ind), 'LineWidth',2)
hold on
plot(dat_reconstruction(1,plot_ind), 'LineWidth',2)
legend({'Data', 'Reconstruction'})
ylabel('Amplitude')
title('Example Localized Dataset')

subplot(2,1,2)
plot(U(plot_ind), 'LineWidth',2)
legend('Learned Control Signal')
xlabel('Time')
ylabel('Amplitude')
%% Save figures
fname = pp.presentation_foldername + "dmdc_";

saveas(fig1, fname+"mortar_example.png");
saveas(fig2, fname+"localized_example.png");

%==========================================================================



%% 5: Number of control signals
% Like above: Mortar, then others
pp = PurdueProject();
fname = "../intermediate/%s_sra.mat";

% Load in the data
tmp = sprintf(fname, "mortar");
dat_mortar = importdata(tmp);
tmp = sprintf(fname, "localized");
dat_localized = importdata(tmp);
% tmp = sprintf(fname, "distributed");
% dat_distributed = importdata(tmp);

% Get events
n = size(dat_mortar.U_across_files,1);
mortar_num_events = zeros(n,1);
for i = 1:n
%     event_starts = calc_contiguous_blocks(...
%         logical(dat_mortar.U_across_files(i,:)));
%     mortar_num_events(i) = length(event_starts);
    mortar_num_events(i) = nnz(dat_mortar.U_across_files(i,:));
end

n = size(dat_localized.U_across_files,1);
localized_num_events = zeros(n,1);
for i = 1:n
%     event_starts = calc_contiguous_blocks(...
%         logical(dat_localized.U_across_files(i,:)));
%     localized_num_events(i) = length(event_starts);
    localized_num_events(i) = nnz(dat_localized.U_across_files(i,:));
end
%% Histogram
fig1 = figure('DefaultAxesFontSize',16);
count_max = 30;
% h1 = cdfplot(mortar_num_events);
% h1.LineWidth = 2;
% hold on
% h2 = cdfplot(localized_num_events);
% h2.LineWidth = 2;
% ylabel('Cumulative Probability Distribution')
histogram(mortar_num_events(mortar_num_events>0), 'BinWidth',1, ...
    'Normalization', 'probability');
hold on
h = histogram(localized_num_events(localized_num_events>0),...
    [0:count_max, Inf], ...
    'Normalization', 'probability');
xlabel('Number of events')
legend({'Mortar', 'Localized'}, 'Location', 'northeast')
xlim([0, count_max+2])
title('Probability for number of events')

% Add a label for the overflow bin
xticks([xticks() count_max+1]);
xl = xticklabels(); 
xticklabels([xl(1:end-2); {''}; sprintf('>%d',count_max)]);
%% Save figures
fname = pp.presentation_foldername + "dmdc_hist_events_";

saveas(fig1, fname+"mortar_and_localized.png");

%==========================================================================








%% Exploration: distributed
fname = "../intermediate/%s_dmd.mat";

% Load in the data
tmp = sprintf(fname, "distributed");
dat_distributed = importdata(tmp);
%% 3rd dimension: time of crack
fnames = pp.distributed_fnames;
num_files = length(fnames);
% Plot DMD values vs. (real) time
crack_times = zeros(1, num_files);
for i = 1:num_files
    fprintf('File %d/%d\n', i, num_files);
    this_file = fnames{i};
    crack_times(i) = pp.read_time_of_test(this_file);
end

h = crack_times;
% Remove the extremely late events (days later)
% thresh = median(h);
% h(h>thresh) = 1e-5;
% h = log(1 + h);

% Look at difference in times instead
[sort_times, sort_ind] = sort(crack_times, 'ascend');
h = [diff(sort_times) 0];
%% Instead, amplitude of event
fnames = pp.distributed_fnames;
num_files = length(fnames);

h = zeros(1,num_files);
size_func = @(x) max(abs(x));
% color_func = @(x) max(svd(x))/sum(svd(x));
for i = 1:num_files
    fprintf('File %d/%d\n', i, num_files);
    dat = readtable(fnames{i});
    % Remove rise
    ind = dat{:,1} > 0;
    dat = dat{ind,2}';
    
    h(i) = size_func(dat);
end
%% Instead, number of frequencies present
h = dat_distributed.all_aic_mins;
%% Plot
figure
plot3(distributed_dominant(:,1),distributed_dominant(:,2),...
    h, '.', 'linewidth', 2)
xlabel('Real')
zlim([min(h), 10*median(h)])
xlim([-0.1, 0])
ylabel('Imaginary')
zlabel('Time of event')
% zlabel('Interval before event')
% zlabel('Amplitude of event')
% zlabel('Number of frequencies present')
title('Distributed Datasets')

%% Plot SORTED
figure
plot3(distributed_dominant(sort_ind,1),distributed_dominant(sort_ind,2),...
    h, '.', 'linewidth', 2)
xlabel('Real')
zlim([min(h), 10*median(h)])
ylabel('Imaginary')
% zlabel('Time of event')
zlabel('Interval before event')
% zlabel('Amplitude of event')
% zlabel('Number of frequencies present')
title('Distributed Datasets')

%% Plot 2: second frequency
figure
plot3(distributed_dominant(:,1),distributed_dominant(:,2),...
    h, '.', 'linewidth', 2)
hold on
ind = h==2;
plot3(distributed_dominant(ind,3),distributed_dominant(ind,4),...
    h(ind), '.', 'linewidth', 2)
ind = h==3;
plot3(distributed_dominant(ind,3),distributed_dominant(ind,4),...
    h(ind), '.', 'linewidth', 2)
xlabel('Real')
zlim([min(h), 10*median(h)])
xlim([-0.1 0])
ylabel('Imaginary')
% zlabel('Time of event')
% zlabel('Amplitude of event')
zlabel('Number of frequencies present')
title('Distributed Datasets')
legend({'Dominant frequency', 'Secondary Frequency', 'Third frequency'})

%==========================================================================




%% Email: other example DMDc
%% Example for Mortar
fname = "../intermediate/%s_sra.mat";
% Load in the data
tmp = sprintf(fname, "mortar");
dat_mortar = importdata(tmp);
%---------------------------------------------
% Do DMDc
%---------------------------------------------
% Get data
i = 123;
fnames = pp.mortar_fnames;
dat = readtable(fnames{i});
dat = dat{1:1500,2}';

U = dat_mortar.U_across_files(i,:);

% Time delay embed
aug = 20;
dat_embed = time_delay_embed(dat, aug);
% dat_embed = svd_truncate(dat_embed, 2);
% U_embed = U(:, aug+1:end);

% Build DMDc matrices and solve
X2 = dat_embed(:, 2:end);
n = size(X2, 1);

AB = X2/[dat_embed(:, 1:end-1); U];
A = AB(:, 1:n);
B = AB(:, (n+1):end);

% Reconstruction using the matrices
dat_reconstruction = zeros(size(dat_embed));
dat_reconstruction(:,1) = dat_embed(:, 1);
for i = 2:size(dat_embed, 2)
    dat_reconstruction(:, i) = A*dat_reconstruction(:, i-1) + B*U(:, i-1);
end

%% Plot data, reconstruction, and control signal
plot_ind = 1:1000;

fig1 = figure('DefaultAxesFontSize',16);
subplot(2,1,1)
plot(dat_embed(1,plot_ind), 'LineWidth',2)
hold on
plot(dat_reconstruction(1,plot_ind), 'LineWidth',2)
legend({'Data', 'Reconstruction'})
ylabel('Amplitude')
title('Mortar Dataset')
ylim([-0.05, 0.05])

subplot(2,1,2)
plot(U(plot_ind), 'LineWidth',2)
legend('Learned Control Signal')
xlabel('Time')
ylabel('Amplitude')
title(sprintf('Poor signal reconstruction: %d "events"', nnz(U)))
%% Example for Localized
% First get the filenames with activity
fnames = pp.localized_fnames;
[all_dat, kept_ind] = pp.filter_by_activity(fnames);
kept_ind = find(kept_ind); % Note that the mortar data is much cleaner
%% Do dmdc and plot
fname = "../intermediate/%s_sra.mat";
% Load in the data
tmp = sprintf(fname, "localized");
dat_localized = importdata(tmp);
%---------------------------------------------
% Do DMDc
%---------------------------------------------
% Get data
i = 44;%172;%207;%34;%29;
dat = readtable(fnames{kept_ind(i)});
dat = dat{1:1500,2}';

U = dat_localized.U_across_files(i,:);

% Time delay embed
aug = 20;
dat_embed = time_delay_embed(dat, aug);
% dat_embed = svd_truncate(dat_embed, 2);
% U_embed = U(:, aug+1:end);

% Build DMDc matrices and solve
X2 = dat_embed(:, 2:end);
n = size(X2, 1);

AB = X2/[dat_embed(:, 1:end-1); U];
A = AB(:, 1:n);
B = AB(:, (n+1):end);

% Reconstruction using the matrices
dat_reconstruction = zeros(size(dat_embed));
dat_reconstruction(:,1) = dat_embed(:, 1);
for i = 2:size(dat_embed, 2)
    dat_reconstruction(:, i) = A*dat_reconstruction(:, i-1) + B*U(:, i-1);
end

%% Plot data, reconstruction, and control signal
plot_ind = 1:1000;

fig2 = figure('DefaultAxesFontSize',16);
subplot(2,1,1)
plot(dat_embed(1,plot_ind), 'LineWidth',2)
hold on
plot(dat_reconstruction(1,plot_ind), 'LineWidth',2)
legend({'Data', 'Reconstruction'})
ylabel('Amplitude')
title('Localized Dataset')
ylim([-0.05, 0.05])

subplot(2,1,2)
plot(U(plot_ind), 'LineWidth',2)
legend('Learned Control Signal')
xlabel('Time')
ylabel('Amplitude')
title(sprintf('Poor signal reconstruction: %d "events"', nnz(U)))
%% Save figures
fname = pp.presentation_foldername + "dmdc_email_earlier2_";

% saveas(fig1, fname+"mortar_example.png");
saveas(fig2, fname+"localized_example.png");

%==========================================================================


