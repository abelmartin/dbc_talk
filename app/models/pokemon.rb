class Pokemon < ActiveRecord::Base
  self.inheritance_column = nil #Defending against STI
end
