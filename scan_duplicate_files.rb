# frozen_string_literal: true

require 'find'
require 'digest/md5'
require 'pry'

def scan_duplicate_files(path)
  sizes = {}
  md5s = {}

  Find.find(path) do |file|
    (sizes[File.size(file)] ||= []) << file if File.file?(file)
  end

  sizes.each do |_, files|
    next unless files.size > 1

    files.each do |f|
      digest = Digest::MD5.hexdigest(File.read(f))

      (md5s[digest] ||= []) << f
    end
  end

  paths = md5s.map { |_, v| v }.min_by { |v| -v.size }

  puts "#{File.read(paths.first)} #{paths.length}"
end

scan_duplicate_files(ARGV[0])
