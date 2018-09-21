# frozen_string_literal: true

require 'find'
require 'digest/md5'
require 'pry'

def scan_duplicate_files(path)
  sizes = {}
  md5s = {}

  Dir.glob("#{path}/**/*") do |file|
    (sizes[File.size(file)] ||= []) << file if File.file?(file)
  end

  sizes.each do |_, files|
    next if files.size == 1

    files.each do |f|
      digest = Digest::MD5.hexdigest(File.read(f))

      (md5s[digest] ||= []) << f
    end
  end

  paths = md5s.map { |_, v| v }.max_by { |v| v.size }

  puts "#{File.read(paths.first)} #{paths.length}"
end

scan_duplicate_files(ARGV[0])
