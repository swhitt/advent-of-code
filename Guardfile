# Guardfile
guard :shell do
  watch(%r{2023/(\d{2})/solution(\d{2})\.rb}) do |m|
    day = m[1] # Assuming the day's folder and the solution file have the same number
    puts "Reloading solution for December #{day}, 2023..."
    `ruby 2023/#{day}/solution#{day}.rb`
  end
end
