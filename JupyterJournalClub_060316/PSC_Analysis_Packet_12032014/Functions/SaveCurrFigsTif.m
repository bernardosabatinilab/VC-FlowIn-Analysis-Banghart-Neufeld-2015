function SaveCurrFigsTif(title_handles,ChooseDir_on_off)

% saveCurrFigsTiff saves all open figures as tiff files in either the
% current directory (if no inputs) or in a user selected directory.
% ChooseDir_on_off tells the program to prompt a new directory to save in
% ('on') or not ('off'). Alternatively, if there is no second input, the
% program automatically saves to the current directory.

if nargin == 1 || strcmpi(ChooseDir_on_off,'off')
    
    for iFig = 1:gcf
        saveas(iFig,get(title_handles(iFig),'String'),'tif');
    end
    
elseif strcmpi(ChooseDir_on_off,'on')
    savepath = uigetdir;
    cd(savepath);
    
    for iFig = 1:gcf
        saveas(iFig,get(title_handles(iFig),'String'),'tif');
    end
    
end

%Shay
%6/21/13


end


