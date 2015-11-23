require 'pg'
require 'faker'
require 'pry'
require_relative "helper"

system 'psql brussels_sprouts_recipes < schema.sql'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

COMMENTS = []

30.times do
  COMMENTS << Faker::Lorem.sentence
end

helper = Helper.new("brussels_sprouts_recipes")

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end

def recipe_seed(helper)
  sql_command = "INSERT INTO recipes (name) VALUES ($1);"
  TITLES.each do |name|
    data = [name]
    helper.insert(sql_command, data)
  end
end

def comment_seed(helper)
  sql_command = "INSERT INTO comments (comment, comment_id) VALUES ($1, $2);"
  COMMENTS.each do |comment|
    comment_id = rand(1..10)
    data = [comment, comment_id]
    helper.insert(sql_command, data)
  end
end

recipe_seed(helper)
comment_seed(helper)

#How many recipes are there in total?
recipe_total = helper.read("SELECT COUNT(*) FROM recipes;").first
puts "There are #{recipe_total["count"]} recipes"

#How many comments are there in total?
comment_total = helper.read("SELECT COUNT(*) FROM comments;").first
puts "There are #{comment_total["count"]} comments"
# binding.pry

#How would you find out how many comments each of the recipes have?

#
