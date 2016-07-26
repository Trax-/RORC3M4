class Address

  attr_accessor :state, :location, :city

  def initialize(hash = {})
    @city = hash[:city] unless hash[:city].nil?
    @state = hash[:state] unless hash[:state].nil?
    @location = hash[:loc] unless hash[:loc].nil?
  end

  def mongoize
    {city: @city, state: @state, loc: @location.mongoize}
  end

  def self.mongoize(object)
    case object
      when nil then
        nil
      when Hash then
        object
      when Address then
        object.mongoize
    end
  end

  def self.demongoize(object)
    case object
      when nil then
        nil
      when Address then
        object
      when Hash then
        loc = object[:loc].nil? ? nil : Point.new(object[:loc][:coordinates][0], object[:loc][:coordinates][1])
        Address.new(city: object[:city], state: object[:state], loc: loc)
    end
  end

  def self.evolve(object)
    case object
      when nil then
        nil
      when Hash then
        object
      when Address then
        object.mongoize
    end
  end
end
