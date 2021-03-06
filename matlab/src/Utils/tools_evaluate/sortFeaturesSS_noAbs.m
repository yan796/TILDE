%% sortFeaturesSS_noAbs.m --- 
% 
% Filename: sortFeaturesSS_noAbs.m
% Description: 
% Author: Yannick Verdie, Kwang Moo Yi
% Maintainer: Yannick Verdie, Kwang Moo Yi
% Created: Tue Jun 16 17:14:58 2015 (+0200)
% Version: 
% Package-Requires: ()
% Last-Updated: Tue Jun 16 17:15:02 2015 (+0200)
%           By: Kwang
%     Update #: 1
% URL: 
% Doc URL: 
% Keywords: 
% Compatibility: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%% Commentary: 
% 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%% Change Log:
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Copyright (C), EPFL Computer Vision Lab.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%% Code:


function [feat] = sortFeaturesSS_noAbs(features,  p, sortOnScale)

if ~exist('sortOnScale','var')
    sortOnScale = 0;
end

% warning('threshold hardcoded to zero here');
thrs = -Inf;

if exist('p','var')
    if isfield(p,'nbFeat')
        nbFeat = p.nbFeat;
    end
end

    feat = cell(1,size(features,2));
    for i = 1:size(features,2)
        cr = features{i}(1:2,:);
        if sortOnScale
            score = (features{i}(6,:));           
        else
            score = (features{i}(5,:));
        end

        bDoAdaptiveNMS = false;
        if exist('p','var')
            if isfield(p,'bDoAdaptiveNMS')
                bDoAdaptiveNMS = p.bDoAdaptiveNMS;
            end
        end
        
        if bDoAdaptiveNMS
            I = features{i}(1,:)';
            J = features{i}(2,:)';
            [I,J] = adaptiveNMSWithPoints(I,J,score,nbFeat);
            feat{i} = [I';J'];
        else
            [v, idx2] = sort(score,'descend');
            %position of first smaller than thrs
            ix = find(v >= thrs, 1, 'last');
            stop = uint8(min([nbFeat size(v,2) ix]));
            feat{i} = features{i}(:,idx2(1:stop));
        end
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sortFeaturesSS_noAbs.m ends here
