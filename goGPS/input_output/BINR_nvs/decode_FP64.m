function [out, flag] = decode_FP64(in)

% SYNTAX:
%   [out, flag] = decode_FP64(in);
%
% INPUT:
%   in = section of the binary message transmitted by the NVS receiver
%        (string of ones and zeros)
%
% OUTPUT:
%   out  = decoded value
%   flag = validity flag for the decoded value (0: not valid; 1: valid)
%
% DESCRIPTION:
%   Double precision floating point value decoding from BINR format.

%----------------------------------------------------------------------------------------------
%                           goGPS v0.4.3
%
% Copyright (C) 2009-2014 Mirko Reguzzoni, Eugenio Realini
%----------------------------------------------------------------------------------------------
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%----------------------------------------------------------------------------------------------

flag = 1;

sign = str2num(in(1));
esp  = fbin2dec(in(2:12));
mant = fbin2dec(in(13:64)) / 2^52;

if (esp > 0 && esp < 2047)
    out = (-1)^sign * (2^(esp - 1023)) * (1 + mant);
elseif (esp == 0 && mant ~= 0)
    out = (-1)^sign * (2^(-1022)) * mant;
elseif (esp == 0 && mant == 0)
    out = (-1)^sign * 0;
elseif (esp == 2047 && mant == 0)
    out = (-1)^sign * Inf;
    flag = 0;
elseif (esp == 2047 && mant ~= 0)
    out = NaN;
    flag = 0;
end
