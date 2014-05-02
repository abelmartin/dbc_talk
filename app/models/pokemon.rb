class Pokemon < ActiveRecord::Base
  self.inheritance_column = nil #Defending against STI

  TYPES = %w(
    bug dark dragon electric fairy fighting fire flying
    ghost grass ground ice normal poison psychic rock
    shadow steel unknown water
  )

  def self.caught_vs_free(type_filter)
    result = self.order(:type, :id)

    if type_filter.present?
      result = result.where(type: type_filter)
    end

    result.all.partition{|pokemon| pokemon.caught}
  end
end
