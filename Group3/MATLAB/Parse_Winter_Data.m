%Function to parse Winter's Data
function [data] = Parse_Winter_Data(filename)
[~,sheet_name]= xlsfinfo(filename);

for i=1:numel(sheet_name)
  data{i}=xlsread(filename,sheet_name{i});
end

end

