%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main File ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%% FINAL PROJECT
%  TUM - Ass. Professorship for Thermo Fluid Dynamics
%  WS022-023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program models the waves in a swimming pool with Shallow Water
% Equations using Finite Volume Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all;

%% Solution Mode
% CHOOSE BETWEEN DIFFERENT SOLUTION MODES
% 1) 'Simple', 2) 'Check_Walls', 3) 'Check_Lanes'
mode = 'Check_Walls';


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

end

clear dt fluxx fluxy i ii lamdau lamdav shiftp2 shiftm2 shiftm1 shiftp1
clear told tplot uold Uold vold ii iii numplots  tplot
clear ylh xlh k filename i im imind s cm ycall xc zc