function TR_PlateDiameter(RGapp, displayH)

% enter external plate diameter in mm (current plates 55 mm)
% Select image of plate from above at the same settings in which the
% videos are taken
% find bounding box of circle and extract diameter in pixels from that
% calculate and return mm per pixel

% TREX provides X-Y data in cm, using a default value of 30 cm as the image
% width. Use this value to recalibrate the data to the correct size
% To ignore this conversion (if for example TREX is correct) assign 0 to TREX_meta_real_width

TREX_meta_real_width = 30; % default TREX image width in cm

[Filename, Filepath] = uigetfile('*.*','Please select a file');
if Filename ~= 0
    im = imread(fullfile(Filepath,Filename));
    if ~ismatrix(im)
        im = rgb2gray(im);
    end
    im_bw = imbinarize(im);
    im_bw = imcomplement(im_bw);

    WidthPIX = size(im_bw,2);
%     s = regionprops(im_bw, 'Area', 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    s = regionprops(im_bw, 'Area', 'Centroid', 'BoundingBox');
    areas = [s.Area].';
    [~, amxid] = max(areas);
    s2 = s(amxid);
    Center = s2.Centroid;
    DiameterPIX = max(s2.BoundingBox(3:4)); % plate diameter in pixels
    MMperPIX = RGapp.Experiment.Specs.Analysis.Parameters.PlateDiam / DiameterPIX; % actual mm per pixel
    % if conversion from TREX scale to real scale is required, calculate
    % the conversion factor
    if TREX_meta_real_width>0
        WidthMM = WidthPIX*MMperPIX; % actual image width in mm
        RGapp.Experiment.Specs.Analysis.Parameters.TREXcm2cm = WidthMM/(TREX_meta_real_width*10); 
    end
    RGapp.Experiment.Specs.Analysis.Parameters.mm_pix = MMperPIX; % mm/pix
    
%     displayH.NextPlot = 'replacechildren';
%     displayH.Visible = 1;
%     image(displayH,im);
%     colormap(displayH,gray);
%     pos = [Center(1)-DiameterPIX/2, Center(2)-DiameterPIX/2, DiameterPIX, DiameterPIX];
%     displayH.NextPlot = 'add';
%     rectangle(displayH,'Position',pos,'Curvature',[1 1],'EdgeColor', 'red');
% %     viscircles(Center,DiameterPIX/2);
%     displayH.NextPlot = 'replacechildren';
end

