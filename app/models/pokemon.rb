class Pokemon < ActiveRecord::Base
  self.inheritance_column = nil #Fighting STI
end
