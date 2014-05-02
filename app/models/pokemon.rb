class Pokemon < ActiveRecord::Base
  self.inheritance_column = nil #Defending against STI

  TYPES = %w(
    bug dark dragon electric fairy fighting fire flying
    ghost grass ground ice normal poison psychic rock
    shadow steel unknown water
  )

  attr_accessor :capture_message, :release_message

  before_save :check_quotas

  def self.caught_vs_free(type_filter)
    result = self.order(:type, :id)

    if type_filter.present?
      result = result.where(type: type_filter)
    end

    result.all.partition{|pokemon| pokemon.caught}
  end

  def capture
    self.caught = true

    if self.save
      self.capture_message = "Caught #{name.upcase}!"
    else
      self.capture_message = "damn Damn DAMN! #{name.upcase} got away!"
    end

    NotificationService.tell_friends capture_message
  end

  def release
    self.caught = false
    self.save
    self.release_message = "#{name.upcase} was released back into the wild"
    NotificationService.tell_friends release_message
  end

  private

  def check_quotas
    if caught
      caught_count = Pokemon.where(type: type, caught: true).count
      caught_count < 2 && Pokemon::TYPES.include?( type )
    end
  end
end
