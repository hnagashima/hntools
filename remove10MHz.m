function tresr_object = remove10MHz(tresr_object)
% This function removes 10 MHz noise on the tresr data obtained from
% ESR of Bunseki-Center, Saitama University.

%% 複数のデータをそれぞれ処理する。
if numel(tresr_object) > 1
    for k = 1:numel(tresr_object)
        tresr_object(k) = remove10MHz(tresr_object(k));
        
    end
    return
end

%% main process
data = tresr_object.Z;
% field = tresr_object.field;
time = tresr_object.time;

dt = time(2) - time(1); % us.
numberOfPoints = round(0.1/dt); % In total 100 ns.

moved_data = movmean(data,numberOfPoints,2); % moving average for time.
tresr_object.Z = moved_data;

end