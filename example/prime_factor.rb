class PrimeFactor
  def initialize(number)
    @factors = Fiber.new do
      divisor = 2
      while divisor < number
        while number % divisor == 0
          Fiber.yield divisor
          number = number / divisor
        end
        divisor = divisor + 1
      end
      Fiber.yield number if number > 1
    end
  end

  def next
    @factors.resume
  end
end
