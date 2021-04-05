function [ events ] = getGaitEvents_MC10HD_ccThighAccelerometer_T25FW_Jan2021(aT,aC,sf,time,minimumStrideTime,maximumStrideTime,nMinimumStridesPerBout,minimumDutyFactor,maximumDutyFactor)
%Reed Gurchiek, 2019
%   identifies instants of stride start (foot contact) and swing start
%   (foot off) given accelerometer signal aligned with long axis of thigh
%   during 8 seconds of walking data
%
% 
%  Note: This version of this script includes chest data to help parse strides. 
%  aT is cc thigh acceleration, aC is cc chest acceleration - SRF
%
%----------------------------------INPUTS----------------------------------
%
%   a:
%       1xn, 8 seconds of accelerometer data, aligned with long axis of
%       thigh
% 
%
%   sf:
%       sampling frequency (Hz)
%
%   time:
%       1xn, time array
%
%   minimumStrideTime,maximumStrideTime:
%       minimum and maximum allowable stride times. Any strides out of
%       these bounds will be removed.
%   minimumDutyFactor, maximumDutyFactor
%       min and max allowable duty factor, 0.0 - 1.0
%
%   nMinimumStridesPerBout:
%       minimum number of strides that must be extracted. If the number of
%       identified strides is less than nMinimumStridesPerBout, then the
%       deleteBout flag will be set to 1
%
%---------------------------------OUTPUTS----------------------------------
%
%   events:
%       struct, fields:
%           (1) deleteBout: if 1 then bout should be deleted
%           (2) strideStart: time associated with best estimate of stride
%           start instant (foot contact)
%           (3) swingStart: time associated with best estimate of swing
%           start instant (foot off)
%
%--------------------------------------------------------------------------
%% get_gaitEvents_ccThighAccelerometer

% time step and initialize vars
dt = 1/sf;
strideStart = [];
swingStart = [];
% deleteBout logical
deleteBout = 0;

% low pass at 5
    aT5 = bwfilt(aT,5,sf,'low',4);
    aC5 = bwfilt(aC,5,sf,'low',4);


%% Examine f content of raw signal

L = length(time); % length of signal 
n = 2^nextpow2(L); 

% extract spectrum from FFT of accel. signal
yT = fft(aT,n);  % time to f domain
yC = fft(aC,n);

f = sf*(0:(n/2))/n ; % define frequencies 

% Compute 2-sided spectrum
P2T = abs(yT/n); 
P2C = abs(yC/n);
% Compute single-sided spectrum 
P1T = 2*P2T(1:n/2+1); 
P1C = 2*P2C(1:n/2+1); 


%% Get Power Spectral Density 

% expecting a peak at step frequency (most dominant for lower
% frequencies) and a peak below this for stride freq
    % first Thigh
    [fpow_T,freq_T] = pwelch(aT- mean(aT),rectwin(round(sf*2)),[],4096,sf); % window @ 2 seconds
    % then for chest data
    [fpow_C,freq_C] = pwelch(aC- mean(aC),rectwin(round(sf*2)),[],4096,sf); % window @ 2 seconds
    
%% Find largest chest peak 

% remove frequencies < 0.5 Hz and > 4 Hz for T
    fpow_T(freq_T < 0.5 | freq_T > 4) = [];
    freq_T(freq_T < 0.5 | freq_T > 4) = [];
% remove frequencies < 0.5 Hz and > 4 Hz for C
    fpow_C(freq_C < 0.5 | freq_C > 4) = [];
    freq_C(freq_C < 0.5 | freq_C > 4) = [];

% get peaks and remove endpoints
% Thigh
    [~,ipow_T] = extrema(fpow_T);
    ipow_T(ipow_T == 1) = []; ipow_T(ipow_T == length(fpow_T)) = [];
% Chest
    [~,ipow_C] = extrema(fpow_C);
    ipow_C(ipow_C == 1) = []; ipow_C(ipow_C == length(ipow_C)) = [];
    
% get peak frequencies and power
% Thigh
    freq_T = freq_T(ipow_T); % there are the f that correspond to the peaks
    fpow_T = fpow_T(ipow_T);
% Chest
    freq_C = freq_C(ipow_C);
    fpow_C = fpow_C(ipow_C);

% initialize some varaible
stpf_C = [];strf_T = []; stpf_T = [];
    
    
% get max chest frequency (approximate step frequency)
    [~,imax_C] = max(fpow_C); 
    stpf_C = freq_C(imax_C);

% Thigh peak closest to max chest peak = approx step f. Thigh data is
% more accurate than chest data 
% Thigh
    freq_Tminus = freq_T - stpf_C; 
    [minValue, closestInd] = min(abs(freq_Tminus));
    closestValue = freq_T(closestInd); 
    stpf_T = closestValue;

if closestInd == 1
    closestInd_adjust = 1;
else
    closestInd_adjust = closestInd - 1;
end
% Calculate stride frequency for Thigh
if ~isempty(freq_T(closestInd_adjust))
    strf_T = freq_T(closestInd_adjust);
else
    deleteBout = 1;
end

% if empty then delete
if isempty(stpf_C) || isempty(strf_T) || isempty(stpf_T)

    deleteBout = 1;

else
    % low pass at stepf and strf
    astp_T = bwfilt(aT,stpf_T,sf,'low',4);
    astr_T = bwfilt(aT,strf_T,sf,'low',4);

    % get minima/maxima of stride/step filtered signals
    clear imax
    [~,imax.str,~,imin.str] = extrema(astr_T);
    [~,imax.stp,~,imin.stp] = extrema(astp_T);
    [~,imax.aT5,~,imin.aT5] = extrema(aT5);
    

    
    % Find any peaks in a5 signal - these could be FC peaks
    [a5pks, a5locs] = findpeaks(aT5);
    
     % remove endpoints
    imin.str(imin.str == 1) = []; 
    imax.str(imax.str == 1) = []; 
    imax.stp(imax.stp == 1) = [];
    imin.stp(imin.stp == 1) = [];
    imin.str(imin.str == length(astr_T)) = []; 
    imax.str(imax.str == length(astr_T)) = [];
    imax.stp(imax.stp == length(astr_T)) = [];
    imin.stp(imin.stp == length(astr_T)) = [];
    imax.aT5(imax.aT5 == 1) = [];
    imax.aT5(imax.aT5 == length(astr_T)) = [];
    imin.aT5(imin.aT5 == 1) = [];
    imin.aT5(imax.aT5 == length(astr_T)) = [];
    
%     iminOG = imin.str;
     % get instants where z low passed at 5 crosses 1 g
    icrossg = crossing0(aT5-1,{'n2p'});
    
%     figure()
%     plot(time,aT5)
%     hold on
%     plot(time,astr_T)
%     hold on
%     scatter(time(imin.str),astr_T(imin.str),'m')

    minstr_save = imin.str;
    
    % sometimes false minima identified within stride
    % require minima be within min and max stride times
    i = 1;
    while i <= length(imin.str) - 1
        if imin.str(i+1)-imin.str(i) < floor(minimumStrideTime*sf)
            imin.str(i+1) = [];
%             imin.strdeleted = imin.str(i+1);
        elseif imin.str(i+1)-imin.str(i) > ceil(maximumStrideTime*sf)
            imin.str(i) = [];
%             imin.strdeleted = imin.str(i);
        else
            i = i + 1;
        end
    end
    
 
    % need at least 2 more minima than nMinimumStridesPerBout
    if length(imin.str) < nMinimumStridesPerBout + 2
        
        deleteBout = 1;

    else
        % gait phase detection algorithm:
        % get last step peak between stride minima = swing start
        % get following valley for each stride peak ~ FC
        % next 1g crossing is best estimate of FC
        
        % Define prior to entering while loop
        approxST = 1/strf_T;
        
        % for each minima
        swingStart = zeros(1,length(imin.str) - 1);
        strideStart = zeros(1,length(imin.str)-1);
        i = 1;
        while i <= length(imin.str)-1

            deleteStride = 0;

            % get zstp peaks between current and next str minima
            swingStart0 = imax.stp(imax.stp > imin.str(i) & imax.stp < imin.str(i+1));

            % if empty then delete
            if isempty(swingStart0)
                deleteStride = 1;
            % otherwise
            else

               if length(swingStart0) > 1 
        
    
                    % throw out pks within 25% of approximate stride time -
                    % Aminian 1999 selected 30%
                    buffer = .25*approxST;
                    bufferIndx = buffer*sf;
                   
                    l = 1;
                    while l <= length(swingStart0)
                        if swingStart0(l) < imin.str(i) + bufferIndx || swingStart0(l) > imin.str(i+1) - bufferIndx
                            swingStart0(l) = [];
                        else 
                            l = l+1;
                        end
                    end       
                    
                    if isempty(swingStart0)
                        deleteStride = 1;
                    else
                        % take the largest peak
                         [~,swingStart00] = max(astp_T(swingStart0));
                         swingStart0 = swingStart0(swingStart00); 
                    end
                end
                
                % new, hope this works
                if isempty(swingStart0)
                    deleteStride = 1;
                else

                    % get swing start
                    swingStart(i) = time(swingStart0);

                    % get next valley
                    strideStart0 = imin.stp(swingStart0 < imin.stp);

                    % if is empty then delete
                    if isempty(strideStart0)
                        deleteStride = 1;

                    % also require this valley be less than 1g
                    elseif astp_T(strideStart0(1)) >= 1
                        deleteStride = 1;

                    else

                        % get next instant where a5 crossed 1g
                        crossg = icrossg(icrossg > strideStart0(1));

                        % if none then delete
                        if isempty(crossg)
                            deleteStride = 1;

                        else

                            % 1g crossing instant is best estimate of FC. 
                            crossg = crossg(1);
                            
                            lowFC = find(a5locs > strideStart0(1) & a5locs < crossg);
                            HSbuffer = .09*approxST; 
                            HSbufferIndx = HSbuffer*sf;  % number of samples
                            
                            if ~isempty(lowFC)
                                g = 1;
                                while g <= numel(lowFC)
                                    if a5locs(lowFC(g)) < strideStart0(1) + HSbufferIndx
                                        lowFC(g) = [];
                                    else
                                        g = g+1;
                                    end
                                end
                            end

                            if ~isempty(lowFC)
                                lowFC = lowFC(1);
                                crossg = a5locs(lowFC); crossg = crossg(1);
                            end

                            % require crossg be within 320 ms of strideStart0
                            if (crossg - strideStart0(1))/sf > 0.320
                                deleteStride = 1;
                            else
                                % interpolate between current crossg 
                                % (immediately after) and previous to estimate
                                strideStart(i) = (dt - aT5(crossg-1)*time(crossg) + aT5(crossg)*time(crossg-1))/(aT5(crossg) - aT5(crossg-1));
                            end
                        end
                    end
                end
            end
            
           
            if deleteStride
                swingStart(i) = [];
                strideStart(i) = [];
                imin.str(i) = [];
            else
                i = i + 1;
            end

        end
    end
end

% SF adding failsafe because data that was not crossing 0 was leaving this
% code with deleteBout = 0 and empty vectors from StrideStart and
% SwingStart. Should this go further up? 
if isempty(swingStart) || isempty(strideStart)
    deleteBout = 1;
end

 % if not deleting
if ~deleteBout

    % stride ends are stride starts without first
    strideEnd = strideStart;
    strideStart(end) = [];
    strideEnd(1) = [];

    % FC before first swing start not identified, delete
    swingStart(1) = [];

    % get stride endpoints and check times
    nStrides = length(strideStart);
    events.strideStart = zeros(1,nStrides);
    events.strideEnd = zeros(1,nStrides);
    events.swingStart = zeros(1,nStrides);
    events.strideTime = zeros(1,nStrides);
    events.dutyFactor = zeros(1,nStrides);
    i = 1;
    while i <= nStrides

        deleteStride = 0;

        % get stride time
        strideTime0 = strideEnd(i) - strideStart(i);

        % get duty factor
        dutyFactor0 = (swingStart(i)-strideStart(i))/strideTime0;

        % verify stride time/duty factor within constraints
        if strideTime0 > maximumStrideTime || strideTime0 < minimumStrideTime
            deleteStride = 1;
        elseif dutyFactor0 > maximumDutyFactor || dutyFactor0 < minimumDutyFactor
            deleteStride = 1;
        end

        % if didn't meet critieria
        if deleteStride

            % delete stride
            strideEnd(i) = [];
            strideStart(i) = [];
            swingStart(i) = [];
            nStrides = nStrides - 1;
            events.strideStart(i) = [];
            events.strideEnd(i) = [];
            events.strideTime(i) = [];
            events.swingStart(i) = [];
            events.dutyFactor(i) = [];

        % otherwise save
        else

            events.strideStart(i) = strideStart(i);
            events.strideEnd(i) = strideEnd(i);
            events.strideTime(i) = strideTime0;
            events.swingStart(i) = swingStart(i);
            events.dutyFactor(i) = dutyFactor0;
            i = i + 1;

        end

    end

end


events.deleteBout = deleteBout;

    
    
end


