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

def print_schedule(r)
  0.upto(r.length / 2 - 1) do |i|
    name = @people[i][:name]
    origin = @people[i][:origin]
    out = @flights.select { |fl| (fl[:origin] == origin) && (fl[:destination] == @destination) }[r[i * 2]]
    ret = @flights.select { |fl| (fl[:origin] == @destination) && (fl[:destination] == origin) }[r[i * 2 + 1]]
    printf("%10s%10s %5s-%5s $%3s %5s-%5s $%3s\n",
           name, origin,
           out[:departure], out[:arrive], out[:price],
           ret[:departure], ret[:arrive], ret[:price]
          )
  end
end

print_schedule([4,4,4,2,2,6,6,5,5,6,6,0])
