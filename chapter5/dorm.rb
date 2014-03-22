#!/usr/bin/env ruby

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
