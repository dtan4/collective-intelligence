#!/usr/bin/env ruby

@people = [
           { name: "Seymour", origin: "BOS" },
           { name: "Franny", origin: "DAL" },
           { name: "Zooey", origin: "CAK" },
           { name: "Walt", origin: "MIA" },
           { name: "Buddy", origin: "ORD" },
           { name: "Les", origin: "OMA" }
          ]
@destination = "LGA"

@flights = []

open("schedule.txt").each do |line|
  origin, destination, departure, arrive, price = line.strip.split(",")
  @flights << {
               origin: origin,
               destination: destination,
               departure: departure,
               arrive: arrive,
               price: price.to_i
              }
end

def get_minutes(t)
  hour, minute = t.split(":")
  hour.to_i * 60 + minute.to_i
end

def select_flights(origin, destination)
  @flights.select { |fl| (fl[:origin] == origin) && (fl[:destination] == destination) }
end

def print_schedule(r)
  0.upto(r.length / 2 - 1) do |i|
    name = @people[i][:name]
    origin = @people[i][:origin]
    out = select_flights(origin, @destination)[r[i * 2]]
    ret = select_flights(@destination, origin)[r[i * 2 + 1]]
     printf("%10s%10s %5s-%5s $%3s %5s-%5s $%3s\n",
           name, origin,
           out[:departure], out[:arrive], out[:price],
           ret[:departure], ret[:arrive], ret[:price]
          )
  end
end

s = [4,4,4,2,2,6,6,5,5,6,6,0]

print_schedule(s)

def schedule_cost(sol)
  total_price = 0
  latest_arrival = 0
  earliest_departure = 24 * 60

  0.upto(sol.length / 2 - 1) do |i|
    origin = @people[i][:origin]
    out = select_flights(origin, @destination)[sol[i * 2]]
    ret = select_flights(@destination, origin)[sol[i * 2 + 1]]

    total_price += (out[:price] + ret[:price])

    out_arrival = get_minutes(out[:arrive])
    ret_departure = get_minutes(ret[:departure])
    latest_arrival = out_arrival if latest_arrival < out_arrival
    earliest_departure = ret_departure if earliest_departure > ret_departure
  end

  total_wait = 0

  0.upto(sol.length / 2 - 1) do |i|
    origin = @people[i][:origin]
    out = select_flights(origin, @destination)[sol[i * 2]]
    ret = select_flights(@destination, origin)[sol[i * 2 + 1]]
    total_wait += latest_arrival - get_minutes(out[:arrive])
    total_wait += get_minutes(ret[:departure]) - earliest_departure
  end

  total_price += 50 if latest_arrival < earliest_departure

  total_price + total_wait
end

puts "cost: #{schedule_cost(s)}"

def random_optimize(domain, cost_func)
  best = 999999999
  bestr = nil

  (0...1000).each do |i|
    r = []
    domain.each { |dm| r << Random.rand(dm)}
    cost = self.send(cost_func, r)

    if cost < best
      best = cost
      bestr = r
    end
  end

  bestr
end

domain = []
(@people.length * 2).times { domain << (0..9) }
s = random_optimize(domain, "schedule_cost")
puts "best cost by random: #{schedule_cost(s)}"
print_schedule(s)

def hillclimb(domain, cost_func)
  sol = []
  domain.each { |dm| sol << Random.rand(dm) }

  loop do
    neighbors = []

    domain.length.times do |i|
      neighbors << sol[0...i] + [sol[i] - 1] + sol[i+1..-1] if sol[i] > domain[i].first
      neighbors << sol[0...i] + [sol[i] + 1] + sol[i+1..-1] if sol[i] < domain[i].last
    end

    current = self.send(cost_func, sol)
    best = current

    neighbors.each do |nb|
      cost = self.send(cost_func, nb)

      if cost < best
        best = cost
        sol = nb
      end
    end

    break if best == current
  end

  sol
end

s = hillclimb(domain, "schedule_cost")
puts "best cost by hillclimb: #{schedule_cost(s)}"
print_schedule(s)

def annealing_optimize(domain, cost_func, t = 10000.0, cool = 0.95, step = 1)
  vec = []
  domain.each { |dm| vec << Random.rand(dm).to_f }

  while t > 0.1
    i = Random.rand(0...domain.length)
    direction = Random.rand(-step..step)
    vecb = vec[0..-1]
    vecb[i] += direction

    if vecb[i] < domain[i].first
      vecb[i] = domain[i].first
    elsif vecb[i] > domain[i].last
      vecb[i] = domain[i].last
    end

    ea = self.send(cost_func, vec)
    eb = self.send(cost_func, vecb)
    prob = Math::E**(-1.0 * (eb - ea).abs / t)

    vec = vecb if (eb < ea) || (Random.rand < prob)

    t *= cool
  end

  return vec
end

s = annealing_optimize(domain, "schedule_cost")
puts "best cost by annealing: #{schedule_cost(s)}"
print_schedule(s)

def mutate(domain, step, vec)
  i = Random.rand(0...domain.length)

  if (Random.rand < 0.5) && (vec[i] > domain[i].first)
    vec[0...i] + [vec[i] - step] + vec[i+1..-1]
  elsif vec[i] < domain[i].last
    vec[0...i] + [vec[i] + step] + vec[i+1..-1]
  end
end

def crossover(domain, r1, r2)
  i = Random.rand(1...domain.length-1)
  r1[0...i] + r2[i..-1]
end

def genetic_optimize(domain, cost_func,
                     pop_size = 50, step = 1, mut_prob = 0.2, elite = 0.2, maxiter = 100)
  pop = []

  pop_size.times do
    vec = []
    domain.each { |dm| vec << Random.rand(dm) }
    pop << vec
  end

  top_elite = (elite * pop_size).to_i
  scores = []

  maxiter.times do
    scores = []

    pop.each do |pp|
      next unless pp
      scores << [self.send(cost_func, pp), pp]
    end

    scores.sort_by! { |sc| sc[0] }
    ranked = []
    scores.each { |sc| ranked << sc[1] }

    pop = ranked[0...top_elite]

    while pop.length < pop_size
      if Random.rand < mut_prob
        c = Random.rand(0..top_elite)
        pop << mutate(domain, step, ranked[c])
      else
        c1 = Random.rand(0..top_elite)
        c2 = Random.rand(0..top_elite)
        pop << crossover(domain, ranked[c1], ranked[c2])
      end
    end
  end

  scores[0][1]
end

s = genetic_optimize(domain, "schedule_cost")
puts "best cost by genetic: #{schedule_cost(s)}"
print_schedule(s)
