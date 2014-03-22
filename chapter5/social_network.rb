#!/usr/bin/env ruby

require "./optimization.rb"

@people = %w{Charlie Augustus Veruca Violet Mike Joe Willy Miranda}
@links = [
          %w{Augustus Willy},
          %w{Mike Joe},
          %w{Miranda Mike},
          %w{Violet Augustus},
          %w{Miranda Willy},
          %w{Charlie Mike},
          %w{Veruca Joe},
          %w{Miranda Augustus},
          %w{Joe Charlie},
          %w{Veruca Augustus},
          %w{Miranda Violet}
         ]

def cross_count(v)
  loc = {}
  @people.length.times { |i| loc[@people[i]] = [v[i * 2], v[i * 2 + 1]] }
  total = 0

  (0...@links.length).each do |i|
    (i+1...@links.length).each do |j|
      v1, v2 = loc[@links[i][0]], loc[@links[i][1]]
      v3, v4 = loc[@links[j][0]], loc[@links[j][1]]
      den = (v4[1] - v3[1]) * (v2[0] - v1[0]) - (v4[0] - v3[0]) * (v2[1] - v1[1])

      next if den == 0

      ua = ((v4[0] - v3[0]) * (v1[1] - v3[1]) - (v4[1] - v3[1]) * (v1[0] - v3[0])) / den
      ub = ((v2[0] - v1[0]) * (v1[1] - v3[1]) - (v2[1] - v1[1]) * (v1[0] - v3[0])) / den

      total += 1 if (ua > 0) && (ua < 1) && (ub > 0) && (ub < 1)
    end
  end

  total
end

domain = []
(@people.length * 2).times { domain << (10..370) }

sol = random_optimize(domain, "cross_count")
puts cross_count(sol)
p sol

sol = annealing_optimize(domain, "cross_count")
puts cross_count(sol)
p sol

sol = genetic_optimize(domain, "cross_count")
puts cross_count(sol)
p sol
