function [badin,wasnan,varargout]=statremovenan(varargin)

[badin,wasnan,varargout{1:nargout-2}] = internal.stats.removenan(varargin{:});
