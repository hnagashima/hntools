function updateFromWeb(url,nestedFolder)
    % updateFromWeb downloads the latest version from Github.
    % 
    % updateFromWeb(url, nestedFolder);
    % Input: 
    % - url: path to the original file on the web,
    %  i.e. url = 'https://github.com/altmany/export_fig/archive/master.zip')
    % - nestedFolder: Path to the nested File.
    %  i.e. nestedFolder = '/Users/user/Documents/Program/' % Fullpath
    %  i.e. nestedFolder = mfilename('fullpath') % original file of the program.
    %
    % Original function is a part of export_fig (modified by Hiroki Nagashima.
    % 
    try
        zipFileName = url;
        folderName =  nestedFolder;% fileparts(which(nestedFolder));
        targetFullFileName = fullfile(folderName, datestr(now,'yyyy-mm-dd.zip'));
        urlwrite(zipFileName,targetFullFileName); % copy from url.
    catch
        error('Could not download %s into %s\n',zipFileName,targetFullFileName);
    end

    % Unzip the downloaded zip file
    try
        unzip(targetFullFileName,folderName);
    catch
        error('export_fig:update:unzip','Could not unzip %s\n',targetFullFileName);
    end

    % Notify the user and rehash
    folder = hyperlink(['matlab:winopen(''' folderName ''')'], folderName);
    clear functions %#ok<CLFUNC>
    rehash; % refresh function and file system caches
    delete(targetFullFileName); % delete zip file.
    fprintf('Successfully downloaded\n');
end