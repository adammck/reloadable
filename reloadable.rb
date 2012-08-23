#!/usr/bin/env ruby


def something_really_expensive
  rand
end


module Reloadable
  def reloadable &block
    Reloader.new do
      class_eval &block
    end
  end
end


class Reloader
  def initialize &block
    @block = block
    reload!
  end

  def reload!
    @element = @block.call
  end

  def method_missing name, *args
    @element.send name, *args
  end

  def respond_to_missing? name, include_private=false
    @element.respond_to? name, include_private
  end
end


# This class is a totally arbitrary class

class Element
  extend Reloadable
  attr_reader :value

  def initialize value
    puts "New Element!"
    @value = value
  end
end


element = Element.reloadable do
  new something_really_expensive
end


1.upto(999) do |n|
  puts element.value

  if n % 5 == 0
    element.reload!
  end

  sleep 1
end
