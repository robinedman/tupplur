def cd_to_here
  root_directory = File.expand_path(File.dirname(__FILE__))
  Dir.chdir(root_directory)
end
