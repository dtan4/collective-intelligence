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
