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
% 1) 'Simple', 2) 'Check_Walls', 3) 'Check_Lanes'
mode = 'Simple';


if strcmp(mode, 'Simple')
    %% Inputs
    inputs;

    %% Initial plot
    postprocess;

    %% Calculate
    solver;

    %% Plots
    postprocess;

elseif strcmp(mode, 'Check_Walls')

    for loop=1:4
        %% Inputs
        inputs;

        %% Calculate
        solver;

        %% Plots
        postprocess;
    end

end

clear dt fluxx fluxy i ii lamdau lamdav shiftp2 shiftm2 shiftm1 shiftp1
clear told tplot uold Uold vold ii iii numplots  tplot
clear ylh xlh k filename i im imind s cm store ycall xc zc