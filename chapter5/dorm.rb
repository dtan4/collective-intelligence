#!/usr/bin/env ruby

require "./optimization.rb"

@dorms = %w{Zeus Athena Hercules Bacchus Pluto}
@prefs = [
          { name: "Toby", pref: %w{Bacchus Hercules} },
          { name: "Steve", pref: %w{Zeus Pluto} },
          { name: "Andrea", pref: %w{Athena Zeus} },
          { name: "Sarah", pref: %w{Zeus Pluto} },
          { name: "Dave", pref: %w{Athena Bacchus} },
          { name: "Jeff", pref: %w{Hercules Pluto} },
          { name: "Fred", pref: %w{Pluto Athena} },
          { name: "Suzie", pref: %w{Athena Bacchus} },
          { name: "Laura", pref: %w{Bacchus Hercules} },
          { name: "Neil", pref: %w{Hercules Athena} }
         ]

@domain = []
(@dorms.length * 2).times { |i| @domain << Range.new(0, (@dorms.length) * 2 - i - 1) }


def print_solution(vec)
  slots = []
  @dorms.length.times { |i| slots += [i, i] }

  vec.each_with_index do |v, i|
    x = v.to_i
    dorm = @dorms[slots[x]]
    puts "#{@prefs[i][:name]}, #{dorm}"
    slots.delete_at(x)
  end
end

print_solution([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

def dorm_cost(vec)
  cost = 0
  slots = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4]

  vec.each_with_index do |v, i|
    x = v.to_i
    dorm = @dorms[slots[x]]
    pref = @prefs[i][:pref]

    if pref[0] == dorm
      cost += 0
    elsif pref[1] == dorm
      cost += 1
    else
      cost += 3
    end

    slots.delete_at(x)
  end

  cost
end

s = random_optimize(@domain, "dorm_cost")
puts dorm_cost(s)
print_solution(s)

s = genetic_optimize(@domain, "dorm_cost")
puts dorm_cost(s)
print_solution(s)
