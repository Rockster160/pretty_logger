require "coderay"
# https://github.com/rubychan/coderay/blob/master/lib/coderay/encoders/terminal.rb
term_overrides = {
  string: {
    self:      "\e[32m",
    modifier:  "\e[1;32m",
    char:      "\e[1;33m",
    delimiter: "\e[1;32m",
    escape:    "\e[1;32m",
  },
  symbol: {
    self: "\e[36m",
    delimiter: "\e[1;36m",
  },
  # attribute_name: "\e[36m",
  # decorator: "\e[36m",
}
term_overrides.each do |key, val|
  ::CodeRay::Encoders::Terminal::TOKEN_COLORS[key] = val
end
