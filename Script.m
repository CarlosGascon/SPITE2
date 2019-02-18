%% Script to run the simulations
clear all; close all; clc;

%% Data Input

TargetList1 = {'24 Sex', ['b', 'c']; 
              '47 UMa', ['b', 'c', 'd']
              '55 Cnc', ['b', 'c', 'f']
              'HD 10180', ['c', 'e', 'f', 'h']};
          
TargetList2 = {'11 Com', ['b'] 
               '14 And', ['b']
               '18 Del', ['b']
               '24 Boo', ['b']
               '24 Sex', ['b']
               '47 UMa', ['b']
               '55 Cnc', ['b']
               '6 Lyn',  ['b']
               '61 Vir', ['b']
               '7 CMa',  ['b']
               '70 Vir', ['b']
               'GJ 163', ['b']
               'GJ 667 C',['b']
               'GJ 674', ['b']
               'GJ 876', ['b']
               'HATS-4', ['b']
               'HATS-5', ['b']};  
TargetList3 = {'47 UMa', ['b', 'c', 'd']};

TargetList4 = {'47 UMa', ['b', 'd']
               'HD 141399', ['b', 'c', 'd'] 
               '55 Cnc', ['b', 'c', 'f']
               'HD 27894',['b', 'c']};

Norb = 50;

YearsSim = 1e7;

Ncores = 16;

Nexo = 1;

%% Run Simulation and Output

Stability = Run_Sims(TargetList3, Nexo, Norb, YearsSim, Ncores);