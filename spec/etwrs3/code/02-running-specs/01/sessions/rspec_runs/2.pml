<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<ansii>
$ rspec --format documentation

A cup of coffee
[32m  costs $1[0m
  with milk
[31m    costs $1.25 (FAILED - 1)[0m

Failures:

  1) A cup of coffee with milk costs $1.25
     [31mFailure/Error: expect(coffee.price).to eq(1.25)[0m

     [31m  expected: 1.25[0m
     [31m       got: 1.0[0m

     [31m  (compared using ==)[0m
     [36m# ./spec/coffee_spec.rb:26:in `block (3 levels) in <top (required)>'[0m

Finished in 0.01073 seconds (files took 0.08736 seconds to load)
[31m2 examples, 1 failure[0m

Failed examples:

[31mrspec ./spec/coffee_spec.rb:25[0m [36m# A cup of coffee with milk costs $1.25[0m
</ansii>
