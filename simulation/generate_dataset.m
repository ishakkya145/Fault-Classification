%% RELAY-1: GENERATE FAULT RECORDINGS
% Adapted from Gen_20.m; simulation settings and random seed retained.
clear; clc;
bdclose('all');

%% Model
modelFolder = fileparts(mfilename('fullpath'));
repositoryFolder = fileparts(modelFolder);

model = 'IEEE_14_Final';
modelFile = fullfile(modelFolder,[model '.slx']);

cd(modelFolder);
load_system(modelFile);

fprintf('Loaded model:\n%s\n\n',get_param(model,'FileName'));

%% Settings
Ncases = 2000;

fs = 6000;
Ts = 1/fs;
Tstop = 0.2;
N = round(Tstop/Ts) + 1;

VbaseLL = 33e3;
Sbase = 25e6;

VbasePeak = sqrt(2)*VbaseLL/sqrt(3);
IbasePeak = sqrt(2)*Sbase/(sqrt(3)*VbaseLL);

Rf = 0.01;
Rg = 0.001;

rng(11001);

%% Solver + speed settings
set_param(model, ...
    'SolverType','Fixed-step', ...
    'Solver','FixedStepDiscrete', ...
    'FixedStep',num2str(Ts,17), ...
    'StartTime','0', ...
    'StopTime',num2str(Tstop,17), ...
    'AlgebraicLoopMsg','none', ...
    'SignalLogging','off', ...
    'SaveOutput','off', ...
    'SaveTime','off');

%% Fault types
faultNames = ["AG","BG","CG","AB","AC","BC", ...
              "ABG","ACG","BCG","ABC","ABCG"];

% [A B C Ground]
faultConfig = {
    'on','off','off','on'
    'off','on','off','on'
    'off','off','on','on'
    'on','on','off','off'
    'on','off','on','off'
    'off','on','on','off'
    'on','on','off','on'
    'on','off','on','on'
    'off','on','on','on'
    'on','on','on','off'
    'on','on','on','on'
};

%% Lines
lineNames   = ["L01_02","L03_04","L06_11","L09_10"];
lineLengths = [20 18 8 10];

faultBlocks = [
    string(model)+"/Fault line 01-02"
    string(model)+"/Fault line 03-04"
    string(model)+"/Fault line 06-11"
    string(model)+"/Fault line 09-10"
];

segmentA = [
    string(model)+"/Line_01_02_Segment_A"
    string(model)+"/Line_03_04_Segment_A"
    string(model)+"/Line_06_11_Segment_A"
    string(model)+"/Line_09_10_Segment_A"
];

segmentB = [
    string(model)+"/Line_01_02_Segment_B"
    string(model)+"/Line_03_04_Segment_B"
    string(model)+"/Line_06_11_Segment_B"
    string(model)+"/Line_09_10_Segment_B"
];

%% Output folder
outputFolder = fullfile(repositoryFolder, 'data', 'raw', ...
    ['IEEE14_R1_' datestr(now,'yyyymmdd_HHMMSS')]);

if isfolder(outputFolder)
    error('Output folder already exists: %s', outputFolder);
end

mkdir(outputFolder);

%% Initial reset
for k = 1:4

    set_param(char(faultBlocks(k)), ...
        'FaultA','off', ...
        'FaultB','off', ...
        'FaultC','off', ...
        'GroundFault','off', ...
        'SwitchTimes','[100 100.1]');

    set_param(char(segmentA(k)), ...
        'Length',num2str(lineLengths(k)/2));

    set_param(char(segmentB(k)), ...
        'Length',num2str(lineLengths(k)/2));
end

fprintf('Generating %d cases...\n\n',Ncases);

totalTimer = tic;
previousLine = 0;

%% Generate
for n = 1:Ncases

    %% Restore only previous faulted line
    if previousLine > 0

        k = previousLine;

        set_param(char(faultBlocks(k)), ...
            'FaultA','off', ...
            'FaultB','off', ...
            'FaultC','off', ...
            'GroundFault','off', ...
            'SwitchTimes','[100 100.1]');

        set_param(char(segmentA(k)), ...
            'Length',num2str(lineLengths(k)/2));

        set_param(char(segmentB(k)), ...
            'Length',num2str(lineLengths(k)/2));
    end

    %% Random fault
    lineIndex = randi(4);
    typeIndex = randi(11);

    L = lineLengths(lineIndex);

    %% Random location 10%-90%
    faultLocation = 0.10 + 0.80*rand;

    LA = L*faultLocation;
    LB = L-LA;

    set_param(char(segmentA(lineIndex)), ...
        'Length',num2str(LA,17));

    set_param(char(segmentB(lineIndex)), ...
        'Length',num2str(LB,17));

    %% Random fault time
    faultStart = 0.04 + 0.06*rand;
    faultDuration = 0.03 + 0.03*rand;
    faultEnd = faultStart + faultDuration;

    %% Apply fault
    fb = char(faultBlocks(lineIndex));

    set_param(fb, ...
        'FaultA',faultConfig{typeIndex,1}, ...
        'FaultB',faultConfig{typeIndex,2}, ...
        'FaultC',faultConfig{typeIndex,3}, ...
        'GroundFault',faultConfig{typeIndex,4}, ...
        'FaultResistance',num2str(Rf,17), ...
        'GroundResistance',num2str(Rg,17), ...
        'SwitchTimes',sprintf('[%.6f %.6f]', ...
        faultStart,faultEnd));

    %% Simulate
    simTimer = tic;

    out = sim(model,'ReturnWorkspaceOutputs','on');

    simTime = toc(simTimer);

    %% Relay-1 data
    raw = out.get('R1_data');

    if isa(raw,'timeseries')
        relayData = squeeze(raw.Data);

    elseif isstruct(raw)
        relayData = squeeze(raw.signals.values);

    else
        relayData = squeeze(raw);
    end

    if size(relayData,1) == 6
        relayData = relayData.';
    end

    if size(relayData,1) ~= N || size(relayData,2) ~= 6
        error('R1_data is %d x %d; expected %d x 6.', ...
            size(relayData,1),size(relayData,2),N);
    end

    %% Per-unit
    faultData = single(relayData);

    faultData(:,1:3) = faultData(:,1:3)/VbasePeak;
    faultData(:,4:6) = faultData(:,4:6)/IbasePeak;

    t = single((0:N-1)'*Ts);

    %% Metadata
    metadata.FaultType = faultNames(typeIndex);
    metadata.FaultLine = lineNames(lineIndex);
    metadata.FaultLocation = faultLocation;

    metadata.DistanceA_km = LA;
    metadata.DistanceB_km = LB;

    metadata.FaultStart_s = faultStart;
    metadata.FaultEnd_s = faultEnd;

    metadata.Rf_Ohm = Rf;
    metadata.Rg_Ohm = Rg;

    metadata.fs_Hz = fs;
    metadata.SimulationTime_s = simTime;

    %% Save
    fileName = sprintf('R1_Case_%03d_%s_%s.mat', ...
        n,faultNames(typeIndex),lineNames(lineIndex));

    save(fullfile(outputFolder,fileName), ...
        'faultData','t','metadata');

    previousLine = lineIndex;

    %% Progress
    elapsed = toc(totalTimer);
    avgTime = elapsed/n;
    ETA = avgTime*(Ncases-n);

    fprintf(['%02d/%02d  %-4s %-6s  %.1f%% | ' ...
             'Sim %.2f s | ETA %.1f min\n'], ...
        n,Ncases, ...
        faultNames(typeIndex), ...
        lineNames(lineIndex), ...
        faultLocation*100, ...
        simTime,ETA/60);
end

%% Restore final line
if previousLine > 0

    k = previousLine;

    set_param(char(faultBlocks(k)), ...
        'FaultA','off', ...
        'FaultB','off', ...
        'FaultC','off', ...
        'GroundFault','off', ...
        'SwitchTimes','[100 100.1]');

    set_param(char(segmentA(k)), ...
        'Length',num2str(lineLengths(k)/2));

    set_param(char(segmentB(k)), ...
        'Length',num2str(lineLengths(k)/2));
end

%% Final report
totalTime = toc(totalTimer);

fprintf('\n==============================\n');
fprintf('DONE ✅\n');
fprintf('Total cases:          %d\n',Ncases);
fprintf('Total time:           %.2f min\n',totalTime/60);
fprintf('Average per case:     %.2f s\n',totalTime/Ncases);
fprintf('Files saved in:\n%s\n',outputFolder);
fprintf('==============================\n');