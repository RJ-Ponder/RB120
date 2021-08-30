class Expander
  def initialize(string)
    @string = string
  end

  def to_s
    expand(3) # removed self call
  end

  private # or could change this to a protected method

  def expand(n)
    @string * n
  end
end

expander = Expander.new('xyz')
puts expander