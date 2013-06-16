#### Food Finder ####
#
# Launch the Ruby file from the command line
# to get started.
#

APP_ROOT = File.dirname(__FILE__)


### Possible ways to add directories
# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'guide.rb')
# require File.join(APP_ROOT, 'lib', 'guide')

## Question: Why wouldn't you put the ".rb" after guide?

# $:unshift tells ruby to look in what directory for files we require
$:.unshift( File.join(APP_ROOT, 'lib') )
require 'guide'

guide = Guide.new('restaurants.txt')
guide.launch!

# Question: Why doesn't guide.launch! need to be capitalized
# in the same way Guide.new is