% This function calculates the potential vorticity field at a given level z (level_ind) for a given file (ifile). 
% The funtion is called as part of a main program with previously calculated temperature gradients and vorticity 
% Both the temperature gradients and vorticity fields are 3D and have three
% components each i.e. vorticity_x(:,:,:) vort_y(:,:,:) vort_z(:,:,:)


function [] = simulations_calculate_PV_coding_BOG(ifile, level_ind)
% using global paths "basdir", "subbasdir" and coordinate z
global basedir subbasedir z  

% constants
f = 0.729e-4 ; %Coriolis parameter from 
galpha = 1.962e-3;              %conversion from T to b (Ttob)

    
% path for vorticity and temperature gradients
subdir = fullfile(subbasedir,'Gradients',['run',num2str(ifile)]);

% Defining grad_temp and vorticity objects to load data
grad_temp_object = matfile(fullfile(basedir,subdir,'grad_temp.mat')) ;
vorticity_object = matfile(fullfile(basedir,subdir,'vorticity.mat')) ;


% Potential Vorticity = galpha*( dT/dx * vorticity_x  +  dT/dy *
% vorticity_y  +  dT/dz *(f + vorticity_z) )

% calculate vorticity for every surface level "level_ind"
PV = galpha*squeeze(grad_temp_object.temp_dx(:,:,level_ind).*(vorticity_object.vort_x(:,:,level_ind))...
    + grad_temp_object.temp_dy(:,:,level_ind).*(vorticity_object.vort_y(:,:,level_ind))...
    + grad_temp_object.temp_dz(:,:,level_ind).*(f + (vorticity_object.vort_z(:,:,level_ind)))); 

%%

% saving the final file
subdir_PV = fullfile(subbasedir,'PV',['zlevel',num2str(z(level_ind))],['run',num2str(ifile)]);
mkdir(fullfile(basedir,subdir_PV))
save(fullfile(basedir,subdir_PV,'PV.mat'), 'PV', '-v7.3');

end



