function [result,c]=classification(net, new_inputs, new_targets)
% Test Network
outputs = sim(net,new_inputs);
[c,cm] = confusion(new_targets,outputs);
if cm(1,1)==1 || cm(2,1)==1
result='Normal';
elseif cm(1,2)==1 || cm(2,2)==1
result='Cancer';
end