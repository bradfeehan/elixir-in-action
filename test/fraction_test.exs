defmodule FractionTest do
  use ExUnit.Case
  doctest Fraction

  test "creates a fraction with new/2" do
    fraction = Fraction.new(1, 2)
    assert fraction == %Fraction{a: 1, b: 2}
    assert fraction.a == 1
    assert fraction.b == 2
  end

  test "calculates fraction value" do
    fraction = Fraction.new(1, 2)
    assert Fraction.value(fraction) == 0.5

    fraction2 = Fraction.new(3, 4)
    assert Fraction.value(fraction2) == 0.75
  end

  test "adds two fractions" do
    one_half = Fraction.new(1, 2)
    one_quarter = Fraction.new(1, 4)

    result = Fraction.add(one_half, one_quarter)
    assert result == %Fraction{a: 6, b: 8}
    assert Fraction.value(result) == 0.75
  end

  test "example from description: 1/2 + 1/4 = 0.75" do
    result =
      Fraction.new(1, 2)
      |> Fraction.add(Fraction.new(1, 4))
      |> Fraction.value()

    assert result == 0.75
  end

  test "pattern matching on struct" do
    fraction = Fraction.new(3, 5)
    %Fraction{a: a, b: b} = fraction

    assert a == 3
    assert b == 5
  end

  test "updating struct fields" do
    original = Fraction.new(1, 2)
    updated = %Fraction{original | b: 4}

    assert updated == %Fraction{a: 1, b: 4}
    assert Fraction.value(updated) == 0.25
  end

  test "adding fractions with different denominators" do
    # 1/3 + 1/6 = 3/6 = 1/2
    result = Fraction.add(Fraction.new(1, 3), Fraction.new(1, 6))
    assert Fraction.value(result) == 0.5
  end

  test "adding fractions with same denominators" do
    # 2/5 + 3/5 = 5/5 = 1
    result = Fraction.add(Fraction.new(2, 5), Fraction.new(3, 5))
    assert Fraction.value(result) == 1.0
  end
end
