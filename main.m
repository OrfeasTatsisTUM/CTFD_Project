%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main File ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%% FINAL PROJECT
%  TUM - Ass. Professorship for Thermo Fluid Dynamics
%  WS022-023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is modeling different kind of waves in a swimming pool using
% Shallow Water Equations and applying them with the Lax-Friedrich Method. 
% The scope of the program is to evaluate what influence has the depth and 
% the wall shape of the pool on the waves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all;

%% Solution Mode
% CHOOSE BETWEEN DIFFERENT SOLUTION MODES
% 1) 'Simple', 2) 'Check_Walls', 3) 'Check_Lanes', 4)'Check_Depth'
% Check Lanes doesn't work
% 'Check
mode = 'Simple';


if strcmp(mode, 'Simple')           % SIMPLE MODE: Solves for one chosen Wall Shape and extracts the GIFs
    %% Inputs
    inputs;

    %% Initial plot
    postprocess;

    %% Calculate
    solver;

    %% Plots
    postprocess;

elseif strcmp(mode, 'Check_Walls')   % CHECK_WALLS MODE: Solves for all different Wall Shapes and compares the results

    for loop=1:4  % 4 different wall cases
        %% Inputs
        inputs;

        %% Calculate
        solver;

        %% Plots
        postprocess;

        if loop ~=4; clearvars -except mode loop; end
    end

elseif strcmp(mode, 'Check_Lanes')  % floating lines are wrong

    for loop=1:2  % 1: Lanes ON, 2: Lanes OFF
        %% Inputs
        inputs;

        %% Calculate
        solver;

        %% Plots
        postprocess;

        if loop == 1; clearvars -except mode loop; end
    end

elseif strcmp(mode, 'Check_Depth')   % CHECK_DEPTHS MODE: Solves for differnt pool depths

    for d=1:2:5 
        %% Inputs
        inputs;

        %% Calculate
        solver;

        %% Plots
        postprocess;

        if d ~=5; clearvars -except mode loop; end
    end

end

clear dt fluxx fluxy i ii lamdau lamdav shiftp2 shiftm2 shiftm1 shiftp1
clear told tplot uold Uold vold ii iii numplots  tplot
clear ylh xlh k filename i im imind s cm