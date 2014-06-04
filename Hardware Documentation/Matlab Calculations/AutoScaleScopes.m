function AutoScaleScopes()
% find all scope blocks as MATLAB figures & Set to autoscale:
set(0, 'showhiddenhandles', 'on')
scope = findobj(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
for i=1:length(scope)
  % this is the callback of the "autoscale" button:
  simscope('ScopeBar', 'ActionIcon', 'Find', scope(i))
end
set(0, 'showhiddenhandles', 'off')
