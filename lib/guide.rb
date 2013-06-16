require 'restaurant'
require 'support/string_extend'
class Guide

  class Config
    @@actions = ['list', 'find', 'add', 'quit']

    def self.actions
      @@actions
    end
  end

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path # when you call a class from another class require it before you call it
    if Restaurant.file_usable?
      output_action_header("Found restaurant file.")
      # or create a new file
    elsif Restaurant.create_file
      output_action_header("Created restaurant file.")
      # exit if create fails
    else
      puts "Exiting...\n\n"
      exit!
    end
  end

  def launch!
    introduction
    # action loop
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
      # repeat until user quits
    end
    conclusion
  end

  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
      when 'list'
        list(args)
      when 'find'
        keyword = args.shift
        find(keyword)
      when 'add'
        add
      when 'quit'
        return :quit
      else
        puts "\nI don't understand that command.\n"
    end
  end

  def list(args=[])
    sort_order = args.shift
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

    output_action_header("Listing restaurants")

    restaurants = Restaurant.saved_restaurants

    restaurants.sort! do |r1, r2|

      case sort_order
        when 'name'
          r1.name.downcase <=> r2.name.downcase
        when 'cuisine'
          r1.cuisine.downcase <=> r2.cuisine.downcase                       # output_restaurant_table(restaurants)

        when 'price'
          r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine'\n\n"
  end

  def add
    output_action_header("Add a restaurant")
    restaurant = Restaurant.build_using_questions
    if restaurant.save # Why don't we capitalize the R if it is calling the restaurant class?
      puts "\nRestaurant added\n\n"
    else
      puts "\nSave Error: Restaurant not added\n\n"
    end
  end

  def introduction
    output_action_header("<<< Welcome to the Food Finder >>>")
    puts "This is an interactive guide to help you find the food your crave.\n\n"
  end

  def conclusion
    output_action_header("<<< Goodbye and Bon Appetit! >>>\n")
  end

  def find(keyword="")
    output_action_header("Find a restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
            rest.cuisine.downcase.include?(keyword.downcase) ||
            rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
      # search
    else
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: find noodle"
    end
  end

  private # Question: why did we write private here?

  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".rjust(6) + "\n"
    puts "-" * 60
    restaurants.each do |rest|
      line =  " " << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    end
    puts "No listings found" if restaurants.empty?
    puts "-" * 60
  end

end
